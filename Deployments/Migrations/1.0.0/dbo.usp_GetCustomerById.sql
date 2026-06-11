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
