-- Migration-Id: 20260612062008_c5bd9ffb

CREATE NONCLUSTERED INDEX [IX_Person_Email]
    ON [dbo].[Person]([Email] ASC);
