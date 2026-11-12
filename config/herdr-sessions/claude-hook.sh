#!/bin/sh
set -eu

[ -n "${HC_TERMINAL_ID:-}" ] || exit 0
command -v hc >/dev/null 2>&1 || exit 0

input="$(cat)"

HOOK_INPUT="$input" python3 -I - <<'PY'
import json
import os
import subprocess
import time

address = os.environ["HC_TERMINAL_ID"]
try:
    hook = json.loads(os.environ.get("HOOK_INPUT") or "{}")
except ValueError:
    raise SystemExit(0)
state = os.path.expanduser("~/.local/state/herdr-app-resume")
path = os.path.join(state, f"{address}.json")
event = hook.get("hook_event_name")
if hook.get("agent_id"):
    raise SystemExit(0)
if event == "SessionEnd":
    if hook.get("reason") == "prompt_input_exit":
        try:
            os.remove(path)
        except OSError:
            pass
    raise SystemExit(0)
if event != "SessionStart":
    raise SystemExit(0)
session = hook.get("session_id")
if not isinstance(session, str) or not session:
    raise SystemExit(0)

out = subprocess.run(["hc", "get", address, "--json"], capture_output=True, text=True, timeout=5)
try:
    terminal = json.loads(out.stdout)
except ValueError:
    raise SystemExit(0)
tab = (terminal.get("labels") or {}).get("herdr.tab")
if not tab:
    raise SystemExit(0)

os.makedirs(state, exist_ok=True)
record = {
    "session": session,
    "cwd": hook.get("cwd") or os.getcwd(),
    "pid": terminal.get("pid"),
    "tab": tab,
    "at": int(time.time()),
}
with open(path + ".tmp", "w") as f:
    json.dump(record, f)
os.replace(path + ".tmp", path)
PY
