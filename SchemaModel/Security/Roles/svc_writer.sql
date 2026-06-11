-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

IF DATABASE_PRINCIPAL_ID(N'svc_writer') IS NULL
BEGIN
    CREATE ROLE [svc_writer] AUTHORIZATION [dbo];
END;
