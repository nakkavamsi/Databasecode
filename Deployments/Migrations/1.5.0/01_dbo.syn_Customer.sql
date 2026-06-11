IF OBJECT_ID(N'[dbo].[syn_Customer]', N'SN') IS NULL
BEGIN
    CREATE SYNONYM [dbo].[syn_Customer] FOR [dbo].[Customer];
END;
