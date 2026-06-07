-- AUTO-GENERATED from Migrations/. Do not edit directly.
-- Add or change scripts under Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE PROCEDURE [dbo].[usp_GetCustomerById]
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
