-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE OR ALTER TYPE [svc].[ServiceRequestList] AS TABLE (
    [ServiceRequestId] INT            NOT NULL,
    [Title]            NVARCHAR (200) NOT NULL,
    [Status]           NVARCHAR (50)  NOT NULL
);
