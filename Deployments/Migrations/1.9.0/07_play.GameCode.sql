-- Migration-Id: 20260612062008_45ef63fc
-- Migration-Version: 1.9.0
-- Created-Utc: 2026-06-12T06:20:08Z
CREATE OR ALTER TYPE [play].[GameCode]
    FROM NVARCHAR (20) NOT NULL;
