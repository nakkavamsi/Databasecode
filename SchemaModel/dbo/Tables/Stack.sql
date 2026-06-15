-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE TABLE [dbo].[Stack] (
    [StackId]    INT            NOT NULL IDENTITY (1, 1),
    [Name]       NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (500) NULL,
    [IsActive]   BIT            NOT NULL CONSTRAINT [DF_Stack_IsActive] DEFAULT (1),
    [CreatedAt]  DATETIME2 (7)  NOT NULL CONSTRAINT [DF_Stack_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_Stack] PRIMARY KEY CLUSTERED ([StackId] ASC),
    CONSTRAINT [UQ_Stack_Name] UNIQUE ([Name])
);
