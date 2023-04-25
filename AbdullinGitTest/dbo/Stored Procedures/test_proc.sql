CREATE procedure [dbo].[test_proc]
	 @p1 int = 1
	,@p2 int = 2
	,@p3 int = 3
as 
begin
	declare @random_sec varchar(2) = right('0' + cast(cast(RAND()*100/5 as int) as varchar),2)

	declare @time varchar(8) = '00:00:'+@random_sec+''

	if datepart(SECOND, getdate()) % 2 = 0  declare @i int = 1/0;
	----waitfor delay '00:00:04'
	waitfor delay @time
	insert into [dbo].[test_parallel]
	select @p1, @p2, @p3
	
end



