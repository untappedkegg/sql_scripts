/****** Script for SelectTopNRows command from SSMS  ******/
USE [your_database];

DECLARE @Id nvarchar(15), @TextField nvarchar(60);
DECLARE @TextColumn nvarchar(50) = N'[ColumnName1]';
DECLARE @ID_Column nvarchar(50) = N'[ObjectID]';
DECLARE @TableName nvarchar(100) = N'[dbo].[your_table_name]';
DECLARE @Find nvarchar(50) = 'Replace This';
DECLARE @Replace nvarchar(50) = 'With This';

--DECLARE c CURSOR FOR
DECLARE @Query nvarchar(1000) = 'DECLARE c CURSOR FOR ' +
'SELECT ' + @ID_Column +', ' + @TextColumn +' FROM ' + @TableName +
  ' WHERE ' + @TextColumn + ' LIKE ''%' + @Find + '%''';

--PRINT @Query
SET QUOTED_IDENTIFIER OFF;
EXECUTE sp_executesql @Query;

OPEN c;

FETCH NEXT FROM c
INTO @Id, @TextField;

WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @Update nvarchar(max) = 
'UPDATE ' + @TableName +
   ' SET ' + 
      @TextColumn + ' = REPLACE(' + @TextColumn + ', ''' + @Find + ''', ''' + @Replace + ''') ' +
 'WHERE ' + @ID_Column + ' = ''' + @Id + ''''

 --PRINT @Update;
 EXECUTE sp_executesql @Update;

FETCH NEXT FROM c
INTO @Id, @TextField;

END

CLOSE c;
DEALLOCATE c;

SET QUOTED_IDENTIFIER ON;