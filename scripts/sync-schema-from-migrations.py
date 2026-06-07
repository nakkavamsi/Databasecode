#!/usr/bin/env python3
"""
Sync Schemas/ from Migrations/.

Migrations are the source of truth. This script runs before dacpac build and
writes declarative object scripts into Schemas/{schema}/{objectType}/.

Migration folders must use semantic versioning: MAJOR.MINOR.PATCH
  Valid:   Migrations/1.0.0/, Migrations/1.2.3/
  Invalid: Migrations/1.1/, Migrations/v1.0.0/, Migrations/1.0.0-beta.1/

Supported in each migration file:
  - CREATE TABLE / PROCEDURE / VIEW / FUNCTION (with optional IF OBJECT_ID wrapper)
  - Or a SCHEMA-OBJECT block with the full desired definition:

    -- SCHEMA-OBJECT-START
    CREATE TABLE [dbo].[Person] ( ... );
    -- SCHEMA-OBJECT-END

Later migration versions overwrite earlier definitions for the same object.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

OBJECT_TYPE_FOLDERS = {
    "TABLE": "Tables",
    "PROCEDURE": "StoredProcedures",
    "VIEW": "Views",
    "FUNCTION": "Functions",
}

CREATE_PATTERN = re.compile(
    r"CREATE\s+(?:OR\s+ALTER\s+)?(TABLE|PROCEDURE|VIEW|FUNCTION)\s+"
    r"(\[(?:[^\]]+)\]|(?:\w+))\.(\[(?:[^\]]+)\]|(?:\w+))",
    re.IGNORECASE,
)

SCHEMA_OBJECT_PATTERN = re.compile(
    r"--\s*SCHEMA-OBJECT-START\s*(.*?)\s*--\s*SCHEMA-OBJECT-END",
    re.IGNORECASE | re.DOTALL,
)

IF_OBJECT_ID_PATTERN = re.compile(
    r"IF\s+OBJECT_ID\s*\([^)]+\)\s+IS\s+NULL\s+BEGIN\s*(.*?)\s*END\s*;?",
    re.IGNORECASE | re.DOTALL,
)

GENERATED_HEADER = (
    "-- AUTO-GENERATED from Migrations/. Do not edit directly.\n"
    "-- Add or change scripts under Migrations/MAJOR.MINOR.PATCH/ and rebuild.\n\n"
)

# Strict semver folder names: MAJOR.MINOR.PATCH (non-negative integers, no prefix/suffix)
SEMVER_FOLDER_PATTERN = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$")


def parse_semver_folder(name: str) -> tuple[int, int, int] | None:
    match = SEMVER_FOLDER_PATTERN.fullmatch(name)
    if not match:
        return None
    return tuple(int(part) for part in match.groups())  # type: ignore[return-value]


def validate_migration_folders(migrations_dir: Path) -> list[Path]:
    invalid: list[Path] = []
    valid: list[Path] = []

    for entry in migrations_dir.iterdir():
        if not entry.is_dir() or entry.name.startswith("."):
            continue

        if parse_semver_folder(entry.name) is None:
            invalid.append(entry)
        else:
            valid.append(entry)

    if invalid:
        invalid_names = ", ".join(path.name for path in sorted(invalid, key=lambda p: p.name))
        print(
            "ERROR: Migration folders must use semantic versioning (MAJOR.MINOR.PATCH). "
            f"Invalid folder(s): {invalid_names}",
            file=sys.stderr,
        )
        raise SystemExit(1)

    return sorted(valid, key=lambda path: parse_semver_folder(path.name) or (0, 0, 0))


def migration_sort_key(path: Path) -> tuple[int, int, int]:
    version = parse_semver_folder(path.parent.name)
    if version is None:
        return (0, 0, 0)
    return version


def strip_brackets(identifier: str) -> str:
    return identifier.strip().strip("[]")


def normalize_for_declarative_model(sql: str) -> str:
    sql = re.sub(r"CREATE\s+OR\s+ALTER\s+", "CREATE ", sql, count=1, flags=re.IGNORECASE)

    lines = sql.splitlines()
    non_empty = [line for line in lines if line.strip()]
    if not non_empty:
        return sql.strip()

    min_indent = min(len(line) - len(line.lstrip()) for line in non_empty)
    normalized_lines = [
        line[min_indent:] if line.strip() else line
        for line in lines
    ]
    return "\n".join(normalized_lines).strip()


def extract_declarative_sql(content: str) -> str | None:
    schema_object_match = SCHEMA_OBJECT_PATTERN.search(content)
    if schema_object_match:
        return schema_object_match.group(1).strip()

    wrapper_match = IF_OBJECT_ID_PATTERN.search(content)
    if wrapper_match:
        return wrapper_match.group(1).strip()

    create_match = CREATE_PATTERN.search(content)
    if create_match:
        return content.strip()

    return None


def resolve_output_path(schemas_dir: Path, sql: str) -> Path | None:
    match = CREATE_PATTERN.search(sql)
    if not match:
        return None

    object_type, schema, name = match.groups()
    folder = OBJECT_TYPE_FOLDERS.get(object_type.upper())
    if not folder:
        return None

    schema_name = strip_brackets(schema)
    object_name = strip_brackets(name)
    return schemas_dir / schema_name / folder / f"{object_name}.sql"


def sync(project_root: Path) -> int:
    migrations_dir = project_root / "Migrations"
    schemas_dir = project_root / "Schemas"

    if not migrations_dir.exists():
        print(f"ERROR: Migrations folder not found at {migrations_dir}", file=sys.stderr)
        return 1

    version_folders = validate_migration_folders(migrations_dir)
    migration_files: list[Path] = []

    for version_folder in version_folders:
        migration_files.extend(sorted(version_folder.glob("*.sql")))

    migration_files = sorted(migration_files, key=migration_sort_key)

    if not migration_files:
        print("No migration files found.")
        return 0

    synced_paths: set[Path] = set()

    for migration_file in migration_files:
        content = migration_file.read_text(encoding="utf-8")
        declarative_sql = extract_declarative_sql(content)
        if not declarative_sql:
            print(f"WARN: No syncable CREATE statement in {migration_file}", file=sys.stderr)
            continue

        output_path = resolve_output_path(schemas_dir, declarative_sql)
        if not output_path:
            print(f"WARN: Could not resolve schema path for {migration_file}", file=sys.stderr)
            continue

        output_path.parent.mkdir(parents=True, exist_ok=True)
        normalized_sql = normalize_for_declarative_model(declarative_sql)
        output_path.write_text(
            GENERATED_HEADER + normalized_sql + "\n",
            encoding="utf-8",
        )
        synced_paths.add(output_path)
        print(f"Synced {migration_file.relative_to(project_root)} -> {output_path.relative_to(project_root)}")

    print(f"Schema sync complete. {len(synced_paths)} object(s) updated.")
    return 0


def main() -> int:
    project_root = Path(__file__).resolve().parent.parent
    return sync(project_root)


if __name__ == "__main__":
    raise SystemExit(main())
