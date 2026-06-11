CREATE OR ALTER FUNCTION [svc].[fn_ServiceRequestCount]()
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM [svc].[ServiceRequest];

    RETURN @Count;
END;
