-- Migration-Id: 20260612063626_b122d194

IF OBJECT_ID(N'[dbo].[Stack]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Stack] (
        [StackId]    INT            NOT NULL IDENTITY (1, 1),
        [Name]       NVARCHAR (100) NOT NULL,
        [Description] NVARCHAR (500) NULL,
        [IsActive]   BIT            NOT NULL CONSTRAINT [DF_Stack_IsActive] DEFAULT (1),
        [CreatedAt]  DATETIME2 (7)  NOT NULL CONSTRAINT [DF_Stack_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_Stack] PRIMARY KEY CLUSTERED ([StackId] ASC),
        CONSTRAINT [UQ_Stack_Name] UNIQUE ([Name])
    );
END;
