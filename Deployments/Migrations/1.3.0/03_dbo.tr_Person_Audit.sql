-- Migration-Id: 20260612062008_56589f21
-- Migration-Version: 1.3.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER TRIGGER [dbo].[tr_Person_Audit]
ON [dbo].[Person]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
END;
