#!/usr/bin/env python3
"""
Ensure a migration SQL file has a unique -- Migration-Id header.

Used by:
  - manual repair: python3 scripts/stamp-migration-id.py path/to/file.sql
  - batch repair:  python3 scripts/stamp-migration-id.py --all
  - Cursor hook afterFileEdit for new files under Deployments/Migrations/
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

_SCRIPTS_DIR = Path(__file__).resolve().parent
if str(_SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(_SCRIPTS_DIR))

from migration_id import (
    extract_migration_id,
    generate_migration_id,
    has_migration_id,
    parse_version_from_path,
    prepend_migration_header,
)

MIGRATIONS_SUFFIX = f"{Path('Deployments') / 'Migrations'}"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Stamp migration files with unique IDs.")
    parser.add_argument(
        "paths",
        nargs="*",
        help="Migration .sql file path(s) to stamp",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Stamp every migration under Deployments/Migrations/ missing an id",
    )
    parser.add_argument(
        "--project-root",
        type=Path,
        default=Path(__file__).resolve().parent.parent,
        help="Repository root (defaults to parent of scripts/)",
    )
    parser.add_argument(
        "--quiet",
        action="store_true",
        help="Only print when a file is changed",
    )
    return parser.parse_args()


def is_migration_path(path: Path) -> bool:
    normalized = path.as_posix()
    return MIGRATIONS_SUFFIX in normalized and path.suffix.lower() == ".sql"


def stamp_file(path: Path, quiet: bool = False) -> bool:
    if not path.is_file():
        return False

    content = path.read_text(encoding="utf-8")
    if has_migration_id(content):
        if not quiet:
            existing = extract_migration_id(content)
            print(f"Skip (already stamped): {path} [{existing}]")
        return False

    migration_id = generate_migration_id()
    version = parse_version_from_path(path)
    updated = prepend_migration_header(content, migration_id, version)
    path.write_text(updated, encoding="utf-8")
    print(f"Stamped: {path} -> Migration-Id: {migration_id}")
    return True


def main() -> int:
    args = parse_args()
    project_root = args.project_root
    targets: list[Path] = [Path(p).resolve() for p in args.paths]

    if args.all:
        migrations_root = project_root / "Deployments" / "Migrations"
        if not migrations_root.exists():
            print(f"ERROR: Missing migrations folder: {migrations_root}", file=sys.stderr)
            return 1
        targets.extend(sorted(migrations_root.glob("*/*.sql")))

    if not targets:
        print("ERROR: Provide file path(s) or use --all", file=sys.stderr)
        return 1

    changed = 0
    for path in targets:
        if not is_migration_path(path):
            if not args.quiet:
                print(f"Skip (not a migration path): {path}")
            continue
        if stamp_file(path, quiet=args.quiet):
            changed += 1

    if not args.quiet:
        print(f"Done. {changed} file(s) stamped.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
