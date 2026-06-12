-- Migration-Id: 20260612062008_65693d74
-- Migration-Version: 1.3.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER FUNCTION [dbo].[fn_PersonCount]()
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM [dbo].[Person];

    RETURN @Count;
END;
