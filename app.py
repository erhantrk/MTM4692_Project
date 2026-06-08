"""MTM4692 — E-Commerce Database Explorer (Flask backend).

Single-page admin UI for inspecting the SQLite database. All SQL is loaded
from the .sql files on disk so the UI never diverges from the source files.
"""

import os
import re
import sqlite3
from pathlib import Path

from flask import Flask, jsonify, render_template, request

BASE_DIR = Path(__file__).parent
DB_PATH = BASE_DIR / "project.db"
SCHEMA_SQL = BASE_DIR / "queries.sql"
SEED_SQL = BASE_DIR / "seed.sql"
VIEWS_SQL = BASE_DIR / "views.sql"

app = Flask(__name__)


# ---------- DB helpers -------------------------------------------------------

def connect_rw():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    return conn


def connect_ro():
    uri = f"file:{DB_PATH}?mode=ro"
    conn = sqlite3.connect(uri, uri=True)
    conn.row_factory = sqlite3.Row
    return conn


def rows_to_payload(cursor):
    cols = [d[0] for d in cursor.description] if cursor.description else []
    rows = [list(r) for r in cursor.fetchall()]
    return {"columns": cols, "rows": rows, "row_count": len(rows)}


# ---------- SQL file parsing -------------------------------------------------

def split_sql_statements(sql_text: str):
    """Naive splitter — fine for our hand-written .sql files (no string ';')."""
    statements = []
    buf = []
    for line in sql_text.splitlines():
        if line.strip().startswith("--") or not line.strip():
            buf.append(line)
            continue
        buf.append(line)
        if line.rstrip().endswith(";"):
            stmt = "\n".join(buf).strip()
            if stmt:
                statements.append(stmt)
            buf = []
    if buf:
        tail = "\n".join(buf).strip()
        if tail:
            statements.append(tail)
    return statements


QUERY_HEADER_RE = re.compile(r"--\s*Query\s+(\d+)\s*:\s*(.+)", re.IGNORECASE)


def load_named_queries():
    """Parse queries.sql and return [{id, title, sql}] for each `-- Query N: ...` block."""
    text = SCHEMA_SQL.read_text()
    lines = text.splitlines()
    blocks = []
    current = None
    for line in lines:
        m = QUERY_HEADER_RE.match(line.strip())
        if m:
            if current:
                blocks.append(current)
            current = {
                "id": int(m.group(1)),
                "title": m.group(2).strip(),
                "lines": [],
            }
        elif current is not None:
            current["lines"].append(line)
    if current:
        blocks.append(current)

    results = []
    for b in blocks:
        sql = "\n".join(b["lines"]).strip()
        # keep only up to the first standalone terminator (handles trailing comments)
        # our blocks are single statements so just trust the trailing ;
        results.append({"id": b["id"], "title": b["title"], "sql": sql})
    return results


def load_views():
    text = VIEWS_SQL.read_text()
    pattern = re.compile(r"CREATE\s+VIEW\s+(\w+)\s+AS", re.IGNORECASE)
    names = pattern.findall(text)
    return names


# ---------- Routes -----------------------------------------------------------

@app.route("/")
def index():
    return render_template("index.html")


@app.route("/api/schema")
def api_schema():
    conn = connect_ro()
    tables = []
    rows = conn.execute(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name"
    ).fetchall()
    for r in rows:
        tname = r["name"]
        cols = conn.execute(f"PRAGMA table_info({tname})").fetchall()
        fks = conn.execute(f"PRAGMA foreign_key_list({tname})").fetchall()
        row_count = conn.execute(f"SELECT COUNT(*) AS c FROM {tname}").fetchone()["c"]
        tables.append({
            "name": tname,
            "row_count": row_count,
            "columns": [
                {
                    "name": c["name"],
                    "type": c["type"],
                    "notnull": bool(c["notnull"]),
                    "pk": bool(c["pk"]),
                }
                for c in cols
            ],
            "foreign_keys": [
                {"column": fk["from"], "references": f"{fk['table']}({fk['to']})"}
                for fk in fks
            ],
        })
    views = conn.execute(
        "SELECT name FROM sqlite_master WHERE type='view' ORDER BY name"
    ).fetchall()
    conn.close()
    return jsonify({"tables": tables, "views": [v["name"] for v in views]})


@app.route("/api/queries")
def api_queries():
    return jsonify(load_named_queries())


@app.route("/api/query/<int:qid>")
def api_run_query(qid):
    queries = {q["id"]: q for q in load_named_queries()}
    if qid not in queries:
        return jsonify({"error": f"Query {qid} not found"}), 404
    q = queries[qid]
    conn = connect_ro()
    try:
        cur = conn.execute(q["sql"])
        payload = rows_to_payload(cur)
    except sqlite3.Error as e:
        conn.close()
        return jsonify({"error": str(e), "sql": q["sql"]}), 400
    conn.close()
    payload["sql"] = q["sql"]
    payload["title"] = f"Query {q['id']}: {q['title']}"
    return jsonify(payload)


@app.route("/api/views")
def api_views():
    return jsonify(load_views())


@app.route("/api/view/<name>")
def api_run_view(name):
    if not re.fullmatch(r"vw_\w+", name):
        return jsonify({"error": "Invalid view name"}), 400
    conn = connect_ro()
    try:
        cur = conn.execute(f"SELECT * FROM {name}")
        payload = rows_to_payload(cur)
    except sqlite3.Error as e:
        conn.close()
        return jsonify({"error": str(e)}), 400
    conn.close()
    # also return the CREATE VIEW SQL so user can see the definition
    conn2 = connect_ro()
    row = conn2.execute(
        "SELECT sql FROM sqlite_master WHERE type='view' AND name=?", (name,)
    ).fetchone()
    conn2.close()
    payload["sql"] = row["sql"] if row else ""
    payload["title"] = f"View: {name}"
    return jsonify(payload)


@app.route("/api/exec", methods=["POST"])
def api_exec():
    sql = (request.json or {}).get("sql", "").strip()
    if not sql:
        return jsonify({"error": "Empty SQL"}), 400
    stripped = sql.lstrip().lower()
    if not (stripped.startswith("select") or stripped.startswith("with") or stripped.startswith("pragma")):
        return jsonify({"error": "Only SELECT / WITH / PRAGMA statements are allowed."}), 400
    conn = connect_ro()
    try:
        cur = conn.execute(sql)
        payload = rows_to_payload(cur)
    except sqlite3.Error as e:
        conn.close()
        return jsonify({"error": str(e)}), 400
    conn.close()
    payload["sql"] = sql
    payload["title"] = "Ad-hoc SQL"
    return jsonify(payload)


@app.route("/api/reset", methods=["POST"])
def api_reset():
    """Re-build the database from queries.sql (schema only) + seed.sql + views.sql."""
    # Delete existing DB so CREATE TABLE definitions are authoritative
    if DB_PATH.exists():
        DB_PATH.unlink()
    conn = connect_rw()

    # 1. Schema — only the CREATE TABLE statements at the top of queries.sql
    schema_text = SCHEMA_SQL.read_text()
    schema_only = []
    for stmt in split_sql_statements(schema_text):
        upper = stmt.strip().upper()
        # Strip leading comments to find the real verb
        body = "\n".join(
            ln for ln in stmt.splitlines() if not ln.strip().startswith("--")
        ).strip().upper()
        if body.startswith("CREATE TABLE"):
            schema_only.append(stmt)
    conn.executescript("\n".join(schema_only))

    # 2. Seed
    conn.executescript(SEED_SQL.read_text())

    # 3. Views
    conn.executescript(VIEWS_SQL.read_text())

    conn.commit()
    conn.close()
    return jsonify({"ok": True, "message": "Database rebuilt from queries.sql + seed.sql + views.sql"})


if __name__ == "__main__":
    # Build the DB on first run if it's empty
    if not DB_PATH.exists() or os.path.getsize(DB_PATH) < 1000:
        print("Building fresh database...")
        with app.test_request_context():
            api_reset()
    app.run(debug=True, port=5000)
