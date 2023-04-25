

create procedure [oth].[fill_sup_log]
	@name varchar(255) = null,		--obj_name
	@state_name varchar(255) = null,	--start, finish, error
	@row_count int = null,	
	@sp_id int = null,
	@description nvarchar(500) = null,
	@input_parametrs nvarchar(500) = null
as
begin

	
	insert into [oth].[sup_log]
	(
		 [date_time]
		,[name]
		,[system_user]
		,[state_name]
		,[row_count]
		,[err_number]
		,[err_severity]
		,[err_state]
		,[err_object]
		,[err_line]
		,[err_message]
		,[sp_id]
		,[duration]
		,[duration_ord]
		,[description]
        ,[input_parametrs]
	)
	select 
		getdate()
		,@name
		,system_user
		,@state_name
		,case 
			when @state_name = 'finish' and @row_count is null then @@rowcount 
			when @state_name = 'finish' and @row_count is not null then @row_count
			when @state_name = 'error' then -1 
			else null 
		end
		,error_number()
		,error_severity()
		,error_state()
		,error_procedure()
		,error_line()
		,error_message()
		,@sp_id
		,case 
			when @state_name = 'start' then null
			else 				 
				 cast(cast((DATEDIFF(ss,(select max(date_time) 
										from [oth].[SUP_LOG]
										where state_name = 'start' 
											and name = @name 
											and sp_id = @sp_id),getdate()))/3600 as int) as varchar(3)) 
				  +':'+ right('0'+ cast(cast(((DATEDIFF(ss,(select max(date_time) 
															from [oth].[SUP_LOG]
															where state_name = 'start' 
																and name = @name 
																and sp_id = @sp_id),getdate()))%3600)/60 as int) as varchar(2)),2) 
				  +':'+ right('0'+ cast(((DATEDIFF(ss,(select max(date_time) 
														from [oth].[SUP_LOG]
														where state_name = 'start' 
															and name = @name 
															and sp_id = @sp_id),getdate()))%3600)%60 as varchar(2)),2) +' (hh:mm:ss)'
		end
		,case 
			when @state_name = 'start' then null
			else 				 
				 DATEDIFF(ss,(select max(date_time) 
								from [oth].[SUP_LOG]
								where state_name = 'start' 
									and name = @name 
									and sp_id = @sp_id),getdate())
		end
		,@description
		,@input_parametrs

	WAITFOR DELAY '00:00:00.100'
end