-- Migration-Id: 20260612062008_380e4da7
-- Migration-Version: 1.9.0
-- Created-Utc: 2026-06-12T06:20:08Z
IF OBJECT_ID(N'[play].[syn_Customer]', N'SN') IS NULL
BEGIN
    CREATE SYNONYM [play].[syn_Customer] FOR [dbo].[Customer];
END;
