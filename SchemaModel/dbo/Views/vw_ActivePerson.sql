-- AUTO-GENERATED from Deployments/Migrations/. Do not edit directly.
-- Add or change scripts under Deployments/Migrations/MAJOR.MINOR.PATCH/ and rebuild.

CREATE VIEW [dbo].[vw_ActivePerson]
AS
SELECT
    [PersonId],
    [Name],
    [Email],
    [Phone]
FROM [dbo].[Person]
WHERE [Email] IS NOT NULL;
