-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE OR ALTER TRIGGER [svc].[tr_ServiceRequest_Audit]
ON [svc].[ServiceRequest]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
END;
