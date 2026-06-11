CREATE OR ALTER TRIGGER [svc].[tr_ServiceRequest_Audit]
ON [svc].[ServiceRequest]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
END;
