-- Migration-Id: 20260612062008_eb10ec60

CREATE OR ALTER FUNCTION [play].[fn_GameCount]()
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM [play].[Game];

    RETURN @Count;
END;
