-- Migration-Id: 20260612062008_2582b962

ALTER TABLE [dbo].[Person] ADD [CustomerId] INT NULL;

ALTER TABLE [dbo].[Person] ADD CONSTRAINT [FK_Person_Customer]
    FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]);
