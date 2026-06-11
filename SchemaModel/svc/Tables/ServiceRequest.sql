-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE TABLE [svc].[ServiceRequest] (
    [ServiceRequestId] INT            NOT NULL IDENTITY (1, 1),
    [CustomerId]       INT            NOT NULL,
    [Title]            NVARCHAR (200) NOT NULL,
    [Status]           NVARCHAR (50)  NOT NULL CONSTRAINT [DF_ServiceRequest_Status] DEFAULT (N'Open'),
    [CreatedAt]        DATETIME2 (7)  NOT NULL CONSTRAINT [DF_ServiceRequest_CreatedAt] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_ServiceRequest] PRIMARY KEY CLUSTERED ([ServiceRequestId] ASC),
    CONSTRAINT [FK_ServiceRequest_Customer]
    FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]),
    CONSTRAINT [UQ_ServiceRequest_Title] UNIQUE ([Title])
);
