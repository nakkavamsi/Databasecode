-- Migration-Id: 20260612062008_7fad729d
-- Migration-Version: 1.6.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER VIEW [svc].[vw_OpenServiceRequest]
AS
SELECT
    [ServiceRequestId],
    [CustomerId],
    [Title],
    [Status],
    [CreatedAt]
FROM [svc].[ServiceRequest]
WHERE [Status] = N'Open';
