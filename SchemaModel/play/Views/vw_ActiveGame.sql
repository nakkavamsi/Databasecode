-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE VIEW [play].[vw_ActiveGame]
AS
SELECT
    [GameId],
    [Name],
    [CreatedAt]
FROM [play].[Game]
WHERE [IsActive] = 1;
