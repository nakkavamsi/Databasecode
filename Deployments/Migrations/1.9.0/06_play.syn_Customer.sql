-- Migration-Id: 20260612062008_380e4da7

IF OBJECT_ID(N'[play].[syn_Customer]', N'SN') IS NULL
BEGIN
    CREATE SYNONYM [play].[syn_Customer] FOR [dbo].[Customer];
END;
