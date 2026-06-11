CREATE NONCLUSTERED INDEX [IX_Game_Name]
    ON [play].[Game]([Name] ASC)
    INCLUDE ([IsActive]);
