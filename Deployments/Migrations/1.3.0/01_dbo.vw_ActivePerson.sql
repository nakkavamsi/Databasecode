-- Migration-Id: 20260612062008_3148ef8e
-- Migration-Version: 1.3.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER VIEW [dbo].[vw_ActivePerson]
AS
SELECT
    [PersonId],
    [Name],
    [Email],
    [Phone]
FROM [dbo].[Person]
WHERE [Email] IS NOT NULL;
