-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

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
