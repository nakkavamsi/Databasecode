-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE OR ALTER PROCEDURE [play].[usp_GetGameById]
    @GameId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [GameId],
        [Name],
        [IsActive],
        [CreatedAt]
    FROM [play].[Game]
    WHERE [GameId] = @GameId;
END;
