-- Migration-Id: 20260612062008_3148ef8e

CREATE OR ALTER VIEW [dbo].[vw_ActivePerson]
AS
SELECT
    [PersonId],
    [Name],
    [Email],
    [Phone]
FROM [dbo].[Person]
WHERE [Email] IS NOT NULL;
