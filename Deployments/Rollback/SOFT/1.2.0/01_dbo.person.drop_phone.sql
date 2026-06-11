-- SOFT rollback: reverse Deployments/Migrations/1.2.0/01_dbo.person.add_phone.sql

IF COL_LENGTH(N'dbo.Person', N'Phone') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Person] DROP COLUMN [Phone];
END;
