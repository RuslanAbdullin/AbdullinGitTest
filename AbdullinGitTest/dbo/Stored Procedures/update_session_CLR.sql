
create procedure [dbo].[update_session_CLR]
	@sessionID int
as
begin
	update [Abdullin].[dbo].[session_CLR] 
		set [date_last_run] = getdate()
	where [session_id] = @sessionID
end