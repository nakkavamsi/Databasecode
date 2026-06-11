-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE FUNCTION [play].[fn_GameCount]()
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM [play].[Game];

    RETURN @Count;
END;
