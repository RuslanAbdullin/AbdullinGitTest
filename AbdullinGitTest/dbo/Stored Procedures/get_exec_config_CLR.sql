CREATE procedure [dbo].[get_exec_config_CLR]
	@session_id int 
as
begin
	declare @id int =
					(select top 1 
						[id]
					from [dbo].[config_CLR]
					where [exec_status] = 0
						and [session_id] = @session_id)

	update [dbo].[config_CLR]
		set [exec_status] = 1,
			[start_time] = getdate()
	where [id] = @id

	select @id as [id]

end