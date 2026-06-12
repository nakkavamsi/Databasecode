-- Migration-Id: 20260612062008_25e6a4a3
-- Migration-Version: 2.1.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE STATISTICS [STAT_Person_Phone]
    ON [dbo].[Person]([Phone]);
