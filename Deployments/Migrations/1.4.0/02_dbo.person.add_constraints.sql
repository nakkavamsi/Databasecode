-- Migration-Id: 20260612062008_f2cc4aa2
-- Migration-Version: 1.4.0
-- Created-Utc: 2026-06-12T06:20:08Z
ALTER TABLE [dbo].[Person] ADD CONSTRAINT [UQ_Person_Email] UNIQUE ([Email]);

ALTER TABLE [dbo].[Person] ADD CONSTRAINT [CK_Person_Name] CHECK ([Name] <> '');
