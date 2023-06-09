﻿create procedure [dbo].[p_check_total_alcorep]
as
begin
	SELECT 1 --- 20230405
	if object_id ('tempdb..#total_Alcorep') is not null drop table #total_Alcorep
	if object_id ('tempdb..#total_xml') is not null drop table #total_xml
	--тотлы таблицы alcorep
	select	
		 cast(isnull(sum(Остаток_на_начало_отчетного_периода),0) as decimal(15,5)) as 'Остаток_на_начало_отчетного_периода'
		 --закупки
		 ,cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_производителей),0) as decimal(15,5)) as 'Сумма_закупки_в_декалитрах_орг_производителей'
		 ,cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_Оптовой_торговли),0) as decimal(15,5)) as 'Сумма_закупки_в_декалитрах_орг_Оптовой_торговли'
		 ,cast(isnull(sum(Сумма_закупки_в_декалитрах_импорт),0) as decimal(15,5)) as 'Сумма_закупки_в_декалитрах_импорт'
		 --итог закупки
		 ,cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_производителей),0) as decimal(15,5))
	 		+cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_Оптовой_торговли),0) as decimal(15,5))
	 		+cast(isnull(sum(Сумма_закупки_в_декалитрах_импорт),0) as decimal(15,5)) as 'Поступление - закупки итого'
		 ---поступления
		 ,cast(isnull(sum(Поступление_возврат_от_покупателей),0) as decimal(15,5)) as 'Поступление_возврат_от_покупателей'
		 ,cast(isnull(sum(Прочие_поступления),0) as decimal(15,5)) as 'Прочие_поступления'
		 ,cast(isnull(sum(Приход_по_перемещениям),0) as decimal(15,5)) as 'Приход_по_перемещениям'
		 --итог поступления 
		 ,cast(isnull(sum(Поступление_возврат_от_покупателей),0) as decimal(15,5))
	 		+cast(isnull(sum(Прочие_поступления),0) as decimal(15,5))
	 		+cast(isnull(sum(Приход_по_перемещениям),0) as decimal(15,5))
	 		+cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_производителей),0) as decimal(15,5))
	 		+cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_Оптовой_торговли),0) as decimal(15,5))
	 		+cast(isnull(sum(Сумма_закупки_в_декалитрах_импорт),0) as decimal(15,5))as 'Поступление - всего'
		 ---
		 ,cast(isnull(sum(Реализация),0) as decimal(15,5)) as 'Реализация'
		 ,cast(isnull(sum(Прочий_расход),0) as decimal(15,5)) as 'Прочий_расход'
		 ,cast(isnull(sum(Cумма_по_возвратам_поставщику_в_декалитрах),0) as decimal(15,5)) as 'Cумма_по_возвратам_поставщику_в_декалитрах'
		 ,cast(isnull(sum(Расход_по_перемещениям),0) as decimal(15,5)) as 'Расход_по_перемещениям'
		 ,cast(isnull(sum(Всего_расход),0) as decimal(15,5)) as 'Всего_расход'
		 ,cast(isnull(sum(Остаток_на_конец),0) as decimal(15,5)) as 'Остаток_на_конец'
	into #total_Alcorep
	from [dbo].[table1_tiny] t1
	--тотлы xml
	select	
		 cast(isnull(sum(Остаток_на_начало_отчетного_периода),0) as decimal(15,5)) as 'Остаток_на_начало_отчетного_периода'
		 --закупки
		 ,cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_производителей),0) as decimal(15,5)) as 'Сумма_закупки_в_декалитрах_орг_производителей'
		 ,cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_Оптовой_торговли),0) as decimal(15,5)) as 'Сумма_закупки_в_декалитрах_орг_Оптовой_торговли'
		 ,cast(isnull(sum(Сумма_закупки_в_декалитрах_импорт),0) as decimal(15,5)) as 'Сумма_закупки_в_декалитрах_импорт'
		 --итог закупки
		 ,cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_производителей),0) as decimal(15,5))
	 		+cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_Оптовой_торговли),0) as decimal(15,5))
	 		+cast(isnull(sum(Сумма_закупки_в_декалитрах_импорт),0) as decimal(15,5)) as 'Поступление - закупки итого'
		 ---поступления
		 ,cast(isnull(sum(Поступление_возврат_от_покупателей),0) as decimal(15,5)) as 'Поступление_возврат_от_покупателей'
		 ,cast(isnull(sum(Прочие_поступления),0) as decimal(15,5)) as 'Прочие_поступления'
		 ,cast(isnull(sum(Приход_по_перемещениям),0) as decimal(15,5)) as 'Приход_по_перемещениям'
		 --итог поступления 
		 ,cast(isnull(sum(Поступление_возврат_от_покупателей),0) as decimal(15,5))
	 		+cast(isnull(sum(Прочие_поступления),0) as decimal(15,5))
	 		+cast(isnull(sum(Приход_по_перемещениям),0) as decimal(15,5))
	 		+cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_производителей),0) as decimal(15,5))
	 		+cast(isnull(sum(Сумма_закупки_в_декалитрах_орг_Оптовой_торговли),0) as decimal(15,5))
	 		+cast(isnull(sum(Сумма_закупки_в_декалитрах_импорт),0) as decimal(15,5))as 'Поступление - всего'
		 ---
		 ,cast(isnull(sum(Реализация),0) as decimal(15,5)) as 'Реализация'
		 ,cast(isnull(sum(Прочий_расход),0) as decimal(15,5)) as 'Прочий_расход'
		 ,cast(isnull(sum(Cумма_по_возвратам_поставщику_в_декалитрах),0) as decimal(15,5)) as 'Cумма_по_возвратам_поставщику_в_декалитрах'
		 ,cast(isnull(sum(Расход_по_перемещениям),0) as decimal(15,5)) as 'Расход_по_перемещениям'
		 ,cast(isnull(sum(Всего_расход),0) as decimal(15,5)) as 'Всего_расход'
		 ,cast(isnull(sum(Остаток_на_конец),0) as decimal(15,5)) as 'Остаток_на_конец'
	into #total_xml
	from [dbo].[check_total_alcorep] t1
	--сверка тотлов
	if exists(
		SELECT 
		   [Остаток_на_начало_отчетного_периода]
		  ,[Сумма_закупки_в_декалитрах_орг_производителей]
		  ,[Сумма_закупки_в_декалитрах_орг_Оптовой_торговли]
		  ,[Сумма_закупки_в_декалитрах_импорт]
		  ,[Поступление - закупки итого]
		  ,[Поступление_возврат_от_покупателей]
		  ,[Прочие_поступления]
		  ,[Приход_по_перемещениям]
		  ,[Поступление - всего]
		  ,[Реализация]
		  ,[Прочий_расход]
		  ,[Cумма_по_возвратам_поставщику_в_декалитрах]
		  ,[Расход_по_перемещениям]
		  ,[Всего_расход]
		  ,[Остаток_на_конец]
		FROM  #total_xml
		UNION 
		SELECT 
		   [Остаток_на_начало_отчетного_периода]
		  ,[Сумма_закупки_в_декалитрах_орг_производителей]
		  ,[Сумма_закупки_в_декалитрах_орг_Оптовой_торговли]
		  ,[Сумма_закупки_в_декалитрах_импорт]
		  ,[Поступление - закупки итого]
		  ,[Поступление_возврат_от_покупателей]
		  ,[Прочие_поступления]
		  ,[Приход_по_перемещениям]
		  ,[Поступление - всего]
		  ,[Реализация]
		  ,[Прочий_расход]
		  ,[Cумма_по_возвратам_поставщику_в_декалитрах]
		  ,[Расход_по_перемещениям]
		  ,[Всего_расход]
		  ,[Остаток_на_конец]
		FROM #total_Alcorep
		EXCEPT 
		SELECT 
		   [Остаток_на_начало_отчетного_периода]
		  ,[Сумма_закупки_в_декалитрах_орг_производителей]
		  ,[Сумма_закупки_в_декалитрах_орг_Оптовой_торговли]
		  ,[Сумма_закупки_в_декалитрах_импорт]
		  ,[Поступление - закупки итого]
		  ,[Поступление_возврат_от_покупателей]
		  ,[Прочие_поступления]
		  ,[Приход_по_перемещениям]
		  ,[Поступление - всего]
		  ,[Реализация]
		  ,[Прочий_расход]
		  ,[Cумма_по_возвратам_поставщику_в_декалитрах]
		  ,[Расход_по_перемещениям]
		  ,[Всего_расход]
		  ,[Остаток_на_конец]
		FROM  #total_xml
		INTERSECT
		SELECT 
		   [Остаток_на_начало_отчетного_периода]
		  ,[Сумма_закупки_в_декалитрах_орг_производителей]
		  ,[Сумма_закупки_в_декалитрах_орг_Оптовой_торговли]
		  ,[Сумма_закупки_в_декалитрах_импорт]
		  ,[Поступление - закупки итого]
		  ,[Поступление_возврат_от_покупателей]
		  ,[Прочие_поступления]
		  ,[Приход_по_перемещениям]
		  ,[Поступление - всего]
		  ,[Реализация]
		  ,[Прочий_расход]
		  ,[Cумма_по_возвратам_поставщику_в_декалитрах]
		  ,[Расход_по_перемещениям]
		  ,[Всего_расход]
		  ,[Остаток_на_конец]
		FROM #total_Alcorep) 
	--если тотлы не равны
	insert into oth.log_check_xml_xsd
		(
		 line,
		 error
		 )
	select 
		'0',
		'error totals'
	end