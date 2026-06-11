-- SOFT rollback: reverse Deployments/Migrations/1.6.0/08_svc.ServiceRequest.add_fk.sql

IF OBJECT_ID(N'[svc].[FK_ServiceRequest_Customer]', N'F') IS NOT NULL
BEGIN
    ALTER TABLE [svc].[ServiceRequest] DROP CONSTRAINT [FK_ServiceRequest_Customer];
END;
