-- Migration-Id: 20260612062008_ab7ca358
-- Migration-Version: 1.0.0
-- Created-Utc: 2026-06-12T06:20:08Z
IF OBJECT_ID(N'[dbo].[Customer]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Customer] (
        [CustomerId] INT            NOT NULL IDENTITY (1, 1),
        [Name]       NVARCHAR (100) NOT NULL,
        [Email]      NVARCHAR (256) NULL,
        [CreatedAt]  DATETIME2 (7)  NOT NULL CONSTRAINT [DF_Customer_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerId] ASC)
    );
END;
