-- Migration-Id: 20260612062008_4bf84bf6
-- Migration-Version: 1.1.0
-- Created-Utc: 2026-06-12T06:20:08Z
IF SCHEMA_ID(N'play') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA [play] AUTHORIZATION [dbo];');
END;
