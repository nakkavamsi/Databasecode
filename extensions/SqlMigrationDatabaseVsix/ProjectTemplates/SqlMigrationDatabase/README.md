# $safeprojectname$

SQL Server database project with **migration-driven schema management**.

## Quick start

```bash
# Add a migration
python3 scripts/new-migration.py --version 1.1.0 --name dbo.MyTable

# Bootstrap from an exported baseline script (brownfield adoption)
python3 scripts/bootstrap-from-baseline.py --input baseline.sql --version 1.0.0 --sync

# Build dacpac (sync runs automatically)
dotnet build $safeprojectname$.sqlproj --configuration Release /p:NetCoreBuild=true
```

## Layout

- `Deployments/Migrations/` — source of truth (semver folders)
- `SchemaModel/` — auto-generated declarative model (do not edit)
- `scripts/` — sync, bootstrap, and migration-id tooling

See the full documentation in the source template repository README.
