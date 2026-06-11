-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE TRIGGER [play].[tr_Game_Audit]
ON [play].[Game]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
END;
