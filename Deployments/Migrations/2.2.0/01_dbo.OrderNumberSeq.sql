-- Migration-Id: 20260615190001_a1b2c3d4

IF OBJECT_ID(N'[dbo].[OrderNumberSeq]', N'SO') IS NULL
BEGIN
    CREATE SEQUENCE [dbo].[OrderNumberSeq]
        AS INT
        START WITH 1
        INCREMENT BY 1
        MINVALUE 1
        NO CYCLE;
END;
