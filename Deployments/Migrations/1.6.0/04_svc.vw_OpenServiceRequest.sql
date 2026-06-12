-- Migration-Id: 20260612062008_7fad729d

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
