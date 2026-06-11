-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE TABLE [dbo].[Customer] (
    [CustomerId] INT            NOT NULL IDENTITY (1, 1),
    [Name]       NVARCHAR (100) NOT NULL,
    [Email]      NVARCHAR (256) NULL,
    [CreatedAt]  DATETIME2 (7)  NOT NULL CONSTRAINT [DF_Customer_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerId] ASC)
);
