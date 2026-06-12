#!/usr/bin/env python3
"""Shared helpers for migration unique IDs and SQL file headers."""

from __future__ import annotations

import re
import uuid
from datetime import datetime, timezone
from pathlib import Path

MIGRATION_ID_HEADER = re.compile(
    r"^--\s*Migration-Id:\s*(\S+)\s*$",
    re.IGNORECASE | re.MULTILINE,
)

MIGRATION_VERSION_HEADER = re.compile(
    r"^--\s*Migration-Version:\s*(\S+)\s*$",
    re.IGNORECASE | re.MULTILINE,
)

SEMVER_FOLDER_PATTERN = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$")


def generate_migration_id() -> str:
    """Return a sortable, globally unique id: YYYYMMDDHHMMSS_<8-hex>."""
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%d%H%M%S")
    return f"{timestamp}_{uuid.uuid4().hex[:8]}"


def parse_version_from_path(path: Path) -> str | None:
    if SEMVER_FOLDER_PATTERN.fullmatch(path.parent.name):
        return path.parent.name
    return None


def build_migration_header(migration_id: str, version: str | None = None) -> str:
    created_utc = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    lines = [
        f"-- Migration-Id: {migration_id}",
    ]
    if version:
        lines.append(f"-- Migration-Version: {version}")
    lines.append(f"-- Created-Utc: {created_utc}")
    lines.append("")
    return "\n".join(lines)


def has_migration_id(content: str) -> bool:
    return MIGRATION_ID_HEADER.search(content) is not None


def extract_migration_id(content: str) -> str | None:
    match = MIGRATION_ID_HEADER.search(content)
    return match.group(1) if match else None


def strip_existing_migration_header(content: str) -> str:
    """Remove auto migration header block at top of file if present."""
    lines = content.splitlines()
    index = 0
    while index < len(lines):
        line = lines[index].strip()
        if not line:
            index += 1
            continue
        if line.startswith("-- Migration-") or line.startswith("-- Created-Utc:"):
            index += 1
            continue
        break
    while index < len(lines) and not lines[index].strip():
        index += 1
    return "\n".join(lines[index:]).strip()


def prepend_migration_header(content: str, migration_id: str, version: str | None) -> str:
    body = strip_existing_migration_header(content)
    header = build_migration_header(migration_id, version)
    if not body:
        return header.rstrip() + "\n"
    return header + body + ("\n" if not body.endswith("\n") else "")


def next_sequence_number(version_dir: Path) -> int:
    max_sequence = 0
    for sql_file in version_dir.glob("*.sql"):
        match = re.match(r"^(\d+)_", sql_file.name)
        if match:
            max_sequence = max(max_sequence, int(match.group(1)))
    return max_sequence + 1


def slugify_name(name: str) -> str:
    slug = re.sub(r"[^a-zA-Z0-9._-]+", "_", name.strip())
    slug = re.sub(r"_+", "_", slug).strip("._-")
    if not slug:
        raise ValueError("Migration name cannot be empty after slugify")
    return slug
