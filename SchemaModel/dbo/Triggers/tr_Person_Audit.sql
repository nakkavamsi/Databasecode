-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE TRIGGER [dbo].[tr_Person_Audit]
ON [dbo].[Person]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
END;
