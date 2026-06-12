-- Migration-Id: 20260612062008_c0ec3127
-- Migration-Version: 1.6.0
-- Created-Utc: 2026-06-12T06:20:08Z
ALTER TABLE [svc].[ServiceRequest] ADD CONSTRAINT [FK_ServiceRequest_Customer]
    FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]);

ALTER TABLE [svc].[ServiceRequest] ADD CONSTRAINT [UQ_ServiceRequest_Title] UNIQUE ([Title]);
