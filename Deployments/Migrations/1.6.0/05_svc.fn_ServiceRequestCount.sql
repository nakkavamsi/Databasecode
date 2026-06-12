-- Migration-Id: 20260612062008_dbd71d97
-- Migration-Version: 1.6.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER FUNCTION [svc].[fn_ServiceRequestCount]()
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM [svc].[ServiceRequest];

    RETURN @Count;
END;
