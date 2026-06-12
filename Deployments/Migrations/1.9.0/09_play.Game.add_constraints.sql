-- Migration-Id: 20260612062008_c55f32f4

ALTER TABLE [play].[Game] ADD CONSTRAINT [UQ_Game_Name] UNIQUE ([Name]);

ALTER TABLE [play].[Game] ADD CONSTRAINT [CK_Game_Name] CHECK ([Name] <> N'');
