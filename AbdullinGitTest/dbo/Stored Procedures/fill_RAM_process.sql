CREATE procedure [dbo].[fill_RAM_process]
	@patch nvarchar(1000) = 'C:\Users\Abdullin\',
	@filename nvarchar(1000) =  'WmiData.csv'
as
begin
	DECLARE @input_parametrs  varchar(max) = '@patch='+''''+cast(@patch as nvarchar)+''''+' @filename='+''''+cast(@filename as nvarchar)+''''
	DECLARE @name varchar(max) = '['+ OBJECT_SCHEMA_NAME(@@PROCID)+'].['+OBJECT_NAME(@@PROCID)+']'
	--------------------------------------------------------------------------------------------------																		
	--  Запускаем процедуру логирования																		
	--------------------------------------------------------------------------------------------------
	exec [oth].[fill_SUP_LOG] @name = @name, @state_name = 'start', @sp_id = @@SPID, @input_parametrs = @input_parametrs 	
	begin try
		--------------------------------------------------------------------------------------------------																		
		--  Тело процедуры:																		
		--------------------------------------------------------------------------------------------------	
		declare @cmd nvarchar(1000)
		--выгрузка инфы про текущие процессы в csv
		set @cmd = 'cd "'+@patch+'" 
					& powershell.exe 
						 " (Get-Counter ''\Process(*)\Working Set - Private'').CounterSamples 
						 | Sort-Object InstanceName  
						 | Select-Object -Property InstanceName, CookedValue 
						 | Export-Csv -Path .\'+@filename+' -NoTypeInformation -Delimiter '';''"'
		--убираем enter
		set @cmd = REPLACE(REPLACE(@cmd, CHAR(10), ''),CHAR(13),'')

		EXEC master..xp_cmdshell @cmd
		--загрузка csv 
		if object_id ('tempdb..##temp') is not null drop table ##temp
		CREATE TABLE ##temp(
			[InstanceName] nvarchar(255),
			[CookedValue] nvarchar(50)
		)
		exec('BULK INSERT ##temp
		FROM '''+@patch+''+@filename+'''
		WITH
		(
			CODEPAGE = ''65001'',
			FIRSTROW = 2,
			FIELDTERMINATOR = '';'',
			ROWTERMINATOR = ''\n'',
			TABLOCK
		)')

		--RAM ~ KB
		insert into [dbo].[RAM_process]
			(
			[Name],
			[RAM]
			)
		select 
			 replace([InstanceName], '"','')
			,cast(replace([CookedValue], '"','') as float) / 1024 
		from ##temp
		where [InstanceName]  <> '"_total"'

		if object_id ('tempdb..##temp') is not null drop table ##temp
		--------------------------------------------------------------------------------------------------																		
		--  Завершаем процедуру логирования:																		
		--------------------------------------------------------------------------------------------------																		
		exec [oth].[fill_SUP_LOG] @name = @name, @state_name = 'finish', @sp_id = @@SPID, @input_parametrs = @input_parametrs 		
	end try
	begin catch
			exec [oth].[fill_SUP_LOG] @name = @name, @state_name = 'error', @input_parametrs = @input_parametrs 	
	end catch
end


