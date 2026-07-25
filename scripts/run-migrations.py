#!/usr/bin/env python3
"""Thin wrapper — implementation lives in the sql-migration-tools package."""
from __future__ import annotations

try:
    from sql_mig.run import main
except ImportError as exc:  # pragma: no cover
    raise SystemExit(
        "sql-migration-tools is not installed.\n"
        "  pip install -e ../sql-migration-tools\n"
        "  # or: pip install -r requirements.txt"
    ) from exc

if __name__ == "__main__":
    raise SystemExit(main())
