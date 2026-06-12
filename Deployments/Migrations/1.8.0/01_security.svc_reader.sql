-- Migration-Id: 20260612062008_abb67c48
-- Migration-Version: 1.8.0
-- Created-Utc: 2026-06-12T06:20:08Z
IF DATABASE_PRINCIPAL_ID(N'svc_reader') IS NULL
BEGIN
    CREATE ROLE [svc_reader] AUTHORIZATION [dbo];
END;
