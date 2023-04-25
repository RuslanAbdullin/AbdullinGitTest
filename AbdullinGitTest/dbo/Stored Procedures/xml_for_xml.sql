
CREATE procedure xml_for_xml
as
declare @xml nvarchar(max) = 
(
select distinct
	 Field1 as [first_level/@at]
	,(select distinct
			Field2  as [second_level/@at]
			,(select distinct 
				Field3 as  [third_level]
			 from dbo.test_XML t3
			 where t3.Field2=t2.Field2
				and t3.Field1 = t1.Field1
			 for xml path ('')) as [second_level/row]
	  from dbo.test_XML t2
	  where t2.Field1=t1.Field1 
	  for xml path ('')  ) as [first_level/row]
from dbo.test_XML t1
for xml path ('test')
) 
select @xml = replace(@xml, 'amp;', '')
select @xml = replace(@xml,'&lt;','<')
select @xml = replace(@xml,'&gt;','>')
select @xml = replace(@xml,'<row>','')
select @xml = replace(@xml,'</row>','')

select @xml




