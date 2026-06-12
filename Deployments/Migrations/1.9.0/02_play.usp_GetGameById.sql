-- Migration-Id: 20260612062008_1079d969
-- Migration-Version: 1.9.0
-- Created-Utc: 2026-06-12T06:20:08Z
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
