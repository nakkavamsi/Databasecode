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
Run them manually as part of your deployment process before applying migrations
or publishing the dacpac.

Suggested layout (optional):

  pre-deployments/
    database/     -- CREATE DATABASE, filegroups, options
    security/     -- logins, users, grants
    docs/         -- runbooks, checklists, environment notes
