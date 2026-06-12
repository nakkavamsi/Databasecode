-- Migration-Id: 20260612062008_45fee30e
-- Migration-Version: 1.5.0
-- Created-Utc: 2026-06-12T06:20:08Z
IF OBJECT_ID(N'[dbo].[syn_Customer]', N'SN') IS NULL
BEGIN
    CREATE SYNONYM [dbo].[syn_Customer] FOR [dbo].[Customer];
END;
