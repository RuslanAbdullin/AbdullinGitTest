create procedure [dbo].[finish_exec_config_CLR]
	@id int,
	@error nvarchar(1024) = null
as
begin


	update [dbo].[config_CLR]
		set [exec_status] = 2,
			[end_time] = getdate(),
			[error] = @error
	where [id] = @id

end
