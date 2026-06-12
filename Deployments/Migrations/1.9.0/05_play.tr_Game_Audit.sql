-- Migration-Id: 20260612062008_ef86722f
-- Migration-Version: 1.9.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER TRIGGER [play].[tr_Game_Audit]
ON [play].[Game]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
END;
