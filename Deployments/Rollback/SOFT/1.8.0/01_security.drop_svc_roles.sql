-- SOFT rollback: reverse Deployments/Migrations/1.8.0 security roles

IF DATABASE_PRINCIPAL_ID(N'svc_writer') IS NOT NULL
BEGIN
    DROP ROLE [svc_writer];
END;

IF DATABASE_PRINCIPAL_ID(N'svc_reader') IS NOT NULL
BEGIN
    DROP ROLE [svc_reader];
END;
