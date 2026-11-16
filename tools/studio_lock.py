#!/usr/bin/env python3
"""Local FIFO Studio reservations. No Studio calls and no automatic lock stealing."""

import argparse
import contextlib
import json
import os
from pathlib import Path
import re
import sqlite3
import sys
import time
import uuid


STALE_SECONDS = 180
DEFAULT_DB = Path.home() / ".codex" / "studio-locks" / "queue.sqlite3"


class LockError(Exception):
    pass


def resource_key(value):
    if re.fullmatch(r"place:[0-9]+", value) and int(value[6:]) > 0:
        return "place:" + str(int(value[6:]))
    if value.startswith("file:") and Path(value[5:]).is_absolute():
        return "file:" + str(Path(value[5:]).resolve())
    raise LockError("Use place:<positive PlaceId> or file:<absolute local place path>.")


class Registry:
    def __init__(self, path):
        path = Path(path).expanduser()
        path.parent.mkdir(parents=True, exist_ok=True)
        self.db = sqlite3.connect(path, timeout=10, isolation_level=None)
        self.db.row_factory = sqlite3.Row
        self.db.execute("""CREATE TABLE IF NOT EXISTS reservations (
            ticket INTEGER PRIMARY KEY AUTOINCREMENT,
            resource TEXT NOT NULL,
            thread TEXT NOT NULL,
            purpose TEXT NOT NULL,
            token TEXT NOT NULL UNIQUE,
            created REAL NOT NULL,
            heartbeat REAL NOT NULL,
            phase TEXT NOT NULL CHECK (phase IN ('queued', 'held')),
            needs_stop INTEGER NOT NULL DEFAULT 0,
            UNIQUE(resource, thread)
        )""")
        self.db.execute("""CREATE UNIQUE INDEX IF NOT EXISTS one_holder
            ON reservations(resource) WHERE phase = 'held'""")

    def close(self):
        self.db.close()

    @contextlib.contextmanager
    def transaction(self):
        self.db.execute("BEGIN IMMEDIATE")
        try:
            yield
        except BaseException:
            self.db.execute("ROLLBACK")
            raise
        else:
            self.db.execute("COMMIT")

    def row(self, token):
        row = self.db.execute(
            "SELECT * FROM reservations WHERE token = ?", (token,)
        ).fetchone()
        if row is None:
            raise LockError("Unknown or released token; acquire a new reservation.")
        return row

    def describe(self, row, include_token=False):
        result = dict(row)
        if not include_token:
            result.pop("token")
        result["needs_stop"] = bool(result["needs_stop"])
        result["heartbeat_age_seconds"] = max(0, round(time.time() - row["heartbeat"], 1))
        result["stale"] = result["heartbeat_age_seconds"] >= STALE_SECONDS
        result["position"] = 0 if row["phase"] == "held" else self.db.execute(
            "SELECT COUNT(*) FROM reservations WHERE resource = ? AND ticket <= ?",
            (row["resource"], row["ticket"]),
        ).fetchone()[0]
        return result

    def promote(self, token):
        row = self.row(token)
        if row["phase"] == "queued":
            first = self.db.execute(
                "SELECT token FROM reservations WHERE resource = ? ORDER BY ticket LIMIT 1",
                (row["resource"],),
            ).fetchone()
            if first["token"] == token:
                self.db.execute(
                    "UPDATE reservations SET phase = 'held' WHERE token = ?", (token,)
                )

    def acquire(self, resource, thread, purpose):
        resource = resource_key(resource)
        if not resource.strip() or not thread.strip() or not purpose.strip():
            raise LockError("resource, thread and purpose must be nonempty.")
        with self.transaction():
            existing = self.db.execute(
                "SELECT token FROM reservations WHERE resource = ? AND thread = ?",
                (resource, thread),
            ).fetchone()
            token = existing["token"] if existing else uuid.uuid4().hex
            now = time.time()
            if existing:
                self.db.execute(
                    "UPDATE reservations SET heartbeat = ? WHERE token = ?", (now, token)
                )
            else:
                self.db.execute(
                    """INSERT INTO reservations
                    (resource, thread, purpose, token, created, heartbeat, phase)
                    VALUES (?, ?, ?, ?, ?, ?, 'queued')""",
                    (resource, thread, purpose, token, now, now),
                )
            self.promote(token)
            return self.describe(self.row(token), include_token=True)

    def heartbeat(self, token, promote=False):
        with self.transaction():
            self.row(token)
            self.db.execute(
                "UPDATE reservations SET heartbeat = ? WHERE token = ?", (time.time(), token)
            )
            if promote:
                self.promote(token)
            return self.describe(self.row(token), include_token=True)

    def status(self, resource=None):
        if resource is not None:
            resource = resource_key(resource)
        with self.transaction():
            if resource:
                rows = self.db.execute(
                    "SELECT * FROM reservations WHERE resource = ? ORDER BY ticket", (resource,)
                ).fetchall()
            else:
                rows = self.db.execute(
                    "SELECT * FROM reservations ORDER BY resource, ticket"
                ).fetchall()
            return {"reservations": [self.describe(row) for row in rows],
                    "stale_after_seconds": STALE_SECONDS,
                    "automatic_takeover": False}

    def test_state(self, token, started):
        with self.transaction():
            row = self.row(token)
            if row["phase"] != "held":
                raise LockError("Queued reservations cannot use Studio.")
            self.db.execute(
                "UPDATE reservations SET needs_stop = ?, heartbeat = ? WHERE token = ?",
                (int(started), time.time(), token),
            )
            return self.describe(self.row(token), include_token=True)

    def remove(self, token, cancel=False):
        with self.transaction():
            row = self.row(token)
            if cancel and row["phase"] != "queued":
                raise LockError("A held reservation must be released, not cancelled.")
            if not cancel and row["phase"] != "held":
                raise LockError("A queued reservation must be cancelled, not released.")
            if row["needs_stop"]:
                raise LockError("Stop your test, verify Studio is Edit, then run test-stopped.")
            self.db.execute("DELETE FROM reservations WHERE token = ?", (token,))
            return {"removed_ticket": row["ticket"], "resource": row["resource"]}

    def recover(self, resource, ticket, thread, inactive, edit):
        resource = resource_key(resource)
        if not inactive or not edit:
            raise LockError("Recovery requires confirmed inactive thread and Studio Edit state.")
        with self.transaction():
            row = self.db.execute(
                "SELECT * FROM reservations WHERE ticket = ? AND resource = ? AND thread = ?",
                (ticket, resource, thread),
            ).fetchone()
            if row is None:
                raise LockError("Reservation identity no longer matches; recheck status.")
            if time.time() - row["heartbeat"] < STALE_SECONDS:
                raise LockError("Heartbeat is still fresh; do not interrupt this reservation.")
            self.db.execute("DELETE FROM reservations WHERE ticket = ?", (ticket,))
            return {"recovered_ticket": ticket, "resource": resource}


def parser():
    root = argparse.ArgumentParser(description=__doc__)
    root.add_argument("--db", type=Path, default=DEFAULT_DB,
                      help="Override only for isolated tests; normal sessions share the default DB.")
    commands = root.add_subparsers(dest="command", required=True)
    status = commands.add_parser("status")
    status.add_argument("--resource")
    acquire = commands.add_parser("acquire")
    acquire.add_argument("--resource", required=True, help="place:<PlaceId> or file:<absolute path>")
    acquire.add_argument("--thread", default=os.environ.get("CODEX_THREAD_ID"))
    acquire.add_argument("--purpose", required=True)
    for name in ("wait", "heartbeat", "test-started", "test-stopped", "release", "cancel"):
        command = commands.add_parser(name)
        command.add_argument("--token", required=True)
        if name == "wait":
            command.add_argument("--timeout", type=float, default=45,
                                 help="0–50 seconds; timeout preserves your queue position.")
        if name == "test-stopped":
            command.add_argument("--confirmed-studio-edit", action="store_true", required=True)
    recover = commands.add_parser("recover")
    recover.add_argument("--resource", required=True)
    recover.add_argument("--ticket", type=int, required=True)
    recover.add_argument("--thread", required=True)
    recover.add_argument("--confirmed-thread-inactive", action="store_true", required=True)
    recover.add_argument("--confirmed-studio-edit", action="store_true", required=True)
    return root


def main():
    args = parser().parse_args()
    registry = None
    try:
        registry = Registry(args.db)
        if args.command == "status":
            result = registry.status(args.resource)
        elif args.command == "acquire":
            if not args.thread:
                raise LockError("CODEX_THREAD_ID unavailable; supply --thread with the actual chat ID.")
            result = registry.acquire(args.resource, args.thread, args.purpose)
        elif args.command == "wait":
            if not 0 <= args.timeout <= 50:
                raise LockError("wait --timeout must be between 0 and 50 seconds.")
            deadline = time.monotonic() + args.timeout
            while True:
                result = registry.heartbeat(args.token, promote=True)
                remaining = deadline - time.monotonic()
                if result["phase"] == "held" or remaining <= 0:
                    break
                time.sleep(min(1, remaining))
        elif args.command == "heartbeat":
            result = registry.heartbeat(args.token)
        elif args.command in ("test-started", "test-stopped"):
            result = registry.test_state(args.token, args.command == "test-started")
        elif args.command in ("release", "cancel"):
            result = registry.remove(args.token, cancel=args.command == "cancel")
        else:
            result = registry.recover(args.resource, args.ticket, args.thread,
                                      args.confirmed_thread_inactive, args.confirmed_studio_edit)
        print(json.dumps(result, ensure_ascii=False))
        return 2 if result.get("phase") == "queued" else 0
    except (LockError, sqlite3.Error, OSError) as exc:
        print(json.dumps({"error": str(exc)}, ensure_ascii=False), file=sys.stderr)
        return 1
    finally:
        if registry is not None:
            registry.close()


if __name__ == "__main__":
    sys.exit(main())
