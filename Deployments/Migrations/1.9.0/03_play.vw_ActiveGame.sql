-- Migration-Id: 20260612062008_2839a707
-- Migration-Version: 1.9.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER VIEW [play].[vw_ActiveGame]
AS
SELECT
    [GameId],
    [Name],
    [CreatedAt]
FROM [play].[Game]
WHERE [IsActive] = 1;
