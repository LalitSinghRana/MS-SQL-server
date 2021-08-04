USE AdventureWorks2017;
GO

DROP PROCEDURE Person.list_names;  
GO

CREATE PROCEDURE Person.list_names @first NVARCHAR(30)
AS
IF(@first IS NULL OR @first='')
	BEGIN
		SELECT FirstName
			, ISNULL(MiddleName, '')
			, LastName
		FROM Person.Person
	END
ELSE
	BEGIN
		SELECT FirstName
			, ISNULL(MiddleName, '') AS 'MiddleName'
			, LastName
		FROM Person.Person
		WHERE FirstName = @first
	END
GO

EXEC Person.list_names @first = 'Sam';
