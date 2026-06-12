-- Migration-Id: 20260612062008_6d5348e1

IF OBJECT_ID(N'[svc].[syn_Customer]', N'SN') IS NULL
BEGIN
    CREATE SYNONYM [svc].[syn_Customer] FOR [dbo].[Customer];
END;
