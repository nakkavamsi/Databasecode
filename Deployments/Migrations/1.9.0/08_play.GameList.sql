-- Migration-Id: 20260612062008_32ab55cf

CREATE OR ALTER TYPE [play].[GameList] AS TABLE (
    [GameId]   INT            NOT NULL,
    [Name]     NVARCHAR (100) NOT NULL,
    [IsActive] BIT            NOT NULL
);
