-- Migration-Id: 20260612062008_2839a707

CREATE OR ALTER VIEW [play].[vw_ActiveGame]
AS
SELECT
    [GameId],
    [Name],
    [CreatedAt]
FROM [play].[Game]
WHERE [IsActive] = 1;
