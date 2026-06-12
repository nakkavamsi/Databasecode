-- Migration-Id: 20260612062008_0ba532cf

IF OBJECT_ID(N'[svc].[ServiceRequest]', N'U') IS NULL
BEGIN
    CREATE TABLE [svc].[ServiceRequest] (
        [ServiceRequestId] INT            NOT NULL IDENTITY (1, 1),
        [CustomerId]       INT            NOT NULL,
        [Title]            NVARCHAR (200) NOT NULL,
        [Status]           NVARCHAR (50)  NOT NULL CONSTRAINT [DF_ServiceRequest_Status] DEFAULT (N'Open'),
        [CreatedAt]        DATETIME2 (7)  NOT NULL CONSTRAINT [DF_ServiceRequest_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_ServiceRequest] PRIMARY KEY CLUSTERED ([ServiceRequestId] ASC)
    );
END;
