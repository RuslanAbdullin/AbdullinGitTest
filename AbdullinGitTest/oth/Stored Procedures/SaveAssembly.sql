CREATE PROCEDURE [oth].[SaveAssembly]
@assemblyName NVARCHAR (128) NULL, @destinationPath NVARCHAR (256) NULL, @sqlConnection NVARCHAR (256) NULL
AS EXTERNAL NAME [ExportDllFromSQLServer].[StoredProcedures].[AssemblyExporter]

