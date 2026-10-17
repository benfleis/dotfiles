#!/usr/bin/env python3
"""Archive helper: reserve collision-free archive paths and rebuild the index.

Multi-session safe:
  - `new` reserves a path with O_CREAT|O_EXCL, so two sessions never grab the
    same filename (a taken name bumps to -2, -3, ...).
  - `index` rebuilds MEMORY.md from scratch by scanning frontmatter and writes
    it atomically (tmp + os.replace). The index is derived, so a lost/racing
    rebuild is self-healing -- just run `index` again. Archive files themselves
    are never mutated by the index.

ARCHIVE_DIR resolution:
  $ARCHIVE_DIR
    ?? $XDG_STATE_HOME/agents/archive
    ?? $HOME/.local/state/agents/archive
"""
from __future__ import annotations

import argparse
import datetime
import os
import re
import subprocess
import sys
from pathlib import Path

# Coarse "kind of learning" categories, in index display order. Free-form
# domain labels (duckdb, azure, delta, databricks, ...) go in `tags`.
CATEGORY_ORDER = [
    "build",
    "infrastructure",
    "release",
    "debugging",
    "feature",
    "design",
    "ops",
    "research",
]


def archive_dir() -> Path:
    d = os.environ.get("ARCHIVE_DIR")
    if d:
        return Path(d).expanduser()
    xdg = os.environ.get("XDG_STATE_HOME") or os.path.join(
        os.path.expanduser("~"), ".local", "state"
    )
    return Path(xdg) / "agents" / "archive"


def slugify(s: str) -> str:
    s = s.strip().lower()
    s = re.sub(r"[^a-z0-9]+", "-", s)
    return s.strip("-") or "note"


def detect_project(explicit: str | None) -> str:
    if explicit:
        return slugify(explicit)
    try:
        top = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            capture_output=True,
            text=True,
            check=True,
        ).stdout.strip()
        if top:
            return slugify(os.path.basename(top))
    except Exception:
        pass
    return slugify(os.path.basename(os.getcwd()))


def today() -> str:
    return datetime.date.today().isoformat()


# ----------------------------------------------------------------------------
# frontmatter parsing (tiny YAML subset -- no pyyaml dependency)
# ----------------------------------------------------------------------------
def parse_frontmatter(text: str) -> dict:
    if not text.startswith("---"):
        return {}
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return {}
    fm = {}
    for line in lines[1:]:
        if line.strip() == "---":
            break
        m = re.match(r"^([A-Za-z_][\w-]*):\s*(.*)$", line)
        if not m:
            continue
        key, val = m.group(1).strip(), m.group(2).strip()
        if val.startswith("[") and val.endswith("]"):
            items = [v.strip().strip("'\"") for v in val[1:-1].split(",")]
            fm[key] = [v for v in items if v]
        else:
            fm[key] = val.strip("'\"")
    return fm


# ----------------------------------------------------------------------------
# commands
# ----------------------------------------------------------------------------
def cmd_new(args) -> int:
    root = archive_dir()
    project = detect_project(args.project)
    date = today()
    day_dir = root / date
    day_dir.mkdir(parents=True, exist_ok=True)

    slug = slugify(args.slug)
    base = f"{project}--{slug}"
    for n in range(1, 1000):
        name = f"{base}.md" if n == 1 else f"{base}-{n}.md"
        path = day_dir / name
        try:
            fd = os.open(path, os.O_CREAT | os.O_EXCL | os.O_WRONLY, 0o644)
        except FileExistsError:
            continue
        title = args.title or slug.replace("-", " ")
        tags = args.tags or ""
        category = args.category or "debugging"
        summary = args.summary or "TODO one-line summary"
        skeleton = (
            "---\n"
            f"title: {title}\n"
            f"date: {date}\n"
            f"project: {project}\n"
            f"category: {category}\n"
            f"tags: [{tags}]\n"
            f"summary: {summary}\n"
            "---\n\n"
            f"# {title} — {date}\n\n"
            "## Summary\n"
            f"{summary}\n\n"
            "## Context\n"
            f"- **Project**: {project}\n"
            "- **Branch**: \n\n"
            "## Problem & Fix\n\n"
            "### 1. \n"
            "- \n"
            "- **Fix**: \n\n"
            "## Key Commands / Changes\n\n"
            "## Lessons Learned\n"
        )
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            f.write(skeleton)
        print(path)
        return 0
    print("could not reserve a unique filename", file=sys.stderr)
    return 1


def cmd_index(args) -> int:
    root = archive_dir()
    root.mkdir(parents=True, exist_ok=True)
    entries = []
    for path in root.rglob("*.md"):
        if path.name == "MEMORY.md":
            continue
        try:
            fm = parse_frontmatter(path.read_text(encoding="utf-8"))
        except Exception:
            fm = {}
        rel = path.relative_to(root).as_posix()
        date = fm.get("date") or path.parent.name
        entries.append(
            {
                "rel": rel,
                "title": fm.get("title") or path.stem,
                "date": date,
                "project": fm.get("project") or "",
                "category": (fm.get("category") or "uncategorized").lower(),
                "tags": fm.get("tags") if isinstance(fm.get("tags"), list) else [],
                "summary": fm.get("summary") or "",
            }
        )

    # group by category (known order first, then extras alpha), date desc
    by_cat: dict[str, list] = {}
    for e in entries:
        by_cat.setdefault(e["category"], []).append(e)
    ordered_cats = [c for c in CATEGORY_ORDER if c in by_cat] + sorted(
        c for c in by_cat if c not in CATEGORY_ORDER
    )

    out = ["# Archive Index (MEMORY.md)", ""]
    out.append(
        f"_{len(entries)} archive(s). Auto-generated by `archive.py index` — "
        "do not hand-edit; edits are overwritten on rebuild._"
    )
    out.append("")
    for cat in ordered_cats:
        items = sorted(
            by_cat[cat], key=lambda e: (e["date"], e["title"]), reverse=True
        )
        out.append(f"## {cat}")
        out.append("")
        for e in items:
            tags = f" · tags: {', '.join(e['tags'])}" if e["tags"] else ""
            proj = f" · _{e['project']}_" if e["project"] else ""
            summ = f" — {e['summary']}" if e["summary"] else ""
            out.append(
                f"- `{e['date']}` **{e['title']}**{summ}{proj}{tags} · "
                f"[`{e['rel']}`]({e['rel']})"
            )
        out.append("")

    text = "\n".join(out).rstrip() + "\n"
    target = root / "MEMORY.md"
    tmp = root / f".MEMORY.md.tmp.{os.getpid()}"
    tmp.write_text(text, encoding="utf-8")
    os.replace(tmp, target)  # atomic
    print(target)
    return 0


def cmd_dir(args) -> int:
    print(archive_dir())
    return 0


def main() -> int:
    p = argparse.ArgumentParser(description="Archive skill helper")
    sub = p.add_subparsers(dest="cmd", required=True)

    n = sub.add_parser("new", help="reserve a collision-free archive file")
    n.add_argument("slug", help="short kebab-ish slug, e.g. vcpkg-disk-full")
    n.add_argument("--project", help="override project (default: git repo / cwd)")
    n.add_argument("--title")
    n.add_argument("--category", help=f"one of: {', '.join(CATEGORY_ORDER)}")
    n.add_argument("--tags", help="comma-separated, e.g. duckdb,vcpkg,ci")
    n.add_argument("--summary")
    n.set_defaults(func=cmd_new)

    i = sub.add_parser("index", help="rebuild MEMORY.md from frontmatter (atomic)")
    i.set_defaults(func=cmd_index)

    d = sub.add_parser("dir", help="print resolved ARCHIVE_DIR")
    d.set_defaults(func=cmd_dir)

    args = p.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
