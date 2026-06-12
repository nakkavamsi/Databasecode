-- Migration-Id: 20260612062008_2582b962
-- Migration-Version: 1.4.0
-- Created-Utc: 2026-06-12T06:20:08Z
ALTER TABLE [dbo].[Person] ADD [CustomerId] INT NULL;

ALTER TABLE [dbo].[Person] ADD CONSTRAINT [FK_Person_Customer]
    FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]);
