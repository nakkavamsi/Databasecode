-- Migration-Id: 20260612062008_c55f32f4
-- Migration-Version: 1.9.0
-- Created-Utc: 2026-06-12T06:20:08Z
ALTER TABLE [play].[Game] ADD CONSTRAINT [UQ_Game_Name] UNIQUE ([Name]);

ALTER TABLE [play].[Game] ADD CONSTRAINT [CK_Game_Name] CHECK ([Name] <> N'');
