IF OBJECT_ID(N'[svc].[syn_Customer]', N'SN') IS NULL
BEGIN
    CREATE SYNONYM [svc].[syn_Customer] FOR [dbo].[Customer];
END;
