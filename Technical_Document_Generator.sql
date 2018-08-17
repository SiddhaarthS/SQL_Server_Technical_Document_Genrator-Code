DECLARE @style_xml XML

DECLARE @xml_doc  XML
DECLARE @xml_doc_table  XML
DECLARE @xml_doc_view  XML
DECLARE @xml_doc_schema  XML
DECLARE @xml_doc_user_defined_data_type  XML
DECLARE @xml_doc_user_defined_table_type  XML
DECLARE @xml_doc_proc XML
DECLARE @xml_doc_func XML
DECLARE @xml_doc_table_func XML

DECLARE @xml_header_table XML
DECLARE @xml_header_view XML
DECLARE @xml_header_schema XML
DECLARE @xml_header_user_defined_data_type XML
DECLARE @xml_header_user_defined_table_type XML
DECLARE @xml_header_proc XML
DECLARE @xml_header_func XML
DECLARE @xml_header_trigger XML
DECLARE @xml_header_index XML
DECLARE @xml_header_key XML
DECLARE @xml_header_constraint XML

DECLARE @index_of_topics XML

DECLARE @schema_heading XML
DECLARE @user_defined_data_type_heading XML
DECLARE @user_defined_table_type_heading XML
DECLARE @table_heading XML
DECLARE @view_heading XML
DECLARE @procedure_heading XML
DECLARE @function_heading XML
DECLARE @table_function_heading XML

DECLARE @table_count INT
DECLARE @procedure_count INT

DECLARE @table_list XML
DECLARE @procedure_list XML
DECLARE @function_list XML
DECLARE @table_function_list XML
DECLARE @view_list XML


SET @xml_header_table = '   
		<th class="table_td">Column Name</th>
        <th class="table_td">Data Type</th>
        <th class="table_td">Constraints</th>
        
'

SET @xml_header_view = '   
		<th class="table_td">Column Name</th>
        <th class="table_td">Data Type</th>
        <th class="table_td">Constraints</th>
        
'

SET @xml_header_schema = '   
		<th>Schema Name</th>
        <th>Default Character Set</th>
'

SET @xml_header_user_defined_data_type = '   
		<th>Name</th>
        <th>Base Data Type</th>
        <th>Allows Nulls</th>
'

SET @xml_header_user_defined_table_type = '   
		<th>Schema Name</th>
        <th>Data Type</th>
        <th>Constraints</th>
'

SET @xml_header_proc = '   
		<th>Parameter Name</th>
        <th>Data Type</th>
        <th>Parameter Type</th>
'

SET @xml_header_func = '   
		<th>Parameter Name</th>
        <th>Data Type</th>
        <th>Parameter Type</th>
'

SET @xml_header_trigger = '   
		<th>Trigger Name</th>
        <th>Trigger Type</th>
        <th>SQL Operation</th>
'

SET @xml_header_index = '   
		<th>Index Name</th>
        <th>Index Keys</th>
        <th>Characteristics</th>
'

SET @xml_header_key = '   
		<th>Key Name</th>
        <th>Key Type</th>
        <th>Columns and References</th>
'

SET @xml_header_constraint = '   
		<th>Constraint Name</th>
        <th>Constraint Type</th>
        <th>Default Value/ Check Condition</th>
'

SET @index_of_topics = '   
		<br/>
		<br/>
		<h1>
			<center><u>INDEX</u></center>
		</h1>
		<ul>
			<li><h3><a href = "#schema">Schemas</a></h3></li>
			<li><h3><a href = "#data_type">User Defined Data Types</a></h3></li>
			<li><h3><a href = "#table_type">User Defined Table Types</a></h3></li>
			<li><h3><a href = "#table">Tables</a></h3></li>
			<li><h3><a href = "#view">Views</a></h3></li>
			<li><h3><a href = "#procedure">Procedures</a></h3></li>
			<li><h3><a href = "#function">Functions</a></h3></li>
			<li><h3><a href = "#table_function">Table Valued Functions</a></h3></li>			
		</ul>
		<br/>
		<br/>
'

SET @schema_heading = '
		<br/>
		<br/>
		<h2>
		<a name = "schema">Schemas</a>
		</h2>
		<br/>
		<br/>
'

SET @user_defined_data_type_heading = '
		<br/>
		<br/>
		<h2>
		<a name ="data_type" >User Defined Data Types</a>
		</h2>
		<br/>
		<br/>
'

SET @user_defined_table_type_heading = '
		<br/>
		<br/>
		<h2>
		<a name = "table_type">User Defined Table Types</a>
		</h2>
		<br/>
		<br/>
'

SET @table_heading = '
		<br/>
		<br/>
		<h2>
		<a name = "table">Tables</a>
		</h2>
		<br/>
		<br/>
'

SET @view_heading = '
		<br/>
		<br/>
		<h2>
		<a name="view">Views</a>
		</h2>
		<br/>
		<br/>
'

SET @procedure_heading = '
		<br/>
		<br/>
		<h2>
		<a name="procedure">Procedures</a>
		</h2>
		<br/>
		<br/>
'
SET @function_heading = '
		<br/>
		<br/>
		<h2>
		<a name ="function">Functions</a>
		</h2>
		<br/>
		<br/>
'
SET @table_function_heading = '
		<br/>
		<br/>
		<h2>
		<a name ="table_function">Table Valued Functions</a>
		</h2>
		<br/>
		<br/>
'


SET @style_xml='<style>
td {
  width: 30%;
  border: 1px solid #000;
  font-family: Trebuchet MS;
  font-size: 12;
  overflow-wrap: break-word;
}
a { 
    color: blue;
}

.table_td{
	width: 30%;
}

th {
  width: 30%;
  border: 1px solid #000;
  font-family: Trebuchet MS;
  font-size: 15;
  background-color: #8EC872;
}

p,span,div,.dependency {
  font-family: Trebuchet MS;
  font-size: 12;
}
b{
  font-family: Trebuchet MS;
  font-size: 14
}
table{
	table-layout: fixed;
	padding-top:10px;
	padding-bottom: 10px;
	width: 100%;
	border-collapse:collapse;
}
html{
    height:297mm;
    width:210mm;
	font-family: Trebuchet MS;
}

h2,h1,a,h3,h5{
  font-family: Trebuchet MS;  
}
</style>'

-- User Defined Schemas 

SELECT @xml_doc_schema = 
(
	SELECT
	@xml_header_schema,
	(
		SELECT
			(SELECT s.name AS td FOR XML PATH(''),type),
			(SELECT schemata.DEFAULT_CHARACTER_SET_NAME AS td  FOR XML PATH(''),type)
		FROM    
				sys.schemas s
			INNER JOIN
				sys.sysusers u
			 ON
				u.uid = s.principal_id
			INNER JOIN
				[INFORMATION_SCHEMA].[SCHEMATA] schemata
			ON
				schemata.SCHEMA_NAME = s.name
			WHERE
				u.issqlrole = 0
				AND
				u.issqluser = 0
		FOR XML PATH('tr'),TYPE
	),
	'' AS 'br'
	FOR XML PATH('table'),TYPE
)

SELECT @xml_doc_schema = (SELECT  @schema_heading,@xml_doc_schema  for xml path (''))


-- User Defined Data Types

 IF OBJECT_ID('tempdb.dbo.#user_defined_data_type_info', 'U') IS NOT NULL
  DROP TABLE #user_defined_data_type_info; 


SELECT
	 CONCAT('[',SCHEMA_NAME(schema_id),'].','[',name,']') AS [Name],
	CASE TYPE_NAME(system_type_id)
			WHEN 'varchar' THEN CONCAT(TYPE_NAME(system_type_id),'(',IIF(max_length = -1, 'max',CAST(max_length AS VARCHAR(20)) ),')')
			WHEN 'char' THEN CONCAT(TYPE_NAME(system_type_id),'(',IIF(max_length = -1, 'max',CAST(max_length AS VARCHAR(20)) ),')')
			WHEN 'nvarchar' THEN CONCAT(TYPE_NAME(system_type_id),'(',IIF(max_length = -1, 'max',CAST(max_length AS VARCHAR(20)) ),')')
			WHEN 'nchar' THEN CONCAT(TYPE_NAME(system_type_id),'(',IIF(max_length = -1, 'max',CAST(max_length AS VARCHAR(20)) ),')')
			WHEN 'decimal' THEN CONCAT(TYPE_NAME(system_type_id),'(',precision,',',scale,')')
			WHEN 'numeric' THEN CONCAT(TYPE_NAME(system_type_id),'(',precision,',',scale,')')
			ELSE TYPE_NAME(system_type_id)
		END AS  Base_Data_Type,
		CASE is_nullable
			WHEN 0 THEN 'Non Null'
			WHEN 1 THEN ''
			ELSE ''
		END as [Allow Nulls]
INTO #user_defined_data_type_info	
FROM 
	sys.types 
WHERE 
	is_user_defined = 1 
ORDER BY 
	name

SET @xml_doc_user_defined_data_type =  
(
	SELECT
	@xml_header_user_defined_data_type,
		(
			SELECT 
			
				 (SELECT  Name AS 'td' FOR XML PATH(''),type)
				,(SELECT   Base_Data_Type  AS 'td'FOR XML PATH(''),type)
				,(SELECT   [Allow Nulls]  AS 'td'FOR XML PATH(''),type)
			
			FROM #user_defined_data_type_info t1
			FOR XML PATH('tr'), type
		)
	,'' AS 'br'
	FOR XML PATH('table'), type
)

SELECT @xml_doc_user_defined_data_type = (SELECT  @user_defined_data_type_heading,@xml_doc_user_defined_data_type for xml path (''))

-- User Defined Table Type

 IF OBJECT_ID('tempdb.dbo.#user_defined_table_type_info', 'U') IS NOT NULL
  DROP TABLE #user_defined_table_type_info; 

SELECT 
	Name
	,Column_Name
	,Data_Type
	,CONCAT('',
		STUFF(
			IIF([primary key] = '','', COALESCE(', ' + RTRIM([primary key]),     '') )
			+ IIF([Foreign Key] = '','', COALESCE(', ' + RTRIM([Foreign Key]), '') )
			+ IIF([Unique_Constraint] = '','', COALESCE(', ' + RTRIM([Unique_Constraint]),  ''))
			+ IIF([Identity] = '','', COALESCE(', ' + RTRIM([Identity]),  ''))
			+ IIF([Default] = '','', COALESCE(', ' + RTRIM([Default]),  ''))
			+ IIF([Allow Nulls] = '','', COALESCE(', ' + RTRIM([Allow Nulls]),  ''))
			, 1, 2, ''
			)
	) AS CONSTRAINTS

INTO #user_defined_table_type_info	
 FROM
(
	SELECT
		   CONCAT('[',SCHEMA_NAME(t.schema_id),'].','[',t.name,']') AS [Name]
		  ,c.name   [Column_Name]
		  ,CASE c.is_nullable
				WHEN 0 THEN 'Non Null'
				WHEN 1 THEN ''
				ELSE ''
			END as [Allow Nulls]
			,CASE c.is_identity
				WHEN 0 THEN ''
				WHEN 1 THEN 'Identity'
				ELSE ''
			END as [Identity]
		  ,CASE TYPE_NAME(C.user_type_id)
				WHEN 'varchar' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
				WHEN 'char' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
				WHEN 'nvarchar' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
				WHEN 'nchar' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
				WHEN 'decimal' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',C.precision,',',C.scale,')')
				WHEN 'numeric' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',C.precision,',',C.scale,')')
				ELSE TYPE_NAME(C.user_type_id)
			END AS  Data_Type 
			,IIF(i.is_primary_key IS NULL, '','Primary Key') 'Primary Key'
			,IIF(fk.constraint_column_id IS NULL,'',CONCAT('Foreign Key - ','[',OBJECT_SCHEMA_NAME(fk.referenced_object_id),'].','[',OBJECT_NAME(fk.referenced_object_id),']')) as 'Foreign Key'
			,IIF(dc.definition IS NULL, '',CONCAT('Default - ',dc.definition)) AS [Default]
			,CASE i.is_unique_constraint
				WHEN 1 THEN 'Unique'
				WHEN 0 THEN ''
				ELSE ''
			END as [Unique_Constraint]
	FROM 
			sys.table_types t
		INNER JOIN 
			sys.columns c 
		ON
			c.object_id = t.type_table_object_id
		LEFT OUTER JOIN 
			sys.default_constraints dc 
	   ON
			t.type_table_object_id = dc.parent_object_id 
		AND 
			dc.parent_column_id = c.column_id
	   LEFT OUTER JOIN 
			sys.foreign_key_columns  fk
	   ON 
			fk.parent_object_id = c.object_id 
		AND 
			fk.parent_column_id = c.column_id
	   LEFT OUTER JOIN 
		 sys.index_columns ic 
		ON 
			ic.object_id = c.object_id 
		AND 
			ic.column_id = c.column_id
	   LEFT OUTER JOIN 
			sys.indexes i ON ic.object_id = i.object_id 
		AND 
			ic.index_id = i.index_id
	WHERE
		t.is_user_defined = 1
		AND
		t.is_table_type = 1
)sub_query
ORDER BY Name


SET @xml_doc_user_defined_table_type =  
(
SELECT
	(SELECT 
		t2.Name AS '@name'
		,t2.Name AS 'b'
		FOR XML PATH('a'),type),	
	(SELECT
		@xml_header_user_defined_table_type,
		(
			SELECT 
			
				 (SELECT  Column_Name AS 'td' FOR XML PATH(''),type)
				,(SELECT   Data_Type  AS 'td'FOR XML PATH(''),type)
				,(SELECT   CONSTRAINTS  AS 'td'FOR XML PATH(''),type)
			
			FROM #user_defined_table_type_info	 t1
			WHERE t1.Name = t2.Name
			FOR XML PATH('tr'), type
		),
		'' AS 'br'
		FOR XML PATH('table')
	)
FROM (SELECT DISTINCT Name FROM #user_defined_table_type_info	) t2
FOR XML PATH ('')
)


SELECT @xml_doc_user_defined_table_type = (SELECT  @user_defined_table_type_heading,@xml_doc_user_defined_table_type for xml path (''))

-- Table

 IF OBJECT_ID('tempdb.dbo.#table_info', 'U') IS NOT NULL
  DROP TABLE #table_info; 
/*
-- [filtering_id] is a column that we introduce to identify what information we are storing in the temporary table
-- Code:
---********************************
--- [filtering_id]  |  Information
---********************************
---       0         |    Column information
---       1         |    Dependent Objects
---       2         |    Objects Dependent On
---       3         |    Constraints
---       4         |    Triggers
---       5         |    Indices
---       6         |    Keys
*/

-- We create a temporary table for storing index information. This is becuase it will be easier later when we want to combine the various columns
-- that might be part of an index into a single column in the form of comma separated variables 
 IF OBJECT_ID('tempdb.dbo.#table_index_info', 'U') IS NOT NULL
  DROP TABLE #table_index_info; 
SELECT 
	CONCAT('[',OBJECT_SCHEMA_NAME(object_id),'].','[',OBJECT_NAME(object_id),']') AS Table_Name
	,Index_Name AS Column_Name
	,Column_Name AS Data_Type 
	,CONCAT('',
		STUFF(
			IIF([Index_Type]		= '','', COALESCE(', ' + RTRIM([Index_Type]),	'') )
			+ IIF([is_primary_key]	= 0	,'', COALESCE(', ' + RTRIM('Primary Key'),	'') )
			+ IIF([is_unique]		= 0	,'', COALESCE(', ' + RTRIM('Unique'),		''))
			+ IIF([has_filter]		= 0	,'', COALESCE(', ' + RTRIM('Filtered'),		''))
			, 1, 2, ''
			)
	) AS CONSTRAINTS
	,5 AS [filtering_id]
INTO #table_index_info	
 FROM

(
	SELECT 
		 o.object_id        	AS [object_id]
		,ind.name				AS [Index_Name]
		,col.name				AS [Column_Name]
		,ind.type_desc			AS [Index_Type]
		,ind.is_unique		AS [is_unique]
		,ind.is_primary_key AS [is_primary_key]
		,ind.has_filter		 [has_filter]
	FROM 
			sys.indexes ind
		INNER JOIN 
			 sys.index_columns ic 
		ON  ind.object_id = ic.object_id AND ind.index_id = ic.index_id 
		INNER JOIN 
			 sys.columns col 
		ON ic.object_id = col.object_id AND ic.column_id = col.column_id 
		INNER JOIN
			sys.objects o
		ON o.object_id = ind.object_id
	WHERE 
		o.type_desc = 'USER_TABLE' 
) index_sub_query

-- We create a temporary table for storing key information. This is becuase it will be easier later when we want to combine the various columns
-- that might be part of a key into a single column in the form of comma separated variables 
 IF OBJECT_ID('tempdb.dbo.#table_key_info', 'U') IS NOT NULL
  DROP TABLE #table_key_info; 

SELECT
	CONCAT('[',SCHEMA_NAME(T.schema_id),'].','[',T.name,']') AS Table_Name , 
	kc.name AS [Column_Name],
	CASE kc.type
		WHEN 'PK' THEN 'Primary Key'
		WHEN 'UQ' THEN 'Unique'
	END AS [Data_Type],
	COL_NAME(T.object_id, C.column_id) AS CONSTRAINTS,
	6 AS [filtering_id]
INTO #table_key_info
FROM 
		sys.objects AS T
    INNER JOIN
	    sys.columns AS C 
	ON T.object_id = C.object_id
	INNER JOIN 
		sys.key_constraints kc
	ON kc.parent_object_id = T.object_id
WHERE  T.type_desc = 'USER_TABLE' 
UNION ALL
SELECT 
   CONCAT('[',OBJECT_SCHEMA_NAME(f.parent_object_id),'].','[',OBJECT_NAME(f.parent_object_id),']') AS Table_Name , 
   f.name AS [Column_Name], 
   'Foreign Key' AS [Data_Type],
   
   CONCAT( COL_NAME(fc.parent_object_id, fc.parent_column_id),' --> [',OBJECT_SCHEMA_NAME(f.referenced_object_id),'].','[',OBJECT_NAME(f.referenced_object_id),'] - ',COL_NAME(fc.referenced_object_id, fc.referenced_column_id)) AS CONSTRAINTS,
   6 AS [filtering_id]
    
FROM 
		sys.foreign_keys AS f 
	INNER JOIN 
		sys.foreign_key_columns AS fc 
	ON f.OBJECT_ID = fc.constraint_object_id
ORDER BY
	[Table_Name]


-- Beginning ofthe Union All statements where we combine all sections related to tables together 
SELECT
	Table_Name
	,Column_Name
	,Data_Type
	,CONSTRAINTS
	,[filtering_id]
INTO #table_info
FROM
(
SELECT 
	Table_Name
	,Column_Name
	,Data_Type
	,CONCAT('',
		STUFF(
			 IIF([primary key] = '','', COALESCE(', ' + RTRIM([primary key]),     '') )
			+ IIF([Foreign Key] = '','', COALESCE(', ' + RTRIM([Foreign Key]), '') )
			+ IIF([Unique_Constraint] = '','', COALESCE(', ' + RTRIM([Unique_Constraint]),  ''))
			+ IIF([Identity] = '','', COALESCE(', ' + RTRIM([Identity]),  ''))
			+ IIF([Default] = '','', COALESCE(', ' + RTRIM([Default]),  ''))
			+ IIF([Allow Nulls] = '','', COALESCE(', ' + RTRIM([Allow Nulls]),  ''))
			, 1, 2, ''
			)
	) AS CONSTRAINTS
	,0 AS [filtering_id]
	
 FROM
 (

 SELECT 
	   CONCAT('[',SCHEMA_NAME(T.schema_id),'].','[',T.name,']') AS Table_Name ,
       C.name AS Column_Name ,
	   CASE TYPE_NAME(C.user_type_id)
			WHEN 'varchar' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
			WHEN 'char' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
			WHEN 'nvarchar' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
			WHEN 'nchar' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
			WHEN 'decimal' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',C.precision,',',C.scale,')')
			WHEN 'numeric' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',C.precision,',',C.scale,')')
			ELSE TYPE_NAME(C.user_type_id)
		END AS  Data_Type ,
	   IIF(i.is_primary_key IS NULL, '','Primary Key') 'Primary Key',
	   IIF(fk.constraint_column_id IS NULL,'',CONCAT('Foreign Key - ','[',OBJECT_SCHEMA_NAME(fk.referenced_object_id),'].','[',OBJECT_NAME(fk.referenced_object_id),']')) as 'Foreign Key',
	   IIF(dc.definition IS NULL, '',CONCAT('Default - ',dc.definition)) AS [Default],
	   CASE c.is_nullable
			WHEN 0 THEN 'Non Null'
			WHEN 1 THEN ''
			ELSE ''
		END as [Allow Nulls],
		CASE c.is_identity
			WHEN 0 THEN ''
			WHEN 1 THEN 'Identity'
			ELSE ''
		END as [Identity],
		CASE i.is_unique_constraint
			WHEN 1 THEN 'Unique'
			WHEN 0 THEN ''
			ELSE ''
		END as [Unique_Constraint]
		
		
FROM	sys.objects AS T
       INNER JOIN
	    sys.columns AS C 
	    ON T.object_id = C.object_id
	   LEFT OUTER JOIN 
		sys.foreign_key_columns  fk
	   ON fk.parent_object_id = c.object_id AND fk.parent_column_id = c.column_id
	   LEFT OUTER JOIN 
		 sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
	   LEFT OUTER JOIN 
		sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
	   LEFT OUTER JOIN 
		sys.default_constraints dc 
	   ON t.object_id = dc.parent_object_id AND dc.parent_column_id = c.column_id
WHERE  T.type_desc = 'USER_TABLE' 
) sub_query

UNION ALL
SELECT 
	DISTINCT
	 CONCAT('[',OBJECT_SCHEMA_NAME(d.referencing_id),'].','[',OBJECT_NAME(d.referencing_id),']') AS [Table_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(d.referenced_id),'].','[',OBJECT_NAME(d.referenced_id),']') AS [Column_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Constraints]
	 ,1 AS [filtering_id]
FROM 
	sys.sql_expression_dependencies d 
INNER JOIN 
	sys.objects o 
ON
	d.referencing_id = o.object_id 
WHERE 
	o.TYPE IN ('u')
	AND ISNULL(o.is_ms_shipped, 0) = 0
	AND OBJECT_SCHEMA_NAME(d.referenced_id) IS NOT NULL
	AND OBJECT_SCHEMA_NAME(d.referencing_id) IS NOT NULL

UNION ALL

SELECT 
	DISTINCT
	 CONCAT('[',OBJECT_SCHEMA_NAME(d.referenced_id),'].','[',OBJECT_NAME(d.referenced_id),']') AS [Table_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(d.referencing_id),'].','[',OBJECT_NAME(d.referencing_id),']') AS [Column_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [CONSTRAINTS]
	 ,2 AS [filtering_id]
FROM 
	sys.sql_expression_dependencies d 
INNER JOIN 
	sys.objects o 
ON
	d.referenced_id = o.object_id 
WHERE 
	o.TYPE IN ('u')
	AND ISNULL(o.is_ms_shipped, 0) = 0
	AND OBJECT_SCHEMA_NAME(d.referenced_id) IS NOT NULL
	AND OBJECT_SCHEMA_NAME(d.referencing_id) IS NOT NULL

UNION ALL

--- This displays "[schema_name].[table_name] is not dependent on any object"if no objects depend on the table
SELECT 
	 CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [Table_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']',' is not dependent on any object')AS [Column_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [CONSTRAINTS]
	 ,1 AS [filtering_id]
FROM 
	sys.objects o  
LEFT OUTER JOIN 
	sys.sql_expression_dependencies d
ON
	d.referencing_id = o.object_id 
WHERE 
	o.TYPE IN ('u')
	AND d.referencing_id IS NULL

UNION ALL

--- This displays "No dependent object"if no objects depend on the table
SELECT 
	 CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [Table_Name]
	 ,'No dependent object'AS [Column_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [CONSTRAINTS]
	 ,2 AS [filtering_id]
FROM 
	sys.objects o  
LEFT OUTER JOIN 
	sys.sql_expression_dependencies d
ON
	d.referenced_id = o.object_id 
WHERE 
	o.TYPE IN ('u')
	AND d.referenced_id IS NULL

-- Constraints
UNION ALL

-- List all default constraints 
SELECT
	CONCAT('[',SCHEMA_NAME(T.schema_id),'].','[',T.name,']') AS Table_Name ,
	   dc.name AS Column_Name ,
	   'Default' AS Data_Type,
	   CONCAT(C.name, ' = ', dc.definition) AS CONSTRAINTS,
	  3 AS [filtering_id]
FROM	
			sys.objects AS T
	   INNER JOIN 
			sys.default_constraints dc 
	   ON 
			t.object_id = dc.parent_object_id 
       LEFT OUTER JOIN
			sys.columns AS C 
	    ON 
			 C.object_id = dc.parent_object_id AND dc.parent_column_id = c.column_id
WHERE  T.type_desc = 'USER_TABLE' 

UNION ALL
-- List all check constraints 
SELECT 
	 CONCAT('[',SCHEMA_NAME(T.schema_id),'].','[',T.name,']') AS Table_Name 
	  ,cc.name AS Column_Name 
      ,'Check' AS Data_Type
      ,cc.definition AS CONSTRAINTS
	  ,3 AS [filtering_id]
FROM 
		sys.objects T 
     INNER JOIN 
		 sys.check_constraints  cc
     ON cc.parent_object_id = T.object_id 
     LEFT OUTER JOIN sys.columns  C 
         ON cc.parent_object_id = C.object_id AND cc.parent_column_id = C.column_id 
WHERE T.type_desc = 'USER_TABLE'

UNION ALL
--- This displays |"N/A(No Constraint)" |  N/A   | N/A  | if no constraints are associated with a table
SELECT
	CONCAT('[',OBJECT_SCHEMA_NAME(t.object_id),'].','[',OBJECT_NAME(t.object_id),']') AS [Table_Name],
	'N/A (No Constraints)'	AS [Column_Name],	-- Constraint Name
	'N/A'				AS [Data_Type], -- Constraint Type
	'N/A'				AS [CONSTRAINTS],
	 3					AS [filtering_id]
FROM 
		sys.objects AS T
WHERE
	T.type_desc = 'USER_TABLE' 
	AND
	t.object_id NOT IN	
	(
	SELECT
		T.object_id AS Table_ID 
	FROM	
				sys.objects AS T
		   INNER JOIN 
				sys.default_constraints dc 
		   ON 
				t.object_id = dc.parent_object_id 
		   LEFT OUTER JOIN
				sys.columns AS C 
			ON 
				 C.object_id = dc.parent_object_id AND dc.parent_column_id = c.column_id
	WHERE  T.type_desc = 'USER_TABLE' 
	UNION ALL
	SELECT 
		 T.object_id AS Table_ID 
	FROM 
			sys.objects T 
		 INNER JOIN 
			 sys.check_constraints  cc
		 ON cc.parent_object_id = T.object_id 
		 LEFT OUTER JOIN sys.columns  C 
			 ON cc.parent_object_id = C.object_id AND cc.parent_column_id = C.column_id 
	WHERE T.type_desc = 'USER_TABLE'
	)

-- Triggers
UNION ALL

SELECT
	CONCAT('[',OBJECT_SCHEMA_NAME(tr.parent_id),'].','[',OBJECT_NAME(tr.parent_id),']') AS [Table_Name],
	CONCAT('[',OBJECT_SCHEMA_NAME(tr.object_id),'].','[',OBJECT_NAME(tr.object_id),']')AS [Column_Name], -- Trigger Name
	CASE tr.is_instead_of_trigger
		WHEN 0 THEN 'AFTER'
		WHEN 1 THEN 'INSTEAD OF'
		ELSE ''
	END AS [Data_Type], -- Trigger Type
		CONCAT('',
		STUFF(
			 IIF(CHARINDEX('UPDATE',OBJECT_DEFINITION(tr.object_id))=0,'', COALESCE(', ' + RTRIM('UPDATE'),     ''))  
			+IIF(CHARINDEX('INSERT',OBJECT_DEFINITION(tr.object_id))=0,'', COALESCE(', ' + RTRIM('INSERT'),     '')) 
			+IIF(CHARINDEX('DELETE',OBJECT_DEFINITION(tr.object_id))=0,'', COALESCE(', ' + RTRIM('DELETE'),     ''))
			,1,2,'' 
		)
	) AS [CONSTRAINTS],
	 4 AS [filtering_id]
FROM 
		sys.triggers tr
	INNER JOIN
		sys.objects t
	ON t.object_id = tr.parent_id
WHERE 
	tr.is_ms_shipped =0
	AND
	tr.parent_id <> 0
	AND 
	T.type_desc = 'USER_TABLE' 
UNION ALL

--- This displays |"N/A(No triggers)" |  N/A   | N/A  | if no triggers are associated with a table

SELECT
	CONCAT('[',OBJECT_SCHEMA_NAME(t.object_id),'].','[',OBJECT_NAME(t.object_id),']') AS [Table_Name],
	'N/A (No triggers)'	AS [Column_Name], -- Trigger Name
	'N/A'				AS [Data_Type], -- Trigger Type
	'N/A'				AS [CONSTRAINTS],
	 4					AS [filtering_id]
FROM 
		sys.objects t
	LEFT OUTER JOIN
		sys.triggers tr
	ON t.object_id = tr.parent_id
WHERE 
	tr.object_id IS NULL
	AND 
	T.type_desc = 'USER_TABLE'

-- Indexes
UNION ALL

SELECT  MAX(Table_Name) AS Table_Name
	   ,Column_Name
	   , Data_Type = 
			STUFF(
					(
						SELECT ', ' + Data_Type
						FROM #table_index_info b 
					    WHERE b.Column_Name = a.Column_Name
						FOR XML PATH('')
					), 
					1, 2, ''
				)
	   ,MAX(CONSTRAINTS) collate SQL_Latin1_General_CP1_CI_AS AS CONSTRAINTS
	   ,MAX(filtering_id) AS filtering_id
FROM #table_index_info a
GROUP BY Column_Name

UNION ALL
--- This displays |"N/A(No index)" |  N/A   | N/A  | if no indices are associated with a table

SELECT
	CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [Table_Name],
	'N/A (No index)'	AS [Column_Name], -- Index Name
	'N/A'				AS [Data_Type], --   Index Type
	'N/A'				AS [CONSTRAINTS],
	 5					AS [filtering_id]
FROM 
			sys.objects o
		LEFT OUTER JOIN
			sys.indexes ind
		ON o.object_id = ind.object_id
WHERE 
	ind.object_id IS NULL
	AND 
	o.type_desc = 'USER_TABLE'

--KEYS
UNION ALL

SELECT  MAX(Table_Name) AS Table_Name
	   , Column_Name
	   , MAX(Data_Type)  AS Data_type
	   ,CONSTRAINTS =  
			REPLACE(STUFF(
					(
						SELECT ', ' + CONSTRAINTS
						FROM #table_key_info b 
					    WHERE b.Column_Name = a.Column_Name
						FOR XML PATH('')
					), 
					1, 2, ''
				),'&gt;', '>')
	   ,MAX(filtering_id) AS filtering_id
FROM #table_key_info a
GROUP BY Column_Name

UNION ALL
--- This displays |"N/A(No keys)" |  N/A   | N/A  | if no indices are associated with a table

SELECT
	CONCAT('[',OBJECT_SCHEMA_NAME(t.object_id),'].','[',OBJECT_NAME(t.object_id),']') AS [Table_Name],
	'N/A (No keys)'	AS [Column_Name],	-- Key Name
	'N/A'				AS [Data_Type], -- Key Type
	'N/A'				AS [CONSTRAINTS],
	 6					AS [filtering_id]
FROM 
		sys.objects AS T
WHERE
	T.type_desc = 'USER_TABLE' 
	AND
	t.object_id NOT IN (
						SELECT
							T.object_id AS table_id
						FROM 
								sys.objects AS T
							INNER JOIN
								sys.columns AS C 
							ON T.object_id = C.object_id
							INNER JOIN 
								sys.key_constraints kc
							ON kc.parent_object_id = T.object_id
						WHERE  T.type_desc = 'USER_TABLE' 
						UNION ALL
						SELECT 
						   f.parent_object_id AS table_id 
						FROM 
								sys.foreign_keys AS f 
							INNER JOIN 
								sys.foreign_key_columns AS fc 
							ON f.OBJECT_ID = fc.constraint_object_id
					) 

) table_sub_query
ORDER BY Table_Name

SELECT @table_count = (SELECT COUNT( DISTINCT Table_Name) FROM #table_info)

SET @table_list =  
(
	SELECT
		(
			SELECT 
				CONCAT('#',t1.Table_Name) AS '@href'
				, t1.Table_Name AS 'div'			
			FROM (SELECT DISTINCT(Table_Name) FROM #table_info) t1
		
			FOR XML PATH('a'), TYPE
		),
		'' AS 'br'
		FOR XML PATH(''),TYPE
)


SET @xml_doc_table =  
(
SELECT
	(SELECT 
		t2.Table_Name AS '@name'
		,t2.Table_Name AS 'b'
		FOR XML PATH('a'),type),		
	(SELECT
		@xml_header_table,	
		(
			SELECT 
			
				 (SELECT  Column_Name AS 'td' FOR XML PATH(''),type)
				,(SELECT   Data_Type  AS 'td'FOR XML PATH(''),type)
				,(SELECT   CONSTRAINTS  AS 'td'FOR XML PATH(''),type)
			
			FROM #table_info t1
			WHERE t1.Table_Name = t2.Table_Name
			AND
				t1.filtering_id = 0
			FOR XML PATH('tr'), TYPE
		),
		'' AS 'br'
		FOR XML PATH('table'),TYPE
	),
	'Keys: ' AS 'h5',
	(SELECT
		 @xml_header_key,	
		(	
			SELECT 
			
				 (SELECT   t1.Column_Name	AS 'td' FOR XML PATH(''),TYPE)
				,(SELECT   t1.Data_Type		AS 'td'	FOR XML PATH(''),TYPE)
				,(SELECT   t1.CONSTRAINTS	AS 'td'	FOR XML PATH(''),TYPE)
			
			FROM #table_info t1
			WHERE t1.Table_Name = t2.Table_Name
			AND
				t1.filtering_id = 6
			FOR XML PATH('tr'), TYPE
			
		),
		'' AS 'br'
		FOR XML PATH('table'),TYPE
	),
	'Constraints: ' AS 'h5',
	(SELECT
		 @xml_header_constraint,	
		(	
			SELECT 
			
				 (SELECT   t1.Column_Name	AS 'td' FOR XML PATH(''),TYPE)
				,(SELECT   t1.Data_Type		AS 'td'	FOR XML PATH(''),TYPE)
				,(SELECT   t1.CONSTRAINTS	AS 'td'	FOR XML PATH(''),TYPE)
			
			FROM #table_info t1
			WHERE t1.Table_Name = t2.Table_Name
			AND
				t1.filtering_id = 3
			FOR XML PATH('tr'), TYPE
			
		),
		'' AS 'br'
		FOR XML PATH('table'),TYPE
	),
	'Triggers: ' AS 'h5',
	(SELECT
		 @xml_header_trigger,	
		(	
			SELECT 
			
				 (SELECT   t1.Column_Name	AS 'td' FOR XML PATH(''),TYPE)
				,(SELECT   t1.Data_Type		AS 'td'	FOR XML PATH(''),TYPE)
				,(SELECT   t1.CONSTRAINTS	AS 'td'	FOR XML PATH(''),TYPE)
			
			FROM #table_info t1
			WHERE t1.Table_Name = t2.Table_Name
			AND
				t1.filtering_id = 4
			FOR XML PATH('tr'), TYPE
			
		),
		'' AS 'br'
		FOR XML PATH('table'),TYPE
	),
	'Indices: ' AS 'h5',
	(SELECT
		 @xml_header_index,	
		(	
			SELECT 
			
				 (SELECT   t1.Column_Name	AS 'td' FOR XML PATH(''),TYPE)
				,(SELECT   t1.Data_Type		AS 'td'	FOR XML PATH(''),TYPE)
				,(SELECT   t1.CONSTRAINTS	AS 'td'	FOR XML PATH(''),TYPE)
			
			FROM #table_info t1
			WHERE t1.Table_Name = t2.Table_Name
			AND
				t1.filtering_id = 5
			FOR XML PATH('tr'), TYPE
			
		),
		'' AS 'br'
		FOR XML PATH('table'),TYPE
	),
	CONCAT('Objects that depend on ',t2.Table_Name,':') AS 'h5',
	(
		SELECT 
			  'dependency' AS '@class',
			 (SELECT  t1.Column_Name  AS 'li' FOR XML PATH(''),type)
		FROM 
			#table_info t1
		WHERE 
			t1.Table_Name = t2.Table_Name
			AND
			t1.filtering_id = 2
		FOR XML PATH('span'), type,root('ul')
	),

	'' AS 'hr'
FROM (SELECT DISTINCT Table_Name FROM #table_info) t2
FOR XML PATH ('')
)



SELECT @xml_doc_table = (SELECT  @table_list,@xml_doc_table for xml path (''))

SELECT @xml_doc_table = (SELECT  @table_heading,@xml_doc_table for xml path (''))

-- Views


 IF OBJECT_ID('tempdb.dbo.#view_info', 'U') IS NOT NULL
  DROP TABLE #view_info; 

/*
-- [filtering_id] is a column that we introduce to identify what information we are storing in the temporary table
-- Code:
---********************************
--- [filtering_id]  |  Information
---********************************
---       0         |    Column information
---       1         |    Dependent Objects
---       2         |    Objects Dependent On
---       3         |    Constraints
---       4         |    Triggers
---       5         |    Indices
*/

SELECT
	View_Name
	,[Column_Name]
	,[Data_Type]
	,[Constraints]
	,[filtering_id]
INTO #view_info
FROM
(
SELECT
	 CONCAT('[',SCHEMA_NAME(V.schema_id),'].','[',V.name,']') AS View_Name,
	 C.name AS Column_Name,
	  CASE TYPE_NAME(C.user_type_id)
			WHEN 'varchar' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
			WHEN 'char' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
			WHEN 'nvarchar' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
			WHEN 'nchar' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',IIF(C.max_length = -1, 'max',CAST(C.max_length AS VARCHAR(20)) ),')')
			WHEN 'decimal' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',C.precision,',',C.scale,')')
			WHEN 'numeric' THEN CONCAT(TYPE_NAME(C.user_type_id),'(',C.precision,',',C.scale,')')
			ELSE TYPE_NAME(C.user_type_id)
		END AS  Data_Type,
		CASE c.is_nullable
			WHEN 0 THEN 'Non Null'
			WHEN 1 THEN ''
			ELSE ''
		END as [Constraints],
		0 AS [filtering_id]

FROM 
		sys.views V
	INNER JOIN
	    sys.columns AS C 
	ON V.object_id = C.object_id
UNION ALL
	SELECT 
	DISTINCT
	 CONCAT('[',OBJECT_SCHEMA_NAME(d.referencing_id),'].','[',OBJECT_NAME(d.referencing_id),']') AS [View_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(d.referenced_id),'].','[',OBJECT_NAME(d.referenced_id),']') AS [Column_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Constraints]
	 ,1 AS [filtering_id]
	FROM 
		sys.sql_expression_dependencies d 
	INNER JOIN 
		sys.objects o 
	ON
		d.referencing_id = o.object_id 
	WHERE 
		o.TYPE IN ('V')
		AND ISNULL(o.is_ms_shipped, 0) = 0
		AND OBJECT_SCHEMA_NAME(d.referenced_id) IS NOT NULL
		AND OBJECT_SCHEMA_NAME(d.referencing_id) IS NOT NULL
UNION ALL
	SELECT 
	DISTINCT
	 CONCAT('[',OBJECT_SCHEMA_NAME(d.referenced_id),'].','[',OBJECT_NAME(d.referenced_id),']') AS [View_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(d.referencing_id),'].','[',OBJECT_NAME(d.referencing_id),']') AS [Column_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Constraints]
	 ,2 AS [filtering_id]
	FROM 
		sys.sql_expression_dependencies d 
	INNER JOIN 
		sys.objects o 
	ON
		d.referenced_id = o.object_id 
	WHERE 
		o.TYPE IN ('V')
		AND ISNULL(o.is_ms_shipped, 0) = 0
		AND OBJECT_SCHEMA_NAME(d.referenced_id) IS NOT NULL
		AND OBJECT_SCHEMA_NAME(d.referencing_id) IS NOT NULL


UNION ALL

--- This displays "[schema_name].[view_name] is not dependent on any object"if no objects depend on the view
SELECT 
	 CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [View_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']',' is not dependent on any object')AS [Column_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [CONSTRAINTS]
	 ,1 AS [filtering_id]
FROM 
	sys.objects o  
LEFT OUTER JOIN 
	sys.sql_expression_dependencies d
ON
	d.referencing_id = o.object_id 
WHERE 
	o.TYPE IN ('V')
	AND d.referencing_id IS NULL

UNION ALL

--- This displays "No dependent object"if no objects depend on the view
SELECT 
	 CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [View_Name]
	 ,'No dependent object'AS [Column_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [CONSTRAINTS]
	 ,2 AS [filtering_id]
FROM 
	sys.objects o  
LEFT OUTER JOIN 
	sys.sql_expression_dependencies d
ON
	d.referenced_id = o.object_id 
WHERE 
	o.TYPE IN ('V')
	AND d.referenced_id IS NULL

-- Triggers
UNION ALL

SELECT
	CONCAT('[',OBJECT_SCHEMA_NAME(tr.parent_id),'].','[',OBJECT_NAME(tr.parent_id),']') AS [Table_Name],
	CONCAT('[',OBJECT_SCHEMA_NAME(tr.object_id),'].','[',OBJECT_NAME(tr.object_id),']')AS [Column_Name], -- Trigger Name
	CASE tr.is_instead_of_trigger
		WHEN 0 THEN 'AFTER'
		WHEN 1 THEN 'INSTEAD OF'
		ELSE ''
	END AS [Data_Type], -- Trigger Type
		CONCAT('',
		STUFF(
			 IIF(CHARINDEX('UPDATE',OBJECT_DEFINITION(tr.object_id))=0,'', COALESCE(', ' + RTRIM('UPDATE'),     ''))  
			+IIF(CHARINDEX('INSERT',OBJECT_DEFINITION(tr.object_id))=0,'', COALESCE(', ' + RTRIM('INSERT'),     '')) 
			+IIF(CHARINDEX('DELETE',OBJECT_DEFINITION(tr.object_id))=0,'', COALESCE(', ' + RTRIM('DELETE'),     ''))
			,1,2,'' 
		)
	) AS [CONSTRAINTS],
	 4 AS [filtering_id]
FROM 
		sys.triggers tr
	INNER JOIN
		sys.objects o
	ON o.object_id = tr.parent_id
WHERE 
	tr.is_ms_shipped =0
	AND
	tr.parent_id <> 0
	AND 
	o.TYPE IN ('V')
UNION ALL

--- This displays |"N/A(No triggers)" |  N/A   | N/A  | if no triggers are associated with a view

SELECT
	CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [Table_Name],
	'N/A (No triggers)'	AS [Column_Name], -- Trigger Name
	'N/A'				AS [Data_Type], -- Trigger Type
	'N/A'				AS [CONSTRAINTS],
	 4					AS [filtering_id]
FROM 
		sys.objects o
	LEFT OUTER JOIN
		sys.triggers tr
	ON o.object_id = tr.parent_id
WHERE 
	tr.object_id IS NULL
	AND 
	o.TYPE IN ('V')
) view_subquery

SET @view_list =  
(
	SELECT
	(
		SELECT 
			CONCAT('#',t1.View_Name) AS '@href'
			, t1.View_Name AS 'div'			
		FROM (SELECT DISTINCT(View_Name) FROM #view_info) t1
		
		FOR XML PATH('a'), TYPE
	)
	,'' AS 'br'
	FOR XML PATH(''),TYPE
)

SET @xml_doc_view =  
(
SELECT
	(SELECT 
		t2.View_Name AS '@name'
		,t2.View_Name AS 'b'
		FOR XML PATH('a'),type),		
	(	
		SELECT 
		@xml_header_view,
		(
		 SELECT	
				 (SELECT  Column_Name AS 'td' FOR XML PATH(''),type)
				,(SELECT   Data_Type  AS 'td'FOR XML PATH(''),type)
				,(SELECT   CONSTRAINTS  AS 'td'FOR XML PATH(''),type)
			
			FROM #view_info t1
			WHERE
				t1.View_Name = t2.View_Name
				AND
				t1.filtering_id = 0 
			FOR XML PATH('tr'), TYPE
		)
		,'' AS 'br'
		FOR XML PATH('table'),TYPE
	),
		'Triggers: ' AS 'h5',
	(SELECT
		 @xml_header_trigger,	
		(	
			SELECT 
			
				 (SELECT   t1.Column_Name	AS 'td' FOR XML PATH(''),TYPE)
				,(SELECT   t1.Data_Type		AS 'td'	FOR XML PATH(''),TYPE)
				,(SELECT   t1.CONSTRAINTS	AS 'td'	FOR XML PATH(''),TYPE)
			
			FROM #view_info t1
			WHERE t1.View_Name = t2.View_Name
			AND
				t1.filtering_id = 4
			FOR XML PATH('tr'), TYPE
			
		),
		'' AS 'br'
		FOR XML PATH('table'),TYPE
	),
	CONCAT('Objects that depend on ',t2.View_Name,':') AS 'h5',
	(
		SELECT 
			  'dependency' AS '@class',
			 (SELECT  t1.Column_Name  AS 'li' FOR XML PATH(''),type)
		FROM 
			#view_info t1
		WHERE 
			t1.View_Name = t2.View_Name
			AND
			t1.filtering_id = 2
		FOR XML PATH('span'), type,root('ul')
	),
	'Dependent on:' AS 'h5',
	(
		SELECT 
			  'dependency' AS '@class',
			 (SELECT  t1.Column_Name  AS 'li' FOR XML PATH(''),type)
		FROM 
			#view_info t1
		WHERE 
			t1.View_Name = t2.View_Name
			AND
			t1.filtering_id = 1
		FOR XML PATH('span'), type,root('ul')
	),
	'' AS 'hr'
FROM (SELECT DISTINCT View_Name FROM #view_info) t2
FOR XML PATH ('')
)

SELECT @xml_doc_view = (SELECT  @view_list,@xml_doc_view for xml path (''))

SELECT @xml_doc_view = (SELECT  @view_heading,@xml_doc_view for xml path (''))

-- Procedures

 IF OBJECT_ID('tempdb.dbo.#procedure_info', 'U') IS NOT NULL
  DROP TABLE #procedure_info; 


SELECT
	[Procedure_Name]
	,[Procedure_Description]
	,[Parameter_Name]
	,[Data_Type]
	,[Parameter_Type]
	,[filtering_id]
INTO #procedure_info
FROM
(	SELECT 
		CONCAT('[',SCHEMA_NAME(SO.schema_id),'].','[',SO.name,']') AS [Procedure_Name] ,
		CASE (CHARINDEX('Description:', m.definition))
		WHEN  0
			THEN ''
		ELSE
			SUBSTRING(m.definition, CHARINDEX('Description:', m.definition) + LEN('Description:')
					, CHARINDEX(CHAR(10),SUBSTRING(m.definition, CHARINDEX('Description:', m.definition) + LEN('Description:'),LEN(m.definition)))) 
		END AS [Procedure_Description],
		ISNULL(P.name,'No Parameters')AS [Parameter_Name],
		 CASE TYPE_NAME(P.user_type_id)
				WHEN 'varchar' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
				WHEN 'char' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
				WHEN 'nvarchar' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
				WHEN 'nchar' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
				WHEN 'decimal' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',P.precision,',',P.scale,')')
				WHEN 'numeric' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',P.precision,',',P.scale,')')
				ELSE ISNULL(TYPE_NAME(P.user_type_id),'')
			END AS  Data_Type,
		CASE P.is_output 
			WHEN 0 THEN 'Input'
			WHEN 1 THEN 'Output'
			ELSE '' 
		END AS [Parameter_Type],
		0 AS [filtering_id]

	FROM 
			sys.objects AS SO
		LEFT OUTER JOIN sys.parameters AS P 
			ON SO.OBJECT_ID = P.OBJECT_ID	
		LEFT OUTER JOIN 
			sys.sql_modules m 
		 ON m.object_id=so.object_id
	WHERE SO.TYPE IN ('P')
		AND ISNULL(SO.is_ms_shipped, 0) = 0
UNION ALL
	SELECT 
	DISTINCT
	 CONCAT('[',OBJECT_SCHEMA_NAME(d.referencing_id),'].','[',OBJECT_NAME(d.referencing_id),']') AS [Procedure_Name]
	 ,'' AS [Procedure_Description]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(d.referenced_id),'].','[',OBJECT_NAME(d.referenced_id),']') AS [Parameter_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Parameter_Type]
	 ,1 AS [filtering_id]
	FROM 
		sys.sql_expression_dependencies d 
	INNER JOIN 
		sys.objects o 
	ON
		d.referencing_id = o.object_id 
	WHERE 
		o.TYPE IN ('P')
		AND ISNULL(o.is_ms_shipped, 0) = 0
		AND OBJECT_SCHEMA_NAME(d.referenced_id) IS NOT NULL
		AND OBJECT_SCHEMA_NAME(d.referencing_id) IS NOT NULL
UNION ALL
	SELECT 
	DISTINCT
	 CONCAT('[',OBJECT_SCHEMA_NAME(d.referenced_id),'].','[',OBJECT_NAME(d.referenced_id),']') AS [Procedure_Name]
	 ,'' AS [Procedure_Description]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(d.referencing_id),'].','[',OBJECT_NAME(d.referencing_id),']') AS [Parameter_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Parameter_Type]
	 ,2 AS [filtering_id]
	FROM 
		sys.sql_expression_dependencies d 
	INNER JOIN 
		sys.objects o 
	ON
		d.referenced_id = o.object_id 
	WHERE 
		o.TYPE IN ('P')
		AND ISNULL(o.is_ms_shipped, 0) = 0
		AND OBJECT_SCHEMA_NAME(d.referenced_id) IS NOT NULL
		AND OBJECT_SCHEMA_NAME(d.referencing_id) IS NOT NULL
UNION ALL

--- This displays "[schema_name].[procedure_name] is not dependent on any object'"if no objects depend on the procedure
SELECT 
	 CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [Procedure_Name]
	  ,'' AS [Procedure_Description]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']',' is not dependent on any object')AS [Parameter_Name]	 
	 ,'' AS [Parameter_Type]
	 ,'' AS [CONSTRAINTS]
	 ,1 AS [filtering_id]
FROM 
	sys.objects o  
LEFT OUTER JOIN 
	sys.sql_expression_dependencies d
ON
	d.referencing_id = o.object_id 
WHERE 
	o.TYPE IN ('P')
	AND d.referencing_id IS NULL

UNION ALL

--- This displays "No dependent object"if no objects depend on the Procedure
SELECT 
	 CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [Procedure_Name]
	  ,'' AS [Procedure_Description]
	 ,'No dependent object'AS [Parameter_Name]	 
	 ,'' AS [Parameter_Type]
	 ,'' AS [CONSTRAINTS]
	 ,2 AS [filtering_id]
FROM 
	sys.objects o  
LEFT OUTER JOIN 
	sys.sql_expression_dependencies d
ON
	d.referenced_id = o.object_id 
WHERE 
	o.TYPE IN ('P')
	AND d.referenced_id IS NULL
) procedure_sub_query
ORDER BY 
	[Procedure_Name]

SET @procedure_list =  
(
	SELECT
	(
		SELECT 
			CONCAT('#',t1.Procedure_Name) AS '@href'
			, t1.Procedure_Name AS 'div'			
		FROM (SELECT DISTINCT(Procedure_Name) FROM #procedure_info) t1
		
		FOR XML PATH('a'), type
	)
	,'' AS 'br'
	FOR XML PATH(''),TYPE
)


SET @xml_doc_proc =  
(
SELECT

	(SELECT 
		t2.Procedure_Name AS '@name'
		,t2.Procedure_Name AS 'b'
		FOR XML PATH('a'),type),
	t2.Procedure_Description AS 'p',
	'' AS 'p',
	(
		SELECT
		@xml_header_proc,
		(
			SELECT 

				 (SELECT  t1.Parameter_Name  AS 'td' FOR XML PATH(''),type)
				,(SELECT  t1.Data_Type AS 'td'FOR XML PATH(''),type)
				,(SELECT  t1.Parameter_Type AS 'td'FOR XML PATH(''),type)
			FROM 
				#procedure_info t1
			WHERE 
				t1.Procedure_Name = t2.Procedure_Name
				AND
				t1.filtering_id = 0 
			FOR XML PATH('tr'), TYPE
		)
		,'' AS 'br'
		FOR XML PATH('table'),TYPE
	),
	CONCAT('Objects that depend on ',t2.Procedure_Name,':') AS 'h5',
	(
		SELECT 
			  'dependency' AS '@class',
			 (SELECT  t1.Parameter_Name  AS 'li' FOR XML PATH(''),type)
		FROM 
			#procedure_info t1
		WHERE 
			t1.Procedure_Name = t2.Procedure_Name
			AND
			t1.filtering_id = 2
		FOR XML PATH('span'), type,root('ul')
	),
	'Dependent on:' AS 'h5',
	(
		SELECT 
			  'dependency' AS '@class',
			 (SELECT  t1.Parameter_Name  AS 'li' FOR XML PATH(''),type)
		FROM 
			#procedure_info t1
		WHERE 
			t1.Procedure_Name = t2.Procedure_Name
			AND
			t1.filtering_id = 1
		FOR XML PATH('span'), type,root('ul')
	),
	'' AS 'hr'
	

FROM (SELECT DISTINCT Procedure_Name, Procedure_Description  FROM #procedure_info) t2
FOR XML PATH ('')
)


SELECT @xml_doc_proc = (SELECT  @procedure_list,@xml_doc_proc for xml path (''))

SELECT @xml_doc_proc = (SELECT  @procedure_heading,@xml_doc_proc for xml path (''))

-- Table Valued Function
 IF OBJECT_ID('tempdb.dbo.#table_function_info', 'U') IS NOT NULL
  DROP TABLE #table_function_info; 

SELECT 
	[Function_Name],
	[Parameter_Name],
	[Data_Type],
	[Parameter_Type],
	[filtering_id]
INTO #table_function_info
FROM
(
SELECT 
	
    CONCAT('[',SCHEMA_NAME(SO.schema_id),'].','[',SO.name,']') AS [Function_Name] ,
	
	ISNULL(P.name,'No Parameters')AS [Parameter_Name],

	 CASE TYPE_NAME(P.user_type_id)
			WHEN 'varchar' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
			WHEN 'char' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
			WHEN 'nvarchar' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
			WHEN 'nchar' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
			WHEN 'decimal' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',P.precision,',',P.scale,')')
			WHEN 'numeric' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',P.precision,',',P.scale,')')
			ELSE ISNULL(TYPE_NAME(P.user_type_id),'')
		END AS  Data_Type,
		CASE P.is_output 
			WHEN 0 THEN 'Input'
			WHEN 1 THEN 'Output'
			ELSE '' 
		END AS [Parameter_Type],
		0 AS [filtering_id]
FROM
		sys.sql_modules m 
	INNER JOIN 
		sys.objects so 
     ON m.object_id=so.object_id
	 INNER JOIN
		sys.all_objects ao
	ON ao.object_id = so.object_id
	 LEFT OUTER JOIN sys.parameters AS P 
		ON SO.OBJECT_ID = P.OBJECT_ID
WHERE 
	  so.name NOT LIKE'%fn_diagramobjects%'
	  AND 
	  ao.type = 'tf'
	  AND 
	  so.is_ms_shipped = 0
UNION ALL
SELECT 
	
    CONCAT('[',SCHEMA_NAME(SO.schema_id),'].','[',SO.name,']') AS [Function_Name] ,
	
	SUBSTRING(definition, CHARINDEX('RETURNS', definition) + LEN('RETURNS')
			, CHARINDEX('AS',definition) - (CHARINDEX('RETURNS', definition)+ LEN('RETURNS'))) AS [Parameter_Name],
	 'TABLE' AS  Data_Type,
	'Output' AS [Parameter_Type],
	0 AS [filtering_id]
FROM
		sys.sql_modules m 
	INNER JOIN 
		sys.objects so 
     ON m.object_id=so.object_id
	 INNER JOIN
		sys.all_objects ao
	ON ao.object_id = so.object_id	 
WHERE 
	  so.name NOT LIKE'%fn_diagramobjects%'
	  AND 
	  ao.type = 'tf'
	  AND 
	  so.is_ms_shipped = 0
UNION ALL
SELECT 
	DISTINCT
	 CONCAT('[',OBJECT_SCHEMA_NAME(d.referencing_id),'].','[',OBJECT_NAME(d.referencing_id),']') AS [Function_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(d.referenced_id),'].','[',OBJECT_NAME(d.referenced_id),']') AS [Parameter_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Parameter_Type]
	 ,1 AS [filtering_id]

FROM 
		sys.sql_expression_dependencies d 
	INNER JOIN 
		sys.objects o 
ON
	d.referencing_id = o.object_id 
WHERE 
	 ISNULL(o.is_ms_shipped, 0) = 0
	AND o.type = 'tf'
	AND OBJECT_SCHEMA_NAME(d.referenced_id) IS NOT NULL
	AND OBJECT_SCHEMA_NAME(d.referencing_id) IS NOT NULL
UNION ALL
	SELECT 
	DISTINCT
	 CONCAT('[',OBJECT_SCHEMA_NAME(d.referenced_id),'].','[',OBJECT_NAME(d.referenced_id),']') AS [Function_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(d.referencing_id),'].','[',OBJECT_NAME(d.referencing_id),']') AS [Parameter_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Parameter_Type]
	 ,2 AS [filtering_id]
	FROM 
		sys.sql_expression_dependencies d 
	INNER JOIN 
		sys.objects o 
	ON
		d.referenced_id = o.object_id 
	WHERE 
		o.TYPE IN ('tf')
		AND ISNULL(o.is_ms_shipped, 0) = 0
		AND OBJECT_SCHEMA_NAME(d.referenced_id) IS NOT NULL
		AND OBJECT_SCHEMA_NAME(d.referencing_id) IS NOT NULL
UNION ALL
--- This displays "[schema_name].[procedure_name] is not dependent on any object'"if no objects depend on the table valued function
SELECT 
	 CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [Function_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']',' is not dependent on any object')AS [Parameter_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Parameter_Type]
	 ,1 AS [filtering_id]
FROM 
	sys.objects o  
LEFT OUTER JOIN 
	sys.sql_expression_dependencies d
ON
	d.referencing_id = o.object_id 
WHERE 
	o.TYPE IN ('tf')
	AND d.referencing_id IS NULL

UNION ALL

--- This displays "No dependent object"if no objects depend on the table valued function
SELECT 
	 CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [Function_Name]
	 ,'No dependent object'AS [Parameter_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Parameter_Type]
	 ,2 AS [filtering_id]
FROM 
	sys.objects o  
LEFT OUTER JOIN 
	sys.sql_expression_dependencies d
ON
	d.referenced_id = o.object_id 
WHERE 
	o.TYPE IN ('tf')
	AND d.referenced_id IS NULL
) sub_query
ORDER BY Function_Name

SET @xml_doc_table_func =  
(
SELECT
	(SELECT 
		t2.Function_Name AS '@name'
		,t2.Function_Name AS 'b'
		FOR XML PATH('a'),type),
	
	(
		SELECT
		@xml_header_func,
		(
			SELECT 

				 (SELECT  Parameter_Name  AS 'td' FOR XML PATH(''),type)
				,(SELECT   Data_Type AS 'td'FOR XML PATH(''),type)
				,(SELECT    Parameter_Type AS 'td'FOR XML PATH(''),type)
			FROM #table_function_info t1
			WHERE
				 t1.Function_Name = t2.Function_Name
				 AND
				 t1.filtering_id = 0 
			FOR XML PATH('tr'), TYPE
		)
		,'' AS 'br'
		FOR XML PATH('table'), TYPE
	),
	CONCAT('Objects that depend on ',t2.Function_Name,':') AS 'h5',
	(
		SELECT 
			  'dependency' AS '@class',
			 (SELECT  t1.Parameter_Name  AS 'li' FOR XML PATH(''),type)
		FROM 
			#table_function_info t1
		WHERE 
			t1.Function_Name = t2.Function_Name
			AND
			t1.filtering_id = 2
		FOR XML PATH('span'), type,root('ul')
	),
	'Dependent on:' AS 'h5',
	(
		SELECT 
			  'dependency' AS '@class',
			 (SELECT  t1.Parameter_Name  AS 'li' FOR XML PATH(''),type)
		FROM 
			#table_function_info t1
		WHERE 
			t1.Function_Name = t2.Function_Name
			AND
			t1.filtering_id = 1
		FOR XML PATH('span'), type,root('ul')
	),
	'' AS 'hr'
FROM (SELECT DISTINCT Function_Name  FROM #table_function_info) t2
FOR XML PATH ('')
)

SET @table_function_list =  
(
	SELECT
	(
		SELECT 
			CONCAT('#',t1.Function_Name) AS '@href'
			, t1.Function_Name AS 'div'			
		FROM (SELECT DISTINCT(Function_Name) FROM #table_function_info) t1
		
		FOR XML PATH('a'), TYPE
	),
	'' as 'br'
	FOR XML PATH(''),TYPE
)

		

SELECT @xml_doc_table_func = (SELECT  @table_function_list,@xml_doc_table_func for xml path (''))

SELECT @xml_doc_table_func = (SELECT  @table_function_heading,@xml_doc_table_func for xml path (''))

-- User Defined Functions

IF OBJECT_ID('tempdb.dbo.#function_info', 'U') IS NOT NULL
  DROP TABLE #function_info; 
SELECT
	[Function_Name]
	,[Parameter_Name]
	,[Data_Type]
	,[Parameter_Type]
	,[filtering_id]
INTO  #function_info
FROM
(
SELECT 
	
    CONCAT('[',SCHEMA_NAME(SO.schema_id),'].','[',SO.name,']') AS [Function_Name] ,
	
	ISNULL(P.name,'No Parameters')AS [Parameter_Name],

	 CASE TYPE_NAME(P.user_type_id)
			WHEN 'varchar' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
			WHEN 'char' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
			WHEN 'nvarchar' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
			WHEN 'nchar' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',IIF(P.max_length = -1, 'max',CAST(P.max_length AS VARCHAR(20)) ),')')
			WHEN 'decimal' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',P.precision,',',P.scale,')')
			WHEN 'numeric' THEN CONCAT(TYPE_NAME(P.user_type_id),'(',P.precision,',',P.scale,')')
			ELSE ISNULL(TYPE_NAME(P.user_type_id),'')
		END AS  Data_Type,
		CASE P.is_output 
			WHEN 0 THEN 'Input'
			WHEN 1 THEN 'Output'
			ELSE '' 
		END AS [Parameter_Type],
		0 AS [filtering_id]
FROM
		sys.sql_modules m 
	INNER JOIN 
		sys.objects so 
     ON m.object_id=so.object_id
	 INNER JOIN
		sys.all_objects ao
	ON ao.object_id = so.object_id
	 LEFT OUTER JOIN sys.parameters AS P 
		ON SO.OBJECT_ID = P.OBJECT_ID
WHERE so.type_desc like '%function%'
	  AND
	  so.name NOT LIKE'%fn_diagramobjects%'
	  AND 
	  ao.type = 'fn'
	  AND 
	  so.is_ms_shipped = 0
UNION ALL
SELECT 
	DISTINCT
	 CONCAT('[',OBJECT_SCHEMA_NAME(d.referencing_id),'].','[',OBJECT_NAME(d.referencing_id),']') AS [Function_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(d.referenced_id),'].','[',OBJECT_NAME(d.referenced_id),']') AS [Parameter_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Parameter_Type]
	 ,1 AS [filtering_id]

FROM 
		sys.sql_expression_dependencies d 
	INNER JOIN 
		sys.objects o 
ON
	d.referencing_id = o.object_id 
WHERE 
	 ISNULL(o.is_ms_shipped, 0) = 0
	AND o.type = 'fn'
	AND OBJECT_SCHEMA_NAME(d.referenced_id) IS NOT NULL
	AND OBJECT_SCHEMA_NAME(d.referencing_id) IS NOT NULL
UNION ALL
SELECT 
	DISTINCT
	 CONCAT('[',OBJECT_SCHEMA_NAME(d.referenced_id),'].','[',OBJECT_NAME(d.referenced_id),']') AS [Function_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(d.referencing_id),'].','[',OBJECT_NAME(d.referencing_id),']') AS [Parameter_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Parameter_Type]
	 ,2 AS [filtering_id]
FROM 
	sys.sql_expression_dependencies d 
INNER JOIN 
	sys.objects o 
ON
	d.referenced_id = o.object_id 
WHERE 
	o.TYPE IN ('fn')
	AND ISNULL(o.is_ms_shipped, 0) = 0
	AND OBJECT_SCHEMA_NAME(d.referenced_id) IS NOT NULL
	AND OBJECT_SCHEMA_NAME(d.referencing_id) IS NOT NULL

UNION ALL
--- This displays "[schema_name].[procedure_name] is not dependent on any object'"if no objects depend on the function
SELECT 
	 CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [Function_Name]
	 ,CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']',' is not dependent on any object')AS [Parameter_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Parameter_Type]
	 ,1 AS [filtering_id]
FROM 
	sys.objects o  
LEFT OUTER JOIN 
	sys.sql_expression_dependencies d
ON
	d.referencing_id = o.object_id 
WHERE 
	o.TYPE IN ('fn')
	AND d.referencing_id IS NULL

UNION ALL

--- This displays "No dependent object"if no objects depend on the function
SELECT 
	 CONCAT('[',OBJECT_SCHEMA_NAME(o.object_id),'].','[',OBJECT_NAME(o.object_id),']') AS [Function_Name]
	 ,'No dependent object'AS [Parameter_Name]	 
	 ,'' AS [Data_Type]
	 ,'' AS [Parameter_Type]
	 ,2 AS [filtering_id]
FROM 
	sys.objects o  
LEFT OUTER JOIN 
	sys.sql_expression_dependencies d
ON
	d.referenced_id = o.object_id 
WHERE 
	o.TYPE IN ('fn')
	AND d.referenced_id IS NULL
) function_sub_query
ORDER BY Function_Name

SET @function_list =  
(
	SELECT
	(
		SELECT 
			CONCAT('#',t1.Function_Name) AS '@href'
			, t1.Function_Name AS 'div'			
		FROM (SELECT DISTINCT(Function_Name) FROM #function_info) t1
		
		FOR XML PATH('a'), TYPE
	)
	,'' AS 'br'
	FOR XML PATH(''),TYPE
)


SET @xml_doc_func =  
(
SELECT

	(SELECT 
		t2.Function_Name AS '@name'
		,t2.Function_Name AS 'b'
		FOR XML PATH('a'),type),
	
	(	
		SELECT
		@xml_header_func,
		(
			SELECT 

				 (SELECT  Parameter_Name  AS 'td' FOR XML PATH(''),type)
				,(SELECT   Data_Type AS 'td'FOR XML PATH(''),type)
				,(SELECT    Parameter_Type AS 'td'FOR XML PATH(''),type)
			FROM #function_info t1
			WHERE 
				t1.Function_Name = t2.Function_Name
				AND
				t1.filtering_id = 0 				
			FOR XML PATH('tr'), TYPE
		)
		,'' AS 'br'
		FOR XML PATH('table'), TYPE
	),
	CONCAT('Objects that depend on ',t2.Function_Name,':') AS 'h5',
	(
		SELECT 
			  'dependency' AS '@class',
			 (SELECT  t1.Parameter_Name  AS 'li' FOR XML PATH(''),type)
		FROM 
			#function_info t1
		WHERE 
			t1.Function_Name = t2.Function_Name
			AND
			t1.filtering_id = 2
		FOR XML PATH('span'), type,root('ul')
	),
	'Dependent on:' AS 'h5',
	(
		SELECT 
			  'dependency' AS '@class',
			 (SELECT  t1.Parameter_Name  AS 'li' FOR XML PATH(''),type)
		FROM 
			#function_info t1
		WHERE 
			t1.Function_Name = t2.Function_Name
			AND
			t1.filtering_id = 1
		FOR XML PATH('span'), type,root('ul')
	),
	'' AS 'hr'
FROM (SELECT DISTINCT Function_Name  FROM #function_info) t2
FOR XML PATH ('')
)


SELECT @xml_doc_func = (SELECT  @function_list,@xml_doc_func for xml path (''))


SELECT @xml_doc_func = (SELECT  @function_heading,@xml_doc_func for xml path (''))

-- Forming the final xml document by combining the individual XML documents 

SELECT @xml_doc = (SELECT  @xml_doc, @index_of_topics for xml path (''))

SELECT @xml_doc = (SELECT  @xml_doc, @xml_doc_schema for xml path (''))

SELECT @xml_doc = (SELECT  @xml_doc, @xml_doc_user_defined_data_type for xml path (''))

SELECT @xml_doc = (SELECT  @xml_doc, @xml_doc_user_defined_table_type for xml path (''))

SELECT @xml_doc = (SELECT  @xml_doc, @xml_doc_table for xml path (''))

SELECT @xml_doc = (SELECT  @xml_doc,  @xml_doc_view for xml path (''))

SELECT @xml_doc = (SELECT  @xml_doc, @xml_doc_proc for xml path (''))

SELECT @xml_doc = (SELECT  @xml_doc, @xml_doc_func for xml path (''))

SELECT @xml_doc = (SELECT  @xml_doc, @xml_doc_table_func for xml path ('HTML'))



SET @xmL_doc.modify('insert sql:variable("@style_xml") as first into (/HTML)[1]')



SELECT @xml_doc AS [Output_Document]