-- Migration-Id: 20260612062008_0edc67bd

IF OBJECT_ID(N'[play].[Game]', N'U') IS NULL
BEGIN
    CREATE TABLE [play].[Game] (
        [GameId]    INT            NOT NULL IDENTITY (1, 1),
        [Name]      NVARCHAR (100) NOT NULL,
        [IsActive]  BIT            NOT NULL CONSTRAINT [DF_Game_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2 (7)  NOT NULL CONSTRAINT [DF_Game_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_Game] PRIMARY KEY CLUSTERED ([GameId] ASC)
    );
END;
