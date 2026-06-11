-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

IF OBJECT_ID(N'[dbo].[Person]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Person] (
        [PersonId]  INT            NOT NULL IDENTITY (1, 1),
        [Name]      NVARCHAR (100) NOT NULL,
        [Email]     NVARCHAR (256) NULL,
        [CreatedAt] DATETIME2 (7)  NOT NULL CONSTRAINT [DF_Person_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [Phone] NVARCHAR (20) NULL,
        [CustomerId] INT NULL,
        CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PersonId] ASC),
        CONSTRAINT [FK_Person_Customer]
        FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]),
        CONSTRAINT [UQ_Person_Email] UNIQUE ([Email]),
        CONSTRAINT [CK_Person_Name] CHECK ([Name] <> '')
    );
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE [name] = N'IX_Person_Email'
      AND [object_id] = OBJECT_ID(N'[dbo].[Person]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Person_Email]
        ON [dbo].[Person]([Email] ASC);
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.stats
    WHERE [name] = N'STAT_Person_Phone'
      AND [object_id] = OBJECT_ID(N'[dbo].[Person]')
)
BEGIN
    CREATE STATISTICS [STAT_Person_Phone]
        ON [dbo].[Person]([Phone]);
END;
