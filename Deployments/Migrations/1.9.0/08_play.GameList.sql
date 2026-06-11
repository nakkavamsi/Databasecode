CREATE OR ALTER TYPE [play].[GameList] AS TABLE (
    [GameId]   INT            NOT NULL,
    [Name]     NVARCHAR (100) NOT NULL,
    [IsActive] BIT            NOT NULL
);
