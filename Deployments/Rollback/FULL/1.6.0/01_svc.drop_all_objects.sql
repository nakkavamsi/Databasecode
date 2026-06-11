-- FULL rollback: remove svc application objects from Deployments/Migrations/1.6.0 and 1.7.0

IF OBJECT_ID(N'[svc].[tr_ServiceRequest_Audit]', N'TR') IS NOT NULL
BEGIN
    DROP TRIGGER [svc].[tr_ServiceRequest_Audit];
END;

IF OBJECT_ID(N'[svc].[syn_Customer]', N'SN') IS NOT NULL
BEGIN
    DROP SYNONYM [svc].[syn_Customer];
END;

IF OBJECT_ID(N'[svc].[usp_GetServiceRequestById]', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE [svc].[usp_GetServiceRequestById];
END;

IF OBJECT_ID(N'[svc].[vw_OpenServiceRequest]', N'V') IS NOT NULL
BEGIN
    DROP VIEW [svc].[vw_OpenServiceRequest];
END;

IF OBJECT_ID(N'[svc].[fn_ServiceRequestCount]', N'IF') IS NOT NULL
BEGIN
    DROP FUNCTION [svc].[fn_ServiceRequestCount];
END;

IF TYPE_ID(N'[svc].[ServiceRequestList]') IS NOT NULL
BEGIN
    DROP TYPE [svc].[ServiceRequestList];
END;

IF TYPE_ID(N'[svc].[EmailAddress]') IS NOT NULL
BEGIN
    DROP TYPE [svc].[EmailAddress];
END;

IF OBJECT_ID(N'[svc].[ServiceRequest]', N'U') IS NOT NULL
BEGIN
    DROP TABLE [svc].[ServiceRequest];
END;
