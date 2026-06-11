CREATE OR ALTER PROCEDURE [play].[usp_GetGameById]
    @GameId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [GameId],
        [Name],
        [IsActive],
        [CreatedAt]
    FROM [play].[Game]
    WHERE [GameId] = @GameId;
END;
