-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

IF OBJECT_ID(N'[dbo].[syn_Customer]', N'SN') IS NULL
BEGIN
    CREATE SYNONYM [dbo].[syn_Customer] FOR [dbo].[Customer];
END;
