-- SOFT rollback: reverse Deployments/Migrations/2.0.0/01_dbo.person.add_index.sql

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Person_Email'
      AND object_id = OBJECT_ID(N'[dbo].[Person]')
)
BEGIN
    DROP INDEX [IX_Person_Email] ON [dbo].[Person];
END;
