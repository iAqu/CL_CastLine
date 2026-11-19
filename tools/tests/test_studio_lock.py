import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import time
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "studio_lock.py"
SPEC = importlib.util.spec_from_file_location("studio_lock", SCRIPT)
LOCK = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(LOCK)
RESOURCE = "place:84106335829275"


class StudioLockTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.path = Path(self.temp.name) / "queue.sqlite3"
        self.registry = LOCK.Registry(self.path)

    def tearDown(self):
        self.registry.close()
        self.temp.cleanup()

    def acquire(self, thread, resource=RESOURCE):
        return self.registry.acquire(resource, thread, "isolated test")

    def expire(self, ticket):
        self.registry.db.execute(
            "UPDATE reservations SET heartbeat = ? WHERE ticket = ?",
            (time.time() - LOCK.STALE_SECONDS - 10, ticket),
        )

    def cli(self, *args):
        return subprocess.run(
            [sys.executable, str(SCRIPT), "--db", str(self.path), *args],
            capture_output=True, text=True, timeout=15,
        )

    def test_fifo_cannot_be_bypassed_and_reacquire_is_idempotent(self):
        a, b, c = [self.acquire(thread) for thread in ("a", "b", "c")]
        self.assertEqual([a["phase"], b["phase"], c["phase"]], ["held", "queued", "queued"])
        self.assertEqual(self.acquire("a")["token"], a["token"])
        self.assertEqual(self.acquire("b")["ticket"], b["ticket"])
        self.registry.remove(a["token"])
        self.assertEqual(self.registry.heartbeat(c["token"], promote=True)["phase"], "queued")
        self.assertEqual(self.registry.heartbeat(b["token"], promote=True)["phase"], "held")
        self.registry.remove(b["token"])
        self.assertEqual(self.registry.heartbeat(c["token"], promote=True)["phase"], "held")

    def test_same_place_alias_and_independent_places(self):
        self.acquire("a")
        self.assertEqual(self.acquire("b", "place:084106335829275")["phase"], "queued")
        self.assertEqual(self.acquire("b", "place:123456789")["phase"], "held")
        self.assertEqual(len(self.registry.status(RESOURCE)["reservations"]), 2)
        for invalid in ("dev", "place:0", "file:relative.rbxl"):
            with self.assertRaises(LOCK.LockError):
                self.acquire("bad", invalid)

    def test_local_file_aliases_share_reservation(self):
        original = Path(self.temp.name) / "reference.rbxl"
        original.touch()
        alias = Path(self.temp.name) / "alias.rbxl"
        alias.symlink_to(original)
        self.acquire("a", "file:" + str(original))
        self.assertEqual(self.acquire("b", "file:" + str(alias))["phase"], "queued")

    def test_test_cleanup_is_required_before_release(self):
        a = self.acquire("a")
        b = self.acquire("b")
        with self.assertRaises(LOCK.LockError):
            self.registry.test_state(b["token"], True)
        self.registry.test_state(a["token"], True)
        with self.assertRaises(LOCK.LockError):
            self.registry.remove(a["token"])
        self.assertTrue(self.registry.status()["reservations"][0]["needs_stop"])
        missing_confirmation = self.cli("test-stopped", "--token", a["token"])
        self.assertNotEqual(missing_confirmation.returncode, 0)
        self.assertTrue(self.registry.status()["reservations"][0]["needs_stop"])
        stopped = self.cli("test-stopped", "--token", a["token"], "--confirmed-studio-edit")
        self.assertEqual(stopped.returncode, 0, stopped.stderr)
        self.registry.remove(a["token"])
        with self.assertRaises(LOCK.LockError):
            self.registry.heartbeat(a["token"], promote=True)

    def test_cancel_requires_queued_token_and_removes_only_own_ticket(self):
        a, b, c = [self.acquire(thread) for thread in ("a", "b", "c")]
        with self.assertRaises(LOCK.LockError):
            self.registry.remove(a["token"], cancel=True)
        with self.assertRaises(LOCK.LockError):
            self.registry.remove(b["token"])
        with self.assertRaises(LOCK.LockError):
            self.registry.remove("unknown", cancel=True)
        self.registry.remove(b["token"], cancel=True)
        self.registry.remove(a["token"])
        self.assertEqual(self.registry.heartbeat(c["token"], promote=True)["phase"], "held")

    def test_expired_holder_and_queue_head_are_reported_without_skipping(self):
        a, b, c = [self.acquire(thread) for thread in ("a", "b", "c")]
        self.expire(a["ticket"])
        self.assertTrue(self.registry.status()["reservations"][0]["stale"])
        waiting = self.registry.heartbeat(b["token"], promote=True)
        self.assertEqual(waiting["phase"], "queued")
        self.assertEqual(waiting["stale_blocker"]["ticket"], a["ticket"])
        self.registry.remove(a["token"])
        self.expire(b["ticket"])
        waiting = self.registry.heartbeat(c["token"], promote=True)
        self.assertEqual(waiting["phase"], "queued")
        self.assertEqual(waiting["stale_blocker"]["ticket"], b["ticket"])

    def test_recovery_checks_identity_confirmation_and_latest_heartbeat(self):
        a = self.acquire("a")
        with self.assertRaises(LOCK.LockError):
            self.registry.recover(RESOURCE, a["ticket"], "a", True, True)
        self.expire(a["ticket"])
        for thread, inactive, edit in (("wrong", True, True), ("a", False, True), ("a", True, False)):
            with self.assertRaises(LOCK.LockError):
                self.registry.recover(RESOURCE, a["ticket"], thread, inactive, edit)
        self.registry.heartbeat(a["token"])
        with self.assertRaises(LOCK.LockError):
            self.registry.recover(RESOURCE, a["ticket"], "a", True, True)
        self.registry.test_state(a["token"], True)
        self.expire(a["ticket"])
        self.registry.recover(RESOURCE, a["ticket"], "a", True, True)
        self.assertEqual(self.registry.status()["reservations"], [])

    def test_cli_wait_timeout_preserves_ticket_then_acquires(self):
        a, b = self.acquire("a"), self.acquire("b")
        waiting = self.cli("wait", "--token", b["token"], "--timeout", "0")
        self.assertEqual(waiting.returncode, 2, waiting.stderr)
        result = json.loads(waiting.stdout)
        self.assertEqual(result["ticket"], b["ticket"])
        self.assertNotIn("stale_blocker", result)
        self.registry.remove(a["token"])
        held = self.cli("wait", "--token", b["token"], "--timeout", "0")
        self.assertEqual(held.returncode, 0, held.stderr)
        self.assertEqual(json.loads(held.stdout)["phase"], "held")

    def test_cli_confirmed_recovery_of_stale_blockers_preserves_fifo(self):
        holder, expired_waiter, next_waiter = [self.acquire(thread) for thread in ("a", "b", "c")]
        self.registry.test_state(holder["token"], True)
        self.expire(holder["ticket"])
        self.expire(expired_waiter["ticket"])

        acquire = self.cli("acquire", "--resource", RESOURCE, "--thread", "d", "--purpose", "recovery")
        self.assertEqual(acquire.returncode, 2, acquire.stderr)
        waiter = json.loads(acquire.stdout)
        self.assertEqual(waiter["stale_blocker"]["ticket"], holder["ticket"])
        self.assertTrue(waiter["stale_blocker"]["needs_stop"])

        wait_args = ("wait", "--token", waiter["token"], "--timeout", "0")
        for expected in (holder, expired_waiter):
            wait = self.cli(*wait_args)
            self.assertEqual(wait.returncode, 2, wait.stderr)
            blocker = json.loads(wait.stdout)["stale_blocker"]
            self.assertEqual(blocker["ticket"], expected["ticket"])
            self.assertNotIn("token", blocker)
            recovered = self.cli(
                "recover", "--resource", blocker["resource"], "--ticket", str(blocker["ticket"]),
                "--thread", blocker["thread"], "--confirmed-thread-inactive", "--confirmed-studio-edit",
            )
            self.assertEqual(recovered.returncode, 0, recovered.stderr)
            self.assertEqual(json.loads(recovered.stdout)["recovered_ticket"], expected["ticket"])

        waiting = self.cli(*wait_args)
        self.assertEqual(waiting.returncode, 2, waiting.stderr)
        result = json.loads(waiting.stdout)
        self.assertEqual(result["ticket"], waiter["ticket"])
        self.assertNotIn("stale_blocker", result)
        self.assertEqual(self.registry.heartbeat(next_waiter["token"], promote=True)["phase"], "held")
        self.registry.remove(next_waiter["token"])
        held = self.cli(*wait_args)
        self.assertEqual(held.returncode, 0, held.stderr)
        self.assertEqual(json.loads(held.stdout)["phase"], "held")

    def test_cli_wait_wakes_on_release(self):
        a, b = self.acquire("a"), self.acquire("b")
        child = subprocess.Popen(
            [sys.executable, str(SCRIPT), "--db", str(self.path), "wait",
             "--token", b["token"], "--timeout", "5"],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
        )
        try:
            self.registry.remove(a["token"])
            stdout, stderr = child.communicate(timeout=10)
            self.assertEqual(child.returncode, 0, stderr)
            self.assertEqual(json.loads(stdout)["phase"], "held")
        finally:
            if child.poll() is None:
                child.kill()
                child.communicate()

    def test_multiprocess_contention_has_one_holder_and_fifo(self):
        children = [subprocess.Popen(
            [sys.executable, str(SCRIPT), "--db", str(self.path), "acquire",
             "--resource", RESOURCE, "--thread", f"worker-{i}", "--purpose", "race"],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
        ) for i in range(12)]
        results = []
        try:
            for child in children:
                stdout, stderr = child.communicate(timeout=15)
                self.assertIn(child.returncode, (0, 2), stderr)
                results.append(json.loads(stdout))
        finally:
            for child in children:
                if child.poll() is None:
                    child.kill()
                    child.communicate()
        self.assertEqual(sum(row["phase"] == "held" for row in results), 1)
        results.sort(key=lambda row: row["ticket"])
        for index, row in enumerate(results):
            if index + 1 < len(results):
                self.assertEqual(self.registry.heartbeat(results[index + 1]["token"], promote=True)["phase"], "queued")
            self.assertEqual(self.registry.heartbeat(row["token"], promote=True)["phase"], "held")
            self.registry.remove(row["token"])
        self.assertEqual(self.registry.status()["reservations"], [])


if __name__ == "__main__":
    unittest.main()
