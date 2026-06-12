-- Migration-Id: 20260612062008_eb10ec60
-- Migration-Version: 1.9.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER FUNCTION [play].[fn_GameCount]()
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM [play].[Game];

    RETURN @Count;
END;
