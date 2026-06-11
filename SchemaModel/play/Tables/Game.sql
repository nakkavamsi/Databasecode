-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

IF OBJECT_ID(N'[play].[Game]', N'U') IS NULL
BEGIN
    CREATE TABLE [play].[Game] (
        [GameId]    INT            NOT NULL IDENTITY (1, 1),
        [Name]      NVARCHAR (100) NOT NULL,
        [IsActive]  BIT            NOT NULL CONSTRAINT [DF_Game_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2 (7)  NOT NULL CONSTRAINT [DF_Game_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_Game] PRIMARY KEY CLUSTERED ([GameId] ASC),
        CONSTRAINT [UQ_Game_Name] UNIQUE ([Name]),
        CONSTRAINT [CK_Game_Name] CHECK ([Name] <> N'')
    );
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE [name] = N'IX_Game_Name'
      AND [object_id] = OBJECT_ID(N'[play].[Game]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Game_Name]
        ON [play].[Game]([Name] ASC)
        INCLUDE ([IsActive]);
END;
