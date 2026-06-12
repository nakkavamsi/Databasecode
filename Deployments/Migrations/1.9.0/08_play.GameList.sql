-- Migration-Id: 20260612062008_32ab55cf
-- Migration-Version: 1.9.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER TYPE [play].[GameList] AS TABLE (
    [GameId]   INT            NOT NULL,
    [Name]     NVARCHAR (100) NOT NULL,
    [IsActive] BIT            NOT NULL
);
