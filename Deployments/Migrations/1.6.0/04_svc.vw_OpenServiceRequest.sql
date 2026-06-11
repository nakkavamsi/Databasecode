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
