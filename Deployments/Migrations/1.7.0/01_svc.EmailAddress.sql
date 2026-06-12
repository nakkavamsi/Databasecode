-- Migration-Id: 20260612062008_f45e3bf5
-- Migration-Version: 1.7.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER TYPE [svc].[EmailAddress]
    FROM NVARCHAR (256) NULL;
