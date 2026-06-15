-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE TABLE [dbo].[Sales] (
    [SalesId]    INT            NOT NULL IDENTITY (1, 1),
    [CustomerId] INT            NOT NULL,
    [Amount]     DECIMAL (18, 2) NOT NULL,
    [SaleDate]   DATETIME2 (7)  NOT NULL CONSTRAINT [DF_Sales_SaleDate] DEFAULT (SYSUTCDATETIME()),
    [Notes]      NVARCHAR (500) NULL,
    [CreatedAt]  DATETIME2 (7)  NOT NULL CONSTRAINT [DF_Sales_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_Sales] PRIMARY KEY CLUSTERED ([SalesId] ASC),
    CONSTRAINT [FK_Sales_Customer]
            FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId])
);
