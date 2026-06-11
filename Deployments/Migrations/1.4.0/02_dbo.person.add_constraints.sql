ALTER TABLE [dbo].[Person] ADD CONSTRAINT [UQ_Person_Email] UNIQUE ([Email]);

ALTER TABLE [dbo].[Person] ADD CONSTRAINT [CK_Person_Name] CHECK ([Name] <> '');
