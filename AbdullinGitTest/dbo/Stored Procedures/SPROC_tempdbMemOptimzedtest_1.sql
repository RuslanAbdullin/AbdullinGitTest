
CREATE PROCEDURE dbo.SPROC_tempdbMemOptimzedtest_1 AS 
BEGIN
   SET
      NOCOUNT 
      ON;
CREATE TABLE #DummyTable ( ID BIGINT NOT NULL );
INSERT INTO
   #DummyTable 
   SELECT
      T.RowNum 
   FROM
      (
         SELECT
            TOP (1) ROW_NUMBER() OVER ( 
         ORDER BY
( 
            SELECT
               NULL)) RowNum 
            FROM
               sys.sysobjects 
      )
      T;
END