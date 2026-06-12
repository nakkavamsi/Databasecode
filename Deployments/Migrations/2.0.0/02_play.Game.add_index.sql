-- Migration-Id: 20260612062008_d7a77545

CREATE NONCLUSTERED INDEX [IX_Game_Name]
    ON [play].[Game]([Name] ASC)
    INCLUDE ([IsActive]);
