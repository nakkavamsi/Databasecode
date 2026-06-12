-- Migration-Id: 20260612062008_f3370f0d
-- Migration-Version: 1.6.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER TRIGGER [svc].[tr_ServiceRequest_Audit]
ON [svc].[ServiceRequest]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
END;
