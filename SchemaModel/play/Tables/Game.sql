-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE TABLE [play].[Game] (
    [GameId]    INT            NOT NULL IDENTITY (1, 1),
    [Name]      NVARCHAR (100) NOT NULL,
    [IsActive]  BIT            NOT NULL CONSTRAINT [DF_Game_IsActive] DEFAULT (1),
    [CreatedAt] DATETIME2 (7)  NOT NULL CONSTRAINT [DF_Game_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_Game] PRIMARY KEY CLUSTERED ([GameId] ASC),
    CONSTRAINT [UQ_Game_Name] UNIQUE ([Name]),
    CONSTRAINT [CK_Game_Name] CHECK ([Name] <> N'')
);

CREATE NONCLUSTERED INDEX [IX_Game_Name]
    ON [play].[Game]([Name] ASC)
    INCLUDE ([IsActive]);
