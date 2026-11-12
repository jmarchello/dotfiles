#!/usr/bin/env python3
import glob
import json
import os
import re
import shlex
import subprocess
import sys
import time


RESUME = os.path.expanduser("~/.local/state/herdr-app-resume")
TITLES = os.path.expanduser("~/.local/state/herdr-sessions/titles.json")
OLD_TITLES = os.path.expanduser("~/.local/state/herdr-tab-titles/labels.json")
LEAD = re.compile(r"^[^\w~/]+")
WARMUP = 120
INTERVAL = 5


def app(*args):
    out = subprocess.run(["herdr-app", *args], capture_output=True, text=True, timeout=10)
    return json.loads(out.stdout) if out.returncode == 0 and out.stdout.strip() else None


def hc_get(address):
    out = subprocess.run(["hc", "get", address, "--json"], capture_output=True, text=True, timeout=10)
    try:
        terminal = json.loads(out.stdout)
    except ValueError:
        return None
    return None if "error" in terminal else terminal


class Resumer:
    def __init__(self):
        self.started = time.time()
        self.tried = set()

    def run(self, ls):
        live = {}
        for space in ls.get("spaces", []):
            for tab in space.get("tabs", []):
                for t in tab.get("terminals", []):
                    live[t["terminal"]] = (tab["id"], t)
        for path in glob.glob(f"{RESUME}/*.json"):
            address = os.path.basename(path)[:-5]
            try:
                with open(path) as f:
                    record = json.load(f)
            except (OSError, ValueError):
                continue
            if address not in live:
                if time.time() - self.started > WARMUP:
                    terminal = hc_get(address)
                    if not terminal or terminal.get("state") != "live":
                        os.remove(path)
                continue
            tab, entry = live[address]
            if entry.get("app") or tab != record.get("tab"):
                continue
            terminal = hc_get(address)
            if not terminal or terminal.get("pid") == record.get("pid"):
                continue
            if (terminal.get("foreground") or {}).get("name") == "claude":
                continue
            key = (address, terminal.get("pid"))
            if key in self.tried:
                continue
            self.tried.add(key)
            command = f"cd {shlex.quote(record['cwd'])} && claude --resume {shlex.quote(record['session'])}"
            subprocess.run(["hc", "send", address, command], capture_output=True, timeout=10)


def load_json(path, fallback):
    try:
        with open(path) as f:
            return json.load(f)
    except (OSError, ValueError):
        return fallback


def save_json(path, data):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path + ".tmp", "w") as f:
        json.dump(data, f)
    os.replace(path + ".tmp", path)


def clean_title(title):
    title = LEAD.sub("", title or "").strip()
    if not title or title == "Claude Code" or "@" in title or title.startswith(("~", "/")):
        return None
    return title


class Titles:
    def __init__(self):
        self.auto = load_json(TITLES, None)
        self.seed = None if self.auto is not None else set(load_json(OLD_TITLES, {}).values())
        if self.auto is None:
            self.auto = {}

    def run(self, ls):
        changed = False
        for space in ls.get("spaces", []):
            for tab in space.get("tabs", []):
                agent = next((t for t in tab.get("terminals", []) if t.get("app") == "claude-code"), None)
                name = tab.get("name", "")
                if self.seed is not None and name in self.seed:
                    self.auto[tab["id"]] = name
                    changed = True
                if not agent:
                    continue
                if not (name.isdigit() or self.auto.get(tab["id"]) == name):
                    continue
                terminal = hc_get(agent["terminal"])
                title = clean_title((terminal or {}).get("title"))
                if not title or title == name:
                    continue
                if app("do", "tab.rename", json.dumps({"id": tab["id"], "name": title})) is not None:
                    self.auto[tab["id"]] = title
                    changed = True
        self.seed = None
        if changed:
            save_json(TITLES, self.auto)


def sync(resumer, titles):
    ls = app("ls")
    if not ls:
        return
    resumer.run(ls)
    titles.run(ls)


def sources():
    return os.path.getmtime(os.path.abspath(__file__))


def main():
    resumer, titles = Resumer(), Titles()
    started = sources()
    while True:
        try:
            if sources() != started:
                os.execv(sys.executable, [sys.executable, "-I", os.path.abspath(__file__)])
        except OSError:
            pass
        try:
            sync(resumer, titles)
        except Exception as e:
            print(f"herdr-sessions: {e}", file=sys.stderr, flush=True)
        time.sleep(INTERVAL)


if __name__ == "__main__":
    main()
