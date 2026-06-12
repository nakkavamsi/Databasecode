-- Migration-Id: 20260612062008_831a02d8
-- Migration-Version: 1.7.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER TYPE [svc].[ServiceRequestList] AS TABLE (
    [ServiceRequestId] INT            NOT NULL,
    [Title]            NVARCHAR (200) NOT NULL,
    [Status]           NVARCHAR (50)  NOT NULL
);
