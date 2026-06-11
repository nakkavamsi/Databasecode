-- FULL rollback: remove all objects introduced in Deployments/Migrations/1.9.0

IF OBJECT_ID(N'[play].[tr_Game_Audit]', N'TR') IS NOT NULL
BEGIN
    DROP TRIGGER [play].[tr_Game_Audit];
END;

IF OBJECT_ID(N'[play].[syn_Customer]', N'SN') IS NOT NULL
BEGIN
    DROP SYNONYM [play].[syn_Customer];
END;

IF OBJECT_ID(N'[play].[usp_GetGameById]', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE [play].[usp_GetGameById];
END;

IF OBJECT_ID(N'[play].[vw_ActiveGame]', N'V') IS NOT NULL
BEGIN
    DROP VIEW [play].[vw_ActiveGame];
END;

IF OBJECT_ID(N'[play].[fn_GameCount]', N'IF') IS NOT NULL
BEGIN
    DROP FUNCTION [play].[fn_GameCount];
END;

IF TYPE_ID(N'[play].[GameList]') IS NOT NULL
BEGIN
    DROP TYPE [play].[GameList];
END;

IF TYPE_ID(N'[play].[GameCode]') IS NOT NULL
BEGIN
    DROP TYPE [play].[GameCode];
END;

IF OBJECT_ID(N'[play].[Game]', N'U') IS NOT NULL
BEGIN
    DROP TABLE [play].[Game];
END;
