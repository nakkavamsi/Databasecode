-- Migration-Id: 20260612062008_c5bd9ffb
-- Migration-Version: 2.0.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE NONCLUSTERED INDEX [IX_Person_Email]
    ON [dbo].[Person]([Email] ASC);
