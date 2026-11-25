#!/usr/bin/env python3
"""
Helper utility for the 'tickets' school skill.
Lists, validates, and manages tickets in the tickets/ directory.
"""

import os
import re
import sys
from pathlib import Path

TICKET_PATTERN = re.compile(r"^(\d{4})-([a-z0-9-]+)\.md$")
COMPLETE_PATTERN = re.compile(r"^(\d{4})-([a-z0-9-]+)\.complete\.md$")

def find_tickets_dir(start_path: Path = Path.cwd()) -> Path:
    current = start_path.resolve()
    while current != current.parent:
        candidate = current / "tickets"
        if candidate.is_dir():
            return candidate
        git_dir = current / ".git"
        if git_dir.exists():
            return current / "tickets"
        current = current.parent
    return start_path / "tickets"

def scan_tickets(tickets_dir: Path):
    if not tickets_dir.exists():
        return [], []

    pending = []
    completed = []

    for item in sorted(tickets_dir.iterdir()):
        if not item.is_file():
            continue

        comp_match = COMPLETE_PATTERN.match(item.name)
        if comp_match:
            num = int(comp_match.group(1))
            slug = comp_match.group(2)
            completed.append({"num": num, "slug": slug, "path": item, "file": item.name})
            continue

        pend_match = TICKET_PATTERN.match(item.name)
        if pend_match:
            num = int(pend_match.group(1))
            slug = pend_match.group(2)
            pending.append({"num": num, "slug": slug, "path": item, "file": item.name})
            continue

    pending.sort(key=lambda x: x["num"])
    completed.sort(key=lambda x: x["num"])
    return pending, completed

def main():
    tickets_dir = find_tickets_dir()
    if not tickets_dir.exists():
        print(f"Directory not found: {tickets_dir}")
        print("Run with --init to create the tickets/ directory.")
        if "--init" in sys.argv:
            tickets_dir.mkdir(parents=True, exist_ok=True)
            print(f"Created {tickets_dir}")
        return

    pending, completed = scan_tickets(tickets_dir)

    print(f"=== Tickets in {tickets_dir} ===")
    print(f"Total: {len(pending) + len(completed)} (Pending: {len(pending)}, Completed: {len(completed)})\n")

    if completed:
        print("[Completed Tickets]")
        for t in completed:
            print(f"  [x] {t['num']:04d}-{t['slug']} ({t['file']})")
        print()

    if pending:
        print("[Pending Tickets]")
        for i, t in enumerate(pending):
            marker = "-->" if i == 0 else "   "
            print(f"  {marker} {t['num']:04d}-{t['slug']} ({t['file']})")
        print(f"\nNext ticket up: {pending[0]['num']:04d}-{pending[0]['slug']}")
    else:
        print("No pending tickets remaining! All tickets complete.")

if __name__ == "__main__":
    main()
