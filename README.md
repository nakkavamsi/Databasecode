# Databasecode

SQL Server database project using **migration-driven schema management** and **SSDT dacpac builds**. Developers author incremental change scripts under `Deployments/Migrations/`; a Python sync tool materializes a declarative `SchemaModel/` that `Microsoft.Build.Sql` compiles into a `.dacpac`.

---

## Table of contents

1. [Architecture overview](#architecture-overview)
2. [Repository layout](#repository-layout)
3. [Core concepts](#core-concepts)
4. [Migrations (source of truth)](#migrations-source-of-truth)
5. [Schema sync script](#schema-sync-script)
6. [SchemaModel (generated)](#schemamodel-generated)
7. [Rollback scripts](#rollback-scripts)
8. [Build and CI](#build-and-ci)
9. [Current database inventory](#current-database-inventory)
10. [Bootstrap from existing database](#bootstrap-from-existing-database)
11. [How to make changes](#how-to-make-changes)
12. [Conventions and naming](#conventions-and-naming)
13. [Supported vs unsupported objects](#supported-vs-unsupported-objects)
14. [Troubleshooting](#troubleshooting)

---

## Architecture overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     Deployments/Migrations/                             │
│              (semver folders, idempotent SQL scripts)                    │
│                         SOURCE OF TRUTH                                  │
└───────────────────────────────┬─────────────────────────────────────────┘
                                │
                                │  python3 scripts/sync-schema-from-migrations.py
                                │  (runs automatically before dotnet build)
                                ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         SchemaModel/                                     │
│           (plain CREATE scripts for SSDT dacpac model)                   │
│                      AUTO-GENERATED — do not edit                          │
└───────────────────────────────┬─────────────────────────────────────────┘
                                │
                                │  dotnet build Databasecode.sqlproj
                                ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    bin/Release/Databasecode.dacpac                       │
└─────────────────────────────────────────────────────────────────────────┘

Deployments/Rollback/  ──►  Manual deployment scripts (not in dacpac, not synced)
```

### Two-layer SQL model

| Layer | Location | Purpose | SQL style |
|-------|----------|---------|-----------|
| **Deployment** | `Deployments/Migrations/` | Versioned, runnable migration scripts | `CREATE OR ALTER`, `IF OBJECT_ID IS NULL`, `ALTER TABLE`, etc. |
| **Declarative** | `SchemaModel/` | SSDT schema model for dacpac | Plain `CREATE` only (no `IF`, no `CREATE OR ALTER`) |

SSDT validates `SchemaModel/` as a declarative database definition. Imperative guards (`IF NOT EXISTS`, `CREATE OR ALTER`) are valid in migrations but are stripped or unwrapped during sync.

---

## Repository layout

```
Databasecode/
├── .github/workflows/build.yml    # CI: sync + dotnet build + dacpac artifact
├── Databasecode.sqlproj           # SQL Server SDK project (Microsoft.Build.Sql 2.2.0)
├── global.json                    # Pins .NET SDK 8.0.406
├── scripts/
│   ├── sync-schema-from-migrations.py   # Migration → SchemaModel sync engine
│   ├── bootstrap-from-baseline.py       # Split baseline SQL into migration files
│   ├── new-migration.py                 # Scaffold new migration with unique Migration-Id
│   ├── stamp-migration-id.py            # Add Migration-Id header to existing files
│   └── migration_id.py                  # Shared id/header helpers
├── .cursor/
│   ├── hooks.json                       # afterFileEdit hook for auto-stamping
│   └── hooks/stamp-migration-id.sh
├── Deployments/
│   ├── Migrations/                # Forward migrations (semver folders)
│   │   ├── 1.0.0/
│   │   ├── 1.1.0/
│   │   └── ...
│   └── Rollback/
│       ├── FULL/                  # Tear down entire feature/schema versions
│       └── SOFT/                  # Reverse a single incremental change
└── SchemaModel/                   # Generated declarative schema (do not edit)
    ├── Security/
    │   ├── Schemas/               # CREATE SCHEMA scripts
    │   └── Roles/                 # CREATE ROLE + role memberships (merged)
    ├── dbo/
    │   ├── Tables/
    │   ├── StoredProcedures/
    │   ├── Views/
    │   ├── Functions/
    │   ├── Triggers/
    │   └── Synonyms/
    ├── svc/                       # Same object-type folders per schema
    └── play/
```

**Not compiled into dacpac:** `Deployments/Migrations/**`, `Deployments/Rollback/**`, `scripts/**`

**Build output:** `bin/`, `obj/` (gitignored)

---

## Core concepts

### Semantic versioning folders

Every migration folder **must** match `MAJOR.MINOR.PATCH`:

| Valid | Invalid |
|-------|---------|
| `1.0.0` | `1.1` |
| `1.2.3` | `v1.0.0` |
| `2.1.0` | `1.0` |

The sync script sorts folders and files in semver order, then filename order within each folder.

### Last migration wins

For standalone objects (procedures, views, schemas, etc.), a later migration **replaces** the entire definition for that object in `SchemaModel/`.

### Incremental table evolution

`CREATE TABLE` establishes the base table model. Subsequent `ALTER TABLE` scripts in later migrations are **merged** into a single `CREATE TABLE` in `SchemaModel/{schema}/Tables/{Table}.sql`.

Merged `ALTER TABLE` actions:

- `ADD` / `DROP` column
- `ALTER COLUMN`
- `ADD` / `DROP` constraint (PK, FK, UNIQUE, CHECK, DEFAULT)

### Indexes and statistics on tables

`CREATE INDEX` and `CREATE STATISTICS` are merged into the **parent table file**, not separate files:

```sql
CREATE TABLE [dbo].[Person] ( ... );
GO

CREATE NONCLUSTERED INDEX [IX_Person_Email] ON [dbo].[Person]([Email] ASC);
GO

CREATE STATISTICS [STAT_Person_Phone] ON [dbo].[Person]([Phone]);
```

`GO` batch separators are required — SSDT allows only one statement per batch in a table script.

---

## Migrations (source of truth)

### Location

```
Deployments/Migrations/{MAJOR.MINOR.PATCH}/{script}.sql
```

### File naming convention

Scripts use a numeric prefix for ordering within a version folder:

```
01_dbo.person.sql
02_CS_play.sql
01_dbo.person.add_phone.sql
```

Prefix pattern examples:

| Prefix | Meaning |
|--------|---------|
| `dbo.` | Object in `dbo` schema |
| `svc.` | Object in `svc` schema |
| `CS_` | `CREATE SCHEMA` |
| `security.` | Security objects (roles) |

### Unique Migration-Id (automatic)

Each migration script carries a globally unique id in the file header:

```sql
-- Migration-Id: 20260522143000_a3f9b2c1
```

The sync script ignores these comment headers; they are for traceability, auditing, and deployment tooling.

#### Option 1 — Scaffold script (recommended)

Creates the semver folder, sequence prefix, unique id, and header automatically:

```bash
python3 scripts/new-migration.py --version 2.2.0 --name dbo.person.add_status
```

Generated filename example:

```
Deployments/Migrations/2.2.0/01_20260522143000_a3f9b2c1_dbo.person.add_status.sql
```

With SQL body:

```bash
python3 scripts/new-migration.py \
  --version 2.2.0 \
  --name dbo.person.add_status \
  --content "ALTER TABLE [dbo].[Person] ADD [Status] NVARCHAR(50) NULL;"
```

Preview without writing:

```bash
python3 scripts/new-migration.py --version 2.2.0 --name dbo.person.add_status --dry-run
```

#### Option 2 — Automatic on build/sync

Every `dotnet build` and `python3 scripts/sync-schema-from-migrations.py` run stamps any migration file under `Deployments/Migrations/` that is still missing a `Migration-Id`. This covers files you create manually in the IDE.

#### Option 3 — Cursor hook (Agent edits only)

Project hook `.cursor/hooks.json` runs `stamp-migration-id.sh` after **Agent** file edits (`Write` / `TabWrite`). It does **not** run when you type and save a file yourself — use Option 1, 2, or 4 for manual files.

Make the hook executable once:

```bash
chmod +x .cursor/hooks/stamp-migration-id.sh
```

#### Option 4 — Stamp manually

```bash
# One file
python3 scripts/stamp-migration-id.py Deployments/Migrations/2.2.0/01_dbo.person.add_status.sql

# All migrations missing an id
python3 scripts/stamp-migration-id.py --all

# Normalize headers to Migration-Id only
python3 scripts/stamp-migration-id.py --all --refresh
```

**Id format:** `YYYYMMDDHHMMSS_<8-hex>` (UTC timestamp + random suffix).

### Idempotent migration patterns (recommended)

**Table:**

```sql
IF OBJECT_ID(N'[dbo].[Customer]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Customer] ( ... );
END;
```

**Schema:**

```sql
IF SCHEMA_ID(N'play') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA [play] AUTHORIZATION [dbo];');
END;
```

**Role:**

```sql
IF DATABASE_PRINCIPAL_ID(N'svc_reader') IS NULL
BEGIN
    CREATE ROLE [svc_reader] AUTHORIZATION [dbo];
END;
```

**Procedure / view / function / trigger:**

```sql
CREATE OR ALTER PROCEDURE [dbo].[usp_GetCustomerById]
    @CustomerId INT
AS
BEGIN
    ...
END;
```

**Synonym:**

```sql
IF OBJECT_ID(N'[dbo].[syn_Customer]', N'SN') IS NULL
BEGIN
    CREATE SYNONYM [dbo].[syn_Customer] FOR [dbo].[Customer];
END;
```

**Incremental column add:**

```sql
ALTER TABLE [dbo].[Person] ADD [Phone] NVARCHAR(20) NULL;
```

**Incremental constraint:**

```sql
ALTER TABLE [dbo].[Person] ADD CONSTRAINT [FK_Person_Customer]
    FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]);
```

**Index (separate migration file):**

```sql
CREATE NONCLUSTERED INDEX [IX_Person_Email]
    ON [dbo].[Person]([Email] ASC);
```

**Statistics:**

```sql
CREATE STATISTICS [STAT_Person_Phone]
    ON [dbo].[Person]([Phone]);
```

### SCHEMA-OBJECT blocks

For a full object replacement in one migration file:

```sql
-- SCHEMA-OBJECT-START
CREATE TABLE [dbo].[Person] ( ... );
-- SCHEMA-OBJECT-END
```

### DROP in migrations

| Statement | Effect on SchemaModel |
|-----------|----------------------|
| `DROP INDEX [name] ON [schema].[table]` | Removes index from table script |
| `DROP STATISTICS [name] ON [schema].[table]` | Removes statistic from table script |
| `ALTER TABLE ... DROP COLUMN` | Merged into table model |
| `ALTER TABLE ... DROP CONSTRAINT` | Merged into table model |

---

## Schema sync script

**Path:** `scripts/sync-schema-from-migrations.py`

### What it does

1. Validates all migration folders are valid semver (`MAJOR.MINOR.PATCH`)
2. Reads every `*.sql` file in version order
3. Builds an in-memory table registry (columns, constraints, indexes, statistics)
4. Collects other objects (procedures, views, types, etc.)
5. Writes `SchemaModel/` with an `AUTO-GENERATED` header on every file
6. Removes stale `Tables/Indexes/` files if any exist from older sync runs

### Run manually

```bash
python3 scripts/sync-schema-from-migrations.py
```

### Output normalization

`prepare_schema_model_sql()` converts migration SQL into SSDT-compatible output:

- Strips `CREATE OR ALTER` → `CREATE`
- Unwraps `IF OBJECT_ID ... BEGIN ... END` blocks (inner `CREATE` is extracted during parsing)
- Preserves `GO` batch separators between table/index/statistics statements
- Does **not** emit `IF` guards or `CREATE OR ALTER` in `SchemaModel/`

### Object → SchemaModel path mapping

| Migration content | SchemaModel output path |
|-----------------|---------------------------|
| `CREATE TABLE [dbo].[Person]` | `SchemaModel/dbo/Tables/Person.sql` |
| `CREATE INDEX` on `[dbo].[Person]` | Merged into `SchemaModel/dbo/Tables/Person.sql` |
| `CREATE STATISTICS` on `[dbo].[Person]` | Merged into `SchemaModel/dbo/Tables/Person.sql` |
| `CREATE PROCEDURE [dbo].[usp_...]` | `SchemaModel/dbo/StoredProcedures/usp_....sql` |
| `CREATE VIEW [dbo].[vw_...]` | `SchemaModel/dbo/Views/vw_....sql` |
| `CREATE FUNCTION [dbo].[fn_...]` | `SchemaModel/dbo/Functions/fn_....sql` |
| `CREATE TRIGGER [dbo].[tr_...]` | `SchemaModel/dbo/Triggers/tr_....sql` |
| `CREATE SYNONYM [dbo].[syn_...]` | `SchemaModel/dbo/Synonyms/syn_....sql` |
| `CREATE TYPE [svc].[EmailAddress] FROM ...` | `SchemaModel/svc/Types/UserDefinedDataTypes/EmailAddress.sql` |
| `CREATE TYPE [svc].[T] AS TABLE (...)` | `SchemaModel/svc/Types/UserDefinedTableTypes/T.sql` |
| `CREATE SCHEMA [play]` | `SchemaModel/Security/Schemas/play.sql` |
| `CREATE ROLE [svc_reader]` + `ALTER ROLE [svc_reader] ADD MEMBER [dbo]` | `SchemaModel/Security/Roles/svc_reader.sql` (merged) |
| `CREATE SEQUENCE [dbo].[OrderNumberSeq]` | `SchemaModel/dbo/Sequences/OrderNumberSeq.sql` |
| `CREATE ASSEMBLY [MyAssembly]` | `SchemaModel/Assemblies/MyAssembly.sql` |

---

## SchemaModel (generated)

Every file starts with:

```sql
-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.
```

**Do not edit `SchemaModel/` directly.** Changes will be overwritten on the next sync or build.

### Example generated table (`Person.sql`)

```sql
CREATE TABLE [dbo].[Person] (
    [PersonId]  INT NOT NULL IDENTITY (1, 1),
    ...
    CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PersonId] ASC),
    CONSTRAINT [FK_Person_Customer] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]),
    CONSTRAINT [UQ_Person_Email] UNIQUE ([Email]),
    CONSTRAINT [CK_Person_Name] CHECK ([Name] <> '')
);
GO

CREATE NONCLUSTERED INDEX [IX_Person_Email] ON [dbo].[Person]([Email] ASC);
GO

CREATE STATISTICS [STAT_Person_Phone] ON [dbo].[Person]([Phone]);
```

### Keys (PK, FK, UNIQUE, CHECK, DEFAULT)

Keys are **inside** the `CREATE TABLE` body as `CONSTRAINT` clauses — not separate files.

---

## Rollback scripts

Rollback scripts live under `Deployments/Rollback/` and are **not** synced to `SchemaModel/` or included in the dacpac. They are run manually during deployment rollback operations.

### SOFT rollback

Reverses a **single incremental change** from a specific migration version.

```
Deployments/Rollback/SOFT/{version}/{script}.sql
```

Example — reverse `1.2.0` phone column add:

```sql
-- SOFT rollback: reverse Deployments/Migrations/1.2.0/01_dbo.person.add_phone.sql
ALTER TABLE [dbo].[Person] DROP COLUMN [Phone];
```

### FULL rollback

Removes **all objects** introduced by a feature version (e.g. entire `svc` or `play` schema objects).

```
Deployments/Rollback/FULL/{version}/{script}.sql
```

Drops objects in dependency-safe order (triggers → synonyms → procedures → views → functions → types → tables → schema).

---

## Build and CI

### Prerequisites

| Tool | Version |
|------|---------|
| .NET SDK | 8.0.406 (see `global.json`) |
| Python | 3.x |
| SQL project SDK | Microsoft.Build.Sql 2.2.0 |

### Local build

```bash
# Sync + build (sync also runs automatically via MSBuild target)
python3 scripts/sync-schema-from-migrations.py
dotnet build Databasecode.sqlproj --configuration Release /p:NetCoreBuild=true
```

Output dacpac:

```
bin/Release/Databasecode.dacpac
```

### SQL project settings

| Setting | Value |
|---------|-------|
| DSP | `Sql160DatabaseSchemaProvider` (SQL Server 2022) |
| File structure | `BySchemaAndSchemaType` |
| Target | `NetCoreBuild=true` |

### GitHub Actions

Workflow: `.github/workflows/build.yml`

Triggers: push/PR to `main` or `nvkdbchanges`

Steps:

1. Checkout
2. Setup .NET 8.0.406
3. Setup Python 3.x
4. Run `python3 scripts/sync-schema-from-migrations.py`
5. Run `dotnet build Databasecode.sqlproj --configuration Release /p:NetCoreBuild=true`
6. Upload `Databasecode.dacpac` as CI artifact

---

## Current database inventory

### Schemas

| Schema | Purpose |
|--------|---------|
| `dbo` | Core application tables |
| `svc` | Service-request domain sample |
| `play` | Game domain sample |

### Security

| Object | Type |
|--------|------|
| `svc_reader` | Database role |
| `svc_writer` | Database role |

### Migration versions shipped

| Version | Summary |
|---------|---------|
| `1.0.0` | `dbo.Customer` table, `usp_GetCustomerById` |
| `1.1.0` | `dbo.Person` table, `play` schema |
| `1.2.0` | `Person.Phone` column |
| `1.3.0` | `vw_ActivePerson`, `fn_PersonCount`, `tr_Person_Audit` |
| `1.4.0` | `Person.CustomerId` FK, unique/check constraints |
| `1.5.0` | `dbo.syn_Customer` synonym |
| `1.6.0` | Full `svc` schema objects + `ServiceRequest` table |
| `1.7.0` | `svc` user-defined types |
| `1.8.0` | `svc_reader`, `svc_writer` roles |
| `1.9.0` | Full `play` schema sample objects |
| `2.0.0` | Indexes on `Person.Email`, `Game.Name` |
| `2.1.0` | Statistics on `Person.Phone` |

### Tables

| Schema | Table | Notes |
|--------|-------|-------|
| `dbo` | `Customer` | PK, identity |
| `dbo` | `Person` | FK to Customer, unique email, index, statistics |
| `svc` | `ServiceRequest` | FK to Customer |
| `play` | `Game` | Unique name, index on Name |

---

## Bootstrap from existing database

Use this when adopting a **brownfield** SQL Server database into the migration-driven workflow. The bootstrap script does **not** connect to a live server — export schema SQL first, then split it into migration files.

### 1. Export schema-only SQL from the live database

Any of these work:

| Tool | Notes |
|------|-------|
| **SSMS** | Database → Tasks → Generate Scripts → schema only |
| **Azure Data Studio** | Generate scripts workflow |
| **[mssql-scripter](https://github.com/microsoft/mssql-scripter)** | CLI export |
| **SqlPackage** | Extract to `.dacpac`, then script to SQL |

Example SqlPackage extract:

```bash
sqlpackage /Action:Extract \
  /SourceConnectionString:"Server=...;Database=YourDb;..." \
  /TargetFile:baseline.dacpac
```

Script the resulting `.dacpac` to a single `.sql` file (SSMS or SqlPackage `/Action:Script`).

### 2. Bootstrap migration files

**Path:** `scripts/bootstrap-from-baseline.py`

```bash
python3 scripts/bootstrap-from-baseline.py \
  --input baseline.sql \
  --version 1.0.0 \
  --sync
```

| Flag | Purpose |
|------|---------|
| `--input` | Baseline schema SQL file (required) |
| `--version` | Target semver folder under `Deployments/Migrations/` (required) |
| `--sync` | Run `sync-schema-from-migrations.py` after writing files |
| `--dry-run` | Print planned migration files without writing |
| `--force` | Delete existing `.sql` files in the target version folder first |
| `--project-root` | Repository root (defaults to parent of `scripts/`) |

The script:

1. Strips common SSMS noise (`USE`, `SET ANSI_NULLS`, block comments)
2. Splits recognized objects into ordered migration files
3. Wraps idempotent guards (`IF SCHEMA_ID`, `IF OBJECT_ID`, `CREATE OR ALTER`, etc.)
4. Stamps `-- Migration-Id:` headers on every file
5. Optionally syncs `SchemaModel/`

Generated file order: schemas → types → tables (FK-safe order) → deferred foreign keys and other `ALTER TABLE` → indexes → statistics → routines → synonyms → roles.

Inline and column-level foreign keys in `CREATE TABLE` are extracted into separate `ALTER TABLE ... ADD CONSTRAINT` migrations so parent tables can be created first.

Example output layout:

```
Deployments/Migrations/1.0.0/
  01_CS_inventory.sql
  02_inventory.Product.sql
  03_inventory.Product.add_IX_Product_Name.sql
  04_inventory.usp_GetProduct.sql
```

### 3. Review, sync, and build

```bash
python3 scripts/sync-schema-from-migrations.py
dotnet build Databasecode.sqlproj --configuration Release /p:NetCoreBuild=true
```

Compare the dacpac to the live database with SqlPackage `/Action:DeployReport` or SSMS Schema Compare.

### Bootstrap limitations

- **Circular foreign keys:** rare self-referential or multi-table cycles are reported; inline FKs are still deferred to `ALTER TABLE` migrations.
- **Unsupported objects:** users/logins, certificates, and encryption keys are skipped (see [Supported vs unsupported objects](#supported-vs-unsupported-objects)).
- **Unrecognized batches:** skipped with warnings — inspect stderr after bootstrap.
- **Do not edit `SchemaModel/` directly** — always change migrations and re-sync.

---

## How to make changes

### Add a new table

1. Create folder `Deployments/Migrations/{next_version}/` (e.g. `2.2.0`)
2. Add `01_dbo.Order.sql` with idempotent `CREATE TABLE`
3. Run sync or build
4. Commit migration folder + regenerated `SchemaModel/`

### Add a column to an existing table

1. New migration file: `Deployments/Migrations/2.2.0/01_dbo.person.add_status.sql`
2. Use `ALTER TABLE [dbo].[Person] ADD [Status] ...`
3. Sync merges column into `SchemaModel/dbo/Tables/Person.sql`

### Add a stored procedure

1. `Deployments/Migrations/2.2.0/02_dbo.usp_GetOrders.sql`
2. Use `CREATE OR ALTER PROCEDURE ...`
3. Sync writes `SchemaModel/dbo/StoredProcedures/usp_GetOrders.sql`

### Add a new schema

1. `Deployments/Migrations/2.2.0/01_CS_inventory.sql` with `IF SCHEMA_ID ... CREATE SCHEMA`
2. Sync writes `SchemaModel/Security/Schemas/inventory.sql`
3. Add objects under that schema in subsequent files in the same or later version folder

### Add an index

1. `Deployments/Migrations/2.2.0/01_dbo.person.add_index.sql`
2. `CREATE NONCLUSTERED INDEX ... ON [dbo].[Person](...)`
3. Sync appends index to `SchemaModel/dbo/Tables/Person.sql` after `GO`

### Roll back a change

1. Add or run appropriate script from `Deployments/Rollback/SOFT/` or `FULL/`
2. Optionally add a forward migration that formally drops the object for schema history

---

## Conventions and naming

| Object | Prefix | Example |
|--------|--------|---------|
| Primary key | `PK_` | `PK_Person` |
| Foreign key | `FK_` | `FK_Person_Customer` |
| Unique constraint | `UQ_` | `UQ_Person_Email` |
| Check constraint | `CK_` | `CK_Person_Name` |
| Default constraint | `DF_` | `DF_Person_CreatedAt` |
| Index | `IX_` | `IX_Person_Email` |
| Statistics | `STAT_` | `STAT_Person_Phone` |
| View | `vw_` | `vw_ActivePerson` |
| Function | `fn_` | `fn_PersonCount` |
| Trigger | `tr_` | `tr_Person_Audit` |
| Stored procedure | `usp_` | `usp_GetCustomerById` |
| Synonym | `syn_` | `syn_Customer` |

Always use bracketed identifiers: `[schema].[object]`.

---

## Supported vs unsupported objects

### Supported in migrations and SchemaModel sync

| Category | Support |
|----------|---------|
| Tables + ALTER TABLE merge | Yes |
| Primary / foreign / unique / check / default constraints | Yes (merged into table) |
| Indexes | Yes (merged into table script) |
| Statistics | Yes (merged into table script) |
| Stored procedures | Yes |
| Views | Yes |
| Functions (scalar, inline TVF) | Yes |
| Triggers | Yes |
| Synonyms | Yes |
| User-defined types (alias + table types) | Yes |
| Schemas | Yes |
| Database roles | Yes |
| Sequences | Yes |
| CLR assemblies | Yes |
| Role memberships (`ALTER ROLE ... ADD MEMBER`, `sp_addrolemember`) | Yes (merged into `Security/Roles/{role}.sql`) |

### Not yet supported

| Category | Notes |
|----------|-------|
| Symmetric / asymmetric keys, certificates | Not synced |
| Users / logins | Intentionally excluded |
| `UPDATE STATISTICS` | Maintenance only; not synced to SchemaModel |
| `sp_droprolemember` | Not synced (add forward migration to remove membership manually) |

---

## Troubleshooting

### Build error SQL71006 — only one statement per batch

Table scripts with indexes/statistics need `GO` between statements. The sync script inserts `GO` automatically; do not remove them from generated table files.

### Build error SQL70001 — statement not recognized

`SchemaModel/` contains imperative SQL (`IF`, `CREATE OR ALTER`) that SSDT cannot parse. SchemaModel must use plain `CREATE`. Keep idempotent patterns in migrations only.

### Build error SQL71501 — unresolved reference

Often a cascade failure: if a table script fails to parse, dependent views/triggers/functions cannot resolve the table. Fix the table script first.

### Sync error — invalid migration folder name

Folder must be exactly `MAJOR.MINOR.PATCH` (e.g. `1.2.0`, not `1.2`).

### Sync error — ALTER TABLE before CREATE TABLE

A migration applies `ALTER TABLE` before the table exists in the registry. Ensure an earlier migration version contains `CREATE TABLE` for that table.

### SchemaModel edited manually but changes disappeared

`SchemaModel/` is regenerated on every sync/build. Edit `Deployments/Migrations/` instead.

### dotnet not found locally

Install .NET SDK 8.0.406:

```bash
brew install dotnet@8
```

Or download from https://dotnet.microsoft.com/download

---

## Reuse as a template for new database repos

This repository includes a **dotnet / Visual Studio 2022** project template.

```bash
# One-time install (from this repo)
dotnet new install ./templates/SqlMigrationDatabase

# Create a new database repo
dotnet new sql-migration-db -n MyNewDb -o ../MyNewDb
```

In **Visual Studio 2022**: restart VS after install, then **Create a new project** → search **SQL Server Database (Migration-Driven)**.

Full instructions: [templates/README.md](templates/README.md)

### Visual Studio VSIX extension

Build and install a **Visual Studio 2022** extension that adds the template to **File → New → Project**:

```powershell
# Windows + Visual Studio 2022
python scripts\pack-vsix-template.py
msbuild extensions\SqlMigrationDatabaseVsix.sln /p:Configuration=Release
# Install: extensions\SqlMigrationDatabaseVsix\bin\Release\SqlMigrationDatabaseVsix.vsix
```

Details: [extensions/README.md](extensions/README.md)

---

## Quick reference commands

```bash
# Regenerate SchemaModel from migrations
python3 scripts/sync-schema-from-migrations.py

# Full local build
dotnet build Databasecode.sqlproj --configuration Release /p:NetCoreBuild=true

# View dacpac output
ls bin/Release/*.dacpac
```

---

## License and repository

- **Repository:** https://github.com/nakkavamsi/Databasecode
- **Active branch:** `nvkdbchanges`
