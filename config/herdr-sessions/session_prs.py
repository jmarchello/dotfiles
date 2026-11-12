#!/usr/bin/env python3
import glob
import json
import os
import re
import subprocess
import sys

PROJECTS = os.path.expanduser("~/.claude/projects")
SESSIONS = os.path.expanduser("~/.claude/sessions")
PR_URL = re.compile(r"https://github\.com/([\w.-]+)/([\w.-]+)/pull/(\d+)")
PR_CREATE = re.compile(r"(?:^|[;&|(]\s*)(?:\w+=\S*\s+)*(?:(?:timeout(?:\s+-\S+)*\s+\S+|env|command|nice(?:\s+-n\s*\S+)?|nohup|time)\s+(?:\w+=\S*\s+)*)*(?:gh|\"?\$\{?GH\}?\"?) pr create\b", re.M)
CREATED_URL = re.compile(r"^https://github\.com/[\w.-]+/[\w.-]+/pull/\d+\s*$", re.M)


def session_id(address):
    out = subprocess.run(["hc", "get", address, "--json"], capture_output=True, text=True, timeout=10)
    pid = json.loads(out.stdout or "{}").get("foreground", {}).get("pid")
    if not pid:
        return None
    try:
        with open(f"{SESSIONS}/{pid}.json") as f:
            return json.load(f).get("sessionId")
    except (OSError, ValueError):
        return None


def result_text(content):
    if isinstance(content, list):
        return "\n".join(c.get("text", "") for c in content if isinstance(c, dict))
    return content if isinstance(content, str) else ""


def scan(path):
    ids, urls = set(), []
    with open(path) as fh:
        for line in fh:
            if "pr create" not in line and "tool_result" not in line:
                continue
            try:
                content = json.loads(line).get("message", {}).get("content")
            except ValueError:
                continue
            if not isinstance(content, list):
                continue
            for b in content:
                if b.get("type") == "tool_use" and PR_CREATE.search(str(b.get("input", {}).get("command", ""))):
                    ids.add(b["id"])
                elif b.get("type") == "tool_result" and b.get("tool_use_id") in ids:
                    for m in CREATED_URL.finditer(result_text(b.get("content"))):
                        url = m.group(0).strip()
                        if url not in urls:
                            urls.append(url)
    return urls


def session_urls(session):
    files = glob.glob(f"{PROJECTS}/*/{session}.jsonl") + glob.glob(f"{PROJECTS}/*/{session}/subagents/*.jsonl")
    found = []
    for f in files:
        for url in scan(f):
            if url not in found:
                found.append(url)
    return found[::-1][:100]


def fetch(urls):
    parts = []
    for i, url in enumerate(urls):
        owner, name, number = PR_URL.match(url).groups()
        parts.append(f"""p{i}: repository(owner: "{owner}", name: "{name}") {{ pullRequest(number: {number}) {{
            number title url state isDraft reviewDecision updatedAt repository {{ nameWithOwner }}
            commits(last: 1) {{ nodes {{ commit {{ statusCheckRollup {{ state }} }} }} }} }} }}""")
    out = subprocess.run(["gh", "api", "graphql", "-f", "query={" + "\n".join(parts) + "}"],
                         capture_output=True, text=True, timeout=60)
    data = json.loads(out.stdout or "{}").get("data")
    if not data:
        raise RuntimeError(out.stderr.strip() or "gh failed")
    return [data[f"p{i}"]["pullRequest"] for i in range(len(urls)) if data.get(f"p{i}")]


def main():
    cmd, args = sys.argv[1], sys.argv[2:]
    try:
        if cmd == "scan":
            session = session_id(args[0])
            print(json.dumps({"session": session, "urls": session_urls(session) if session else []}))
        elif cmd == "fetch":
            print(json.dumps({"prs": fetch(args) if args else []}))
    except Exception as e:
        print(json.dumps({"error": str(e).splitlines()[0] if str(e) else type(e).__name__}))


if __name__ == "__main__":
    main()
