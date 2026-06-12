-- Migration-Id: 20260612062008_f3aa7d13

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
