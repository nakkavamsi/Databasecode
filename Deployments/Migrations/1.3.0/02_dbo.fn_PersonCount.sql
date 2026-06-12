-- Migration-Id: 20260612062008_65693d74

CREATE OR ALTER FUNCTION [dbo].[fn_PersonCount]()
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM [dbo].[Person];

    RETURN @Count;
END;
