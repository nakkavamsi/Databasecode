Pre-Deployments Folder
======================

This folder is for scripts and documents that are run manually BEFORE schema
migrations and dacpac publish.

Use this location for items that are outside the migration-driven schema model,
for example:

  - CREATE DATABASE scripts
  - Server logins and database users
  - Role membership setup at the server/login level (if not in migrations)
  - Linked servers, credentials, and keys
  - Environment-specific configuration scripts
  - DBA runbooks and other database-related documentation

These files are NOT synced to SchemaModel/ and are NOT included in the dacpac.
The deployment runner (scripts/run-migrations.py --pre-deployments) applies them
before migrations and tracks applied scripts in dbo.__PreDeploymentHistory.

Optional header for scripts that must run against another database:

  -- SqlCmd-Database: master

Suggested layout (optional):

  pre-deployments/
    database/     -- CREATE DATABASE, filegroups, options
    security/     -- logins, users, grants
    docs/         -- runbooks, checklists, environment notes
