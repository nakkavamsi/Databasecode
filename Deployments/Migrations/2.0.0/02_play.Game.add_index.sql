-- Migration-Id: 20260612062008_d7a77545
-- Migration-Version: 2.0.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE NONCLUSTERED INDEX [IX_Game_Name]
    ON [play].[Game]([Name] ASC)
    INCLUDE ([IsActive]);
