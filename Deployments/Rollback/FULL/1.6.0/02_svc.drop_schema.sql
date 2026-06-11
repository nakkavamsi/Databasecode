-- FULL rollback: reverse Deployments/Migrations/1.6.0/01_CS_svc.sql

IF SCHEMA_ID(N'svc') IS NOT NULL
BEGIN
    DROP SCHEMA [svc];
END;
