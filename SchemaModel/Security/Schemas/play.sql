-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

IF SCHEMA_ID(N'play') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA [play] AUTHORIZATION [dbo];');
END;
