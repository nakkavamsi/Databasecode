-- Migration-Id: 20260612062008_831a02d8

CREATE OR ALTER TYPE [svc].[ServiceRequestList] AS TABLE (
    [ServiceRequestId] INT            NOT NULL,
    [Title]            NVARCHAR (200) NOT NULL,
    [Status]           NVARCHAR (50)  NOT NULL
);
