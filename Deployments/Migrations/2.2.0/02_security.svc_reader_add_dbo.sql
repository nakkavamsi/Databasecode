-- Migration-Id: 20260615190002_b2c3d4e5

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members AS drm
    INNER JOIN sys.database_principals AS role_principal
        ON drm.role_principal_id = role_principal.principal_id
    INNER JOIN sys.database_principals AS member_principal
        ON drm.member_principal_id = member_principal.principal_id
    WHERE role_principal.name = N'svc_reader'
      AND member_principal.name = N'dbo'
)
BEGIN
    ALTER ROLE [svc_reader] ADD MEMBER [dbo];
END;
