

/*
--Abdullin 
exec [dbo].[p_Maintenance_database] @IndexTimeSecond = 4000, @StatisticsTimeSecond= 4000, @LastPartCountUpdate  = 5, @ListDB  = 'OrganicNevaVP_Sazonov'
----- 11 min----
*/
CREATE procedure [dbo].[p_Maintenance_database] 
		@IndexTimeSecond int = 1800,
		@StatisticsTimeSecond int = 1800,
		@LastPartCountUpdate int = 5,
		@ListDB nvarchar(2048) = 'Archive,BonusCalculator,Reports,Presentation,ETL,ESB_Sync,DDS,Staging'
as 
 begin
 DECLARE 
		 @name varchar(max) = '['+ OBJECT_SCHEMA_NAME(@@PROCID)+'].['+OBJECT_NAME(@@PROCID)+']'
		,@description varchar(500) = 'обслуживание бд'
		,@input_parametrs varchar(500) =  '  @IndexTimeSecond     =   '     + convert(varchar(10),@IndexTimeSecond)      +  
									      ' ,@StatisticsTimeSecond  = '	   + convert(varchar(10),@StatisticsTimeSecond) +
										  ' ,@LastPartCountUpdate  = '	   + convert(varchar(10),@LastPartCountUpdate) 

	begin try

		waitfor delay '00:00:10'

		declare @db nvarchar(64)
		declare @sql_exec nvarchar(max)
		
		DECLARE databases_CUR CURSOR LOCAL FAST_FORWARD FOR
			select 
				[Value]
			from [dbo].[FnSplit](@ListDB, ',')
			where [Value] <>''

		OPEN databases_CUR
		FETCH NEXT FROM databases_CUR INTO  @db
		WHILE @@FETCH_STATUS = 0
			BEGIN 
				

				select @sql_exec  = '
				use '+@db+';

				
				 declare @IndexTimeSecond int = '+cast(@IndexTimeSecond as nvarchar)+', @StatisticsTimeSecond int =  '+cast(@StatisticsTimeSecond as nvarchar)+', @LastPartCountUpdate int = '+cast(@LastPartCountUpdate as nvarchar)+'
				--------------------------------------------------------------------------------------------------
				--Таблица для запуска запросов + инфа для логирования
				--------------------------------------------------------------------------------------------------
				begin try
					
					if object_id (''tempdb..#QueryTable'') is not null drop table #QueryTable
					create table #QueryTable --таблица содержащая внутри себя запросы по ребилду/реогрганизации индексов и обновлению статистики 
								(
								[Id] int identity(1,1)
							   ,[Query] varchar(4000)
							   ,[table_name] varchar(512)
							   ,[object_name] varchar(512)
							   ,[part_number] int
								)
					--------------------------------------------------------------------------------------------------
					--Заполнение таблицы запросов запросами ребилда и реорганизации columstore-индексов 
					--------------------------------------------------------------------------------------------------
					insert into #QueryTable
						(
						[Query]
					   ,[table_name]
					   ,[object_name]
					   ,[part_number]
						)
					select 
					   ''alter index ''
						+''[''
						+ i.name
						+'']'' 
						+ '' on ''
						+''['' -----------------------------------------------------
						+ s.name
						+'']'' -------------------------------------------------------------
						+''.''
						+''[''
						+ o.name
						+''] ''
						+ case --выбор между реорганизацией и ребилдом индексов
							 when 100.0*(ISNULL(sum(deleted_rows),0))/NULLIF(sum(total_rows),0) >30 
								then '' rebuild ''
							 when 100.0*(ISNULL(sum(deleted_rows),0))/NULLIF(sum(total_rows),0) between 5 and 30 
								then '' reorganize ''
						   end
						+ case -- если таблица секционированна, то делаем ребилд/реогранизацию по партициям
							 when  max(st.partition_number) over (partition by o.name,  i.name)>1 
								then '' partition = '' + convert(varchar(5), isnull(st.partition_number,''''))
							 else '' ''
						   end as [Query]	,
						o.name as [table_name],
						i.name as [object_name],
						st.partition_number
					from sys.dm_db_column_store_row_group_physical_stats st
					inner join sys.objects o
						on o.object_id = st.object_id
					inner join sys.schemas s  
						on o.schema_id= s.schema_id
					inner join sys.indexes i
						on i.object_id = o.object_id
					inner join sys.partitions p
						on p.object_id = o.object_id
						and p.index_id = i.index_id
						and p.partition_number = st.partition_number
					group by 
						s.name,
						o.name,
						i.name,
						st.partition_number
					having 
						100.0*(ISNULL(sum(deleted_rows),0))/NULLIF(sum(total_rows),0) >= 5
					--------------------------------------------------------------------------------------------------
					--Получение общей информации про rowstore-индексы для работы с sys.dm_db_index_physical_stats 
					--------------------------------------------------------------------------------------------------
					if object_id (''tempdb..#infoIndex'') is not null drop table #infoIndex
					create table #infoIndex
						(
						 [TableName] varchar(512)
						,[ObjectID] bigint
						,[IndexName] varchar(512)
						,[IndexId] int
						,[Partition_number] int
						,[PageCount] bigint
						,[RowCount] bigint
						)


					insert into #infoIndex
							(
							 [TableName]
							,[ObjectID]
							,[IndexName]
							,[IndexId]
							,[Partition_number]
							,[PageCount]
							,[RowCount]
							)
					select 
									   ''[''+ s.name+'']'' +''.'' + ''[''+o.name+'']'' as [TableName], 
									   o.id as  [ObjectID],
									   si.name as [IndexName], 
									   si.index_id as [IndexId], 
									   ps.partition_number as [Partition_number],
									   max(ps.used_page_count) as [PageCount], 
									   max(ps.row_count) as [RowCount]
					from sys.sysobjects o 
					inner join sys.schemas s  
						on o.uid= s.schema_id
					inner join sys.stats  st  
						on st.object_id = o.id
					inner join sys.dm_db_partition_stats ps  
						on st.object_id=ps.object_id
					inner join sys.indexes si  
						on o.id = si.object_id and st.name=si.name 
					where o.type=''U'' --отсеиваем системные таблицы
						and si.type_desc not like ''%COLUMNSTORE%'' -- отсеиваем таблицы с COLUMNSTORE индексами
					group by  o.id, 
							  s.name, 
							  o.name, 
							  si.name, 
							  si.index_id, 
							  ps.partition_number
					having max(ps.row_count)<> 0 
					--------------------------------------------------------------------------------------------------
					--Получение информации о статистики индексов 
					--------------------------------------------------------------------------------------------------		
					if object_id (''tempdb..#StatisticIndex'') is not null drop table #StatisticIndex
					create table #StatisticIndex
						(
						 [TableName] varchar(512)
						,[ObjectID] bigint
						,[IndexName] varchar(512)
						,[IndexId] int
						,[Partition_number] int
						,[index_type_desc] varchar(128)
						,[avg_fragmentation_in_percent] float
						,[fragment_count] int
						,[avg_page_space_used_in_percent] float
						)
			
					declare @TableName varchar(512)
					declare @ObjectID bigint
					declare @IndexName varchar(512)
					declare @IndexId int
					declare @Partition_number int
					declare @PageCount bigint
					declare @RowCount bigint
		
					DECLARE infoIndex_CUR CURSOR LOCAL FAST_FORWARD FOR
					SELECT   
							 [TableName]
							,[ObjectID]
							,[IndexName]
							,[IndexId]
							,[Partition_number]
							,[PageCount]
							,[RowCount]
					FROM #infoIndex

					OPEN infoIndex_CUR
					FETCH NEXT FROM infoIndex_CUR INTO  @TableName, 
														@ObjectID,
														@IndexName,
														@IndexId,
														@Partition_number,
														@PageCount,
														@RowCount
					WHILE @@FETCH_STATUS = 0
					  BEGIN 
							declare @StatisticsMode varchar(64) =  case    --выбираем режим просмотра статиски, исходя из кол-ва задействованных страниц
																		when @PageCount<10000 
																			then ''DETAILED''
																		when @PageCount>=10000 and @PageCount<=1000000 
																			then ''SAMPLED''
																		when @PageCount>1000000  
																			then ''LIMITED''
																	end 
							insert into #StatisticIndex
									(
									 [TableName] 
									,[ObjectID] 
									,[IndexName] 
									,[IndexId] 
									,[Partition_number] 
									,[index_type_desc] 
									,[avg_fragmentation_in_percent] 
									,[fragment_count] 
									,[avg_page_space_used_in_percent]
									)
							select 
									@TableName
								   ,@ObjectID
								   ,@IndexName
								   ,@IndexId
								   ,@Partition_number
								   ,index_type_desc
								   ,avg_fragmentation_in_percent
								   ,fragment_count
								   ,avg_page_space_used_in_percent
							from sys.dm_db_index_physical_stats (DB_ID(),  @ObjectID, @IndexID, @Partition_number, @StatisticsMode)
							where index_level = 0  and index_type_desc<>''HEAP'' and alloc_unit_type_desc = ''IN_ROW_DATA'' and page_count>1


							FETCH NEXT FROM infoIndex_CUR INTO  @TableName, 
																@ObjectID,
																@IndexName,
																@IndexId,
																@Partition_number,
																@PageCount,
																@RowCount
					  END
					--------------------------------------------------------------------------------------------------
					--Заполнение таблицы запросов запросами ребилда и реорганизации индексов 
					--------------------------------------------------------------------------------------------------		
					insert into #QueryTable
							(
							 [Query]
							,[table_name]
							,[object_name]
							,[part_number]
							)
					select distinct 
							  ''alter index ''
							 +''[''
							 + IndexName
							 +'']'' 
							 + '' on '' 
							 + TableName
							 + case --выбор между реорганизацией и ребилдом индексов
								 when avg_fragmentation_in_percent >30
									then '' rebuild ''
								 when avg_fragmentation_in_percent between 5 and 30 
									then '' reorganize ''
							   end
							+ case -- если таблица секционированна, то делаем ребилд/реогранизацию по партициям
								 when  max(Partition_number) over (partition by TableName, IndexName)>1 
									then '' partition = '' + convert(varchar(5), isnull(Partition_number,''''))
								 else '' ''
							   end																					as [Query],
							 TableName																				as [table_name],
							 IndexName																				as [object_name],
							 Partition_number																		as [part_number]
					from #StatisticIndex
					where avg_fragmentation_in_percent>5
					--------------------------------------------------------------------------------------------------
					--Делаем ребилд и реогрганизацию индексов 
					--------------------------------------------------------------------------------------------------		
					declare @IndexTimeStart datetime = getdate()
					declare @IndexTimeEnd datetime = dateadd(second,@IndextimeSecond,@IndexTimeStart)
					declare @count  int = 1
					declare @end_cycle int  = (select max(id) from #QueryTable)
					declare @sql varchar(2048)

					while (@count<=@end_cycle and getdate()<@IndexTimeEnd)
						begin
							--получение запроса ребилда/реограганизации
							select 
								@sql = Query
							from  #QueryTable
							where id = @count
							--специальное логирование обслуживания
							declare @start_dt datetime = getdate()
							insert into [Abdullin].[dbo].[t_sup_log_Mainteanance]
								(
								 [date_time]
								,[table_name]
								,[object_name]
								,[type]		
								,[stat_name]	
								,[part_number]
								,[query]		
								,[duration]   
								)
							select
								 @start_dt
								,[table_name]
								,[object_name]
								,''index''
								,''start''
								,[part_number]
								,@sql
								,null
							from  #QueryTable
							where id = @count
							--запуск ребилда/реограганизации
							exec (@sql) 
							--специальное логирование обслуживания
							declare @finish_dt datetime = getdate()
							insert into [Abdullin].[dbo].[t_sup_log_Mainteanance]
								(
								 [date_time] 
								,[table_name]
								,[object_name]
								,[type]		
								,[stat_name]	
								,[part_number]
								,[query]		
								,[duration]   
								)
							select
								 @finish_dt
								,[table_name]
								,[object_name]
								,''index''
								,''finish''
								,[part_number]
								,@sql
								,convert(time,@finish_dt-@start_dt)
							from  #QueryTable
							where id = @count
							--переход на новый шаг цикла
							set @count = @count + 1
						end
					truncate table #QueryTable --отчистка таблицы запросов
					--------------------------------------------------------------------------------------------------
					--Заполнение вспомогательной таблицы для обновления статистики (содержит в себе номер максимальной непустой партиции таблицы)
					--------------------------------------------------------------------------------------------------		
					if object_id (''tempdb..#TableMaxPart'') is not null drop table #TableMaxPart
					create table #TableMaxPart  
								(
								ObjectId   int
							   ,MaxPartNum int
								)
					insert into #TableMaxPart
						(
						 ObjectId  
						,MaxPartNum
						)
					select 
						 o.object_id							as [object_id]
						,max(p.partition_number)				as [partition_number]
					from sys.objects o
					inner join sys.partitions p
						on p.object_id = o.object_id
					where o.[type] IN (''U'', ''V'')
					  and p.rows <> 0
					group by 
						 o.object_id			
					--------------------------------------------------------------------------------------------------
					--Получение данных статистики 
					--------------------------------------------------------------------------------------------------		
					insert into #QueryTable
							(
							 [Query]
							,[table_name]
							,[object_name]
							,[part_number]
							)
					select 
						'' UPDATE STATISTICS ''
						+''[''
						+ [sch]
						+'']''
						+ ''.''
						+''[''
						+ [table_name]
						+'']''
						+''(''
						+''[''
						+ [stat_name]
						+'']''
						+'')''
						+ case 
							when (max([part_number]) over (partition by [table_name], [stat_name])>1  and [type_inc] = 1) -- если таблица секционирована и имеет инкрементальную статистику, то статистику можно обновлять по партициям
								then '' with RESAMPLE ON PARTITIONS('' + convert(varchar(4),[part_number]) +'')''
							else '' ''
						  end			
										as [Query],
						  [sch]
						+ ''.''
						+ [table_name]  as [table_name],
			  
						  [stat_name]   as [object_name],

						  [part_number] as [part_number]
					from 
					   (
						select 
							SCHEMA_NAME(o.[schema_id])				as [sch],
							o.name									as [table_name], 
							s.name									as [stat_name],
							p.partition_number						as [part_number],
							s.is_incremental						as [type_inc],
							sum(a.total_pages)						as [total_pages],
							tmp.MaxPartNum							as [MaxPartNum],
							case 
								when s.is_incremental <> 1
									then STATS_DATE (s.object_id,s.stats_id)
								else
									 (  select 
											last_updated
										from sys.dm_db_incremental_stats_properties(object_id(o.name),s.stats_id) st_incr
										where st_incr.partition_number=p.partition_number) 
							end		as [last_update_stat]  --время последнего обновления статистики 
						from sys.stats s
						inner join sys.objects o
							on s.object_id = o.object_id
						inner join sys.indexes i
							on i.object_id = o.object_id 
						inner join sys.partitions p
							on p.object_id = o.object_id
						inner join sys.allocation_units a  
							on p.[partition_id] = a.container_id
						inner join #TableMaxPart tmp
							on tmp.ObjectId = o.object_id
						where  s.[auto_created] = 0  --отсеиваем автоматическую статистику
							   and o.[type] IN (''U'', ''V'') --убираем системные таблицы
							   and  ((i.[type_desc] not like ''%COLUMNSTORE%'')  -- выбираем всю статистику не для columnstore таблиц
									 or (i.[type_desc]  like ''%COLUMNSTORE%'' and s.user_created=1)) -- или выбираем статистику для columnstore таблиц созданную юзером
							   and  p.rows <> 0 -- убираем пустые партиции
						group by
							 SCHEMA_NAME(o.[schema_id])			
							,o.name								
							,s.name	
							,s.stats_id							
							,p.partition_number					
							,s.is_incremental					
							,STATS_DATE(s.object_id, s.stats_id)
							,tmp.MaxPartNum
						having tmp.MaxPartNum - p.partition_number < @LastPartCountUpdate -- обновляем только поcледние непустые @LastPartCountUpdate партиций		   
					) x
					order by 
						[last_update_stat]
					--	where [stat_name] not like ''% _Id%''			 
					--------------------------------------------------------------------------------------------------
					--Обновление полученной статистики 
					--------------------------------------------------------------------------------------------------				
					declare @StatisticsTimeStart datetime = getdate()
					declare @StatisticsTimeEnd datetime = dateadd(second,@StatisticsTimeSecond,@StatisticsTimeStart)
					set @count = 1
					set @end_cycle  = (select max(id) from #QueryTable)

					while (@count<=@end_cycle and getdate()<@StatisticsTimeEnd)
						begin
							--получение запроса обновления статистики
							select 
								@sql = Query
							from  #QueryTable
							where id = @count
							--специальное логирование обслуживания
							declare @start_dt_s datetime = getdate()
							insert into [Abdullin].[dbo].[t_sup_log_Mainteanance]
								(
								 [date_time]
								,[table_name]
								,[object_name]
								,[type]		
								,[stat_name]	
								,[part_number]
								,[query]		
								,[duration]   
								)
							select
								 @start_dt_s
								,[table_name]
								,[object_name]
								,''statistics''
								,''start''
								,[part_number]
								,@sql
								,null
							from  #QueryTable
							where id = @count
							--запуск обновления статистики
							exec (@sql)
							--специальное логирование обслуживания
							declare @finish_dt_s datetime = getdate()
							insert into [Abdullin].[dbo].[t_sup_log_Mainteanance]
								(
								 [date_time]
								,[table_name]
								,[object_name]
								,[type]		
								,[stat_name]	
								,[part_number]
								,[query]		
								,[duration]   
								)
							select
								 @finish_dt_s
								,[table_name]
								,[object_name]
								,''statistics''
								,''finish''
								,[part_number]
								,@sql
								,convert(time,@finish_dt_s-@start_dt_s)
							from  #QueryTable
							where id = @count
							--переход на новый шаг цикла
							set @count = @count + 1
						end
					-------------------------------------------------------------------------------------------------
						if object_id (''tempdb..#infoIndex'') is not null drop table #infoIndex
						if object_id (''tempdb..#StatisticIndex'') is not null drop table #StatisticIndex
						if object_id (''tempdb..#QueryTable'') is not null drop table #QueryTable
						if object_id (''tempdb..#TableMaxPart'') is not null drop table #TableMaxPart
					end try      
					begin catch
						  insert into [Abdullin].[dbo].[t_sup_log_Mainteanance]
							(
							 [date_time]
							,[type]
							,[stat_name]
							)
						  select
							 GETDATE()
							,''error: '' + error_message()
							,''error''
						
						if object_id (''tempdb..#infoIndex'') is not null drop table #infoIndex
						if object_id (''tempdb..#StatisticIndex'') is not null drop table #StatisticIndex
						if object_id (''tempdb..#QueryTable'') is not null drop table #QueryTable
						if object_id (''tempdb..#TableMaxPart'') is not null drop table #TableMaxPart
					end catch '
				exec(@sql_exec)
				FETCH NEXT FROM databases_CUR INTO  @db
			END
	end try      
	begin catch
		  --логируем ошибку
		  insert into [Abdullin].[dbo].[t_sup_log_Mainteanance]
			(
			 [date_time]
			,[type]
			,[stat_name]
			)
		  select
			 GETDATE()
			,'error: ETL p_Maintenance_database -' + error_message()
			,'error'
	end catch 
 end


