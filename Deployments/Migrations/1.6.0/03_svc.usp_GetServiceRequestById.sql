-- Migration-Id: 20260612062008_f3aa7d13
-- Migration-Version: 1.6.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER PROCEDURE [svc].[usp_GetServiceRequestById]
    @ServiceRequestId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [ServiceRequestId],
        [CustomerId],
        [Title],
        [Status],
        [CreatedAt]
    FROM [svc].[ServiceRequest]
    WHERE [ServiceRequestId] = @ServiceRequestId;
END;
