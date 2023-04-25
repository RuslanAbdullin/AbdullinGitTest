CREATE procedure [dbo].[get_file_name]
as
begin
	select
		-- R
		'08'+'_'
		 --О ИНН окея
	    +'7826087713'+'_'
		--Z
		---------------------------
		+'00' +   -- номер отчетного периода ????
		---------------------------
		+cast(right(datepart(year,getdate()),1) as varchar) + '_' -- последняя цифра года
		--ddmmgggg
		+format(GETDATE(), 'ddMMyyyy')+'_'
		--N
		+convert(varchar(36), NEWID())  as [file_name]
end


