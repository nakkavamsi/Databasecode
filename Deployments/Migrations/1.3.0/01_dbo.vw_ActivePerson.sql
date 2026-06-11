CREATE OR ALTER VIEW [dbo].[vw_ActivePerson]
AS
SELECT
    [PersonId],
    [Name],
    [Email],
    [Phone]
FROM [dbo].[Person]
WHERE [Email] IS NOT NULL;
