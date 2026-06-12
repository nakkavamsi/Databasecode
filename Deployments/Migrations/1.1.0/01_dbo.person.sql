-- Migration-Id: 20260612062008_aab380cd

IF OBJECT_ID(N'[dbo].[Person]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Person] (
        [PersonId]  INT            NOT NULL IDENTITY (1, 1),
        [Name]      NVARCHAR (100) NOT NULL,
        [Email]     NVARCHAR (256) NULL,
        [CreatedAt] DATETIME2 (7)  NOT NULL CONSTRAINT [DF_Person_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PersonId] ASC)
    );
END;
