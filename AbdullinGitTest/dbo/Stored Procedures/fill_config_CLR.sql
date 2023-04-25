CREATE procedure [dbo].[fill_config_CLR]
	@session_id int
as 
begin
	
	declare @exec nvarchar(1024)

	delete
	from [dbo].[config_CLR] 
	where [session_id] = @session_id
	
	if (@session_id = 6) 
	begin
	
		insert into [dbo].[config_CLR]
		(
		 [exec_query]
		,[exec_status]
		,[session_id]
		)
		select 
		  '[Okey_SET10].[dbo].[p_lasmart_cheques_insert_xml_by_id] @id_cheque =' + cast(id_cheque as nvarchar),
		  0,
		  @session_id
		from Okey_SET10.dbo.Cheque_xml

		
	end 


	if (@session_id = 5) 
	begin
		declare @iter int = 1
		while @iter <= 3000
			begin
				select @exec = 'exec dbo.SPROC_tempdbMemOptimzedtest_2'

				insert into [dbo].[config_CLR]
					(
					 [exec_query]
					,[exec_status]
					,[session_id]
					)
				select 
					@exec,
					0,
					@session_id

				select @iter = @iter + 1
			end
	end

	
	if (@session_id = 4) 
	begin
		declare @db nvarchar(64)
		DECLARE databases_CUR CURSOR LOCAL FAST_FORWARD FOR
			select 
				[name]
			from sys.databases
			where owner_sid <> 0x01

		OPEN databases_CUR
		FETCH NEXT FROM databases_CUR INTO  @db
		WHILE @@FETCH_STATUS = 0
			BEGIN 
				select @exec = 'exec [dbo].[p_Maintenance_database] @IndexTimeSecond = 4000, @StatisticsTimeSecond= 4000, @LastPartCountUpdate  = 5, @ListDB  = '''+@db+''''

				insert into [dbo].[config_CLR]
					(
					 [exec_query]
					,[exec_status]
					,[session_id]
					)
				select 
					@exec,
					0,
					@session_id
				FETCH NEXT FROM databases_CUR INTO  @db
			END
	end

	ALTER INDEX [ClusteredIndex-20220912-135733] ON [dbo].[config_CLR] REBUILD

	select 
		count(*) as [id_count]
	from [dbo].[config_CLR]
	where session_id = @session_id

	---select IDENT_CURRENT('dbo.config_CLR') as [id_count]
end

