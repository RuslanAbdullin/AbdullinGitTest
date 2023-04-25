CREATE PROCEDURE [dbo].[fina_clr]
@paralellCountThread INT NULL, @dateFrom INT NULL, @dateTo INT NULL
AS EXTERNAL NAME [parallel_final].[StoredProcedures].[Parallel_Sub_update]

