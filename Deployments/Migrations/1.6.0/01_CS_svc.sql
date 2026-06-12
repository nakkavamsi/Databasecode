-- Migration-Id: 20260612062008_e4a3bd03
-- Migration-Version: 1.6.0
-- Created-Utc: 2026-06-12T06:20:08Z
IF SCHEMA_ID(N'svc') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA [svc] AUTHORIZATION [dbo];');
END;
