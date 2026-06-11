-- SOFT rollback: reverse Deployments/Migrations/1.9.0/09_play.Game.add_constraints.sql

IF OBJECT_ID(N'[play].[CK_Game_Name]', N'C') IS NOT NULL
BEGIN
    ALTER TABLE [play].[Game] DROP CONSTRAINT [CK_Game_Name];
END;

IF OBJECT_ID(N'[play].[UQ_Game_Name]', N'UQ') IS NOT NULL
BEGIN
    ALTER TABLE [play].[Game] DROP CONSTRAINT [UQ_Game_Name];
END;
