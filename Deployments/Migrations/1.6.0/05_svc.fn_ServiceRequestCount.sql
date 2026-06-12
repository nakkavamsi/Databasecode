-- Migration-Id: 20260612062008_dbd71d97

CREATE OR ALTER FUNCTION [svc].[fn_ServiceRequestCount]()
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM [svc].[ServiceRequest];

    RETURN @Count;
END;
