ALTER TABLE [svc].[ServiceRequest] ADD CONSTRAINT [FK_ServiceRequest_Customer]
    FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]);

ALTER TABLE [svc].[ServiceRequest] ADD CONSTRAINT [UQ_ServiceRequest_Title] UNIQUE ([Title]);
