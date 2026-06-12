-- Migration-Id: 20260612062008_25e6a4a3

CREATE STATISTICS [STAT_Person_Phone]
    ON [dbo].[Person]([Phone]);
