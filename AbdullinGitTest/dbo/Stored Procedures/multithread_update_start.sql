CREATE PROCEDURE [dbo].[multithread_update_start]
@sessionID INT NULL
AS EXTERNAL NAME [MultithreadStart].[StoredProcedures].[UpdateStart]

