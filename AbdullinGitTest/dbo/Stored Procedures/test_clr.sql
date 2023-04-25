CREATE PROCEDURE [dbo].[test_clr]
@paralellCountThread INT NULL
AS EXTERNAL NAME [test_parallel].[StoredProcedures].[SqlStoredProcedure1]

