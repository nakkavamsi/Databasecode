-- Migration-Id: 20260612062008_b5a93a77
-- Migration-Version: 1.0.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER PROCEDURE [dbo].[usp_GetCustomerById]
    @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [CustomerId],
        [Name],
        [Email],
        [CreatedAt]
    FROM [dbo].[Customer]
    WHERE [CustomerId] = @CustomerId;
END;
