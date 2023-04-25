CREATE  PROCEDURE dbo.SPROC_tempdbMemOptimzedtest_2 AS 
BEGIN
   DECLARE @id int = 0;
WHILE( @id < 50 ) 
BEGIN
   EXECUTE dbo.SPROC_tempdbMemOptimzedtest_1;
   SET
      @id = @id + 1;
END
END