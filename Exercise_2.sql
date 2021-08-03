USE AdventureWorks2017;


-- using join
SELECT b.FirstName 
	+ ' ' + ISNULL(b.MiddleName,'')
	+ ' ' + b.LastName  AS 'Full Name'
	FROM (SELECT c.CustomerID
			FROM Sales.Customer AS c
			LEFT JOIN Sales.SalesOrderHeader AS o
			ON c.CustomerID = o.CustomerID
			WHERE o.SalesOrderID IS NULL) AS a
	INNER JOIN Person.Person AS b
	ON a.CustomerID = b.BusinessEntityID;

SELECT b.Name AS 'Store Name'
	FROM (SELECT c.CustomerID
			FROM Sales.Customer AS c
			LEFT JOIN Sales.SalesOrderHeader AS o
			ON c.CustomerID = o.CustomerID
			WHERE o.SalesOrderID IS NULL) AS a
	INNER JOIN Sales.Store AS b
	ON a.CustomerID = b.BusinessEntityID;


-- using a subquery
SELECT b.FirstName 
	+ ' ' + ISNULL(b.MiddleName,'')
	+ ' ' + b.LastName  AS 'Full Name'
	FROM Person.Person AS b,
	(SELECT CustomerID
		FROM Sales.Customer
		WHERE CustomerID NOT IN
			(SELECT DISTINCT CustomerID
				FROM Sales.SalesOrderHeader)) AS a
	WHERE a.CustomerID = b.BusinessEntityID;

SELECT b.Name AS 'Store Name'
	FROM Sales.Store AS b,
	(SELECT CustomerID
		FROM Sales.Customer
		WHERE CustomerID NOT IN
			(SELECT DISTINCT CustomerID
				FROM Sales.SalesOrderHeader)) as a
	WHERE a.CustomerID = b.BusinessEntityID;


-- using a CTE
WITH person_name_CTE(FullName) AS 
(SELECT b.FirstName 
	+ ' ' + ISNULL(b.MiddleName,'')
	+ ' ' + b.LastName  AS 'Full Name'
	FROM (SELECT c.CustomerID
			FROM Sales.Customer AS c
			LEFT JOIN Sales.SalesOrderHeader AS o
			ON c.CustomerID = o.CustomerID
			WHERE o.SalesOrderID IS NULL) AS a
	INNER JOIN Person.Person AS b
	ON a.CustomerID = b.BusinessEntityID)

SELECT FullName FROM person_name_CTE;

WITH store_name_CTE(StoreName) AS 
(SELECT b.Name AS 'Store Name'
	FROM Sales.Store AS b,
	(SELECT CustomerID
		FROM Sales.Customer
		WHERE CustomerID NOT IN
			(SELECT DISTINCT CustomerID
				FROM Sales.SalesOrderHeader)) as a
	WHERE a.CustomerID = b.BusinessEntityID)

SELECT StoreName FROM store_name_CTE;


-- using an EXSITS
SELECT b.FirstName 
	+ ' ' + ISNULL(b.MiddleName,'')
	+ ' ' + b.LastName  AS 'Full Name'
	FROM Person.Person AS b
	WHERE EXISTS (SELECT a.CustomerID 
		FROM (SELECT CustomerID
			FROM Sales.Customer
			WHERE CustomerID NOT IN
				(SELECT DISTINCT CustomerID
					FROM Sales.SalesOrderHeader)) AS a
		WHERE a.CustomerID = b.BusinessEntityID);

SELECT b.Name AS 'Store Name'
	FROM Sales.Store AS b
	WHERE EXISTS (SELECT a.CustomerID 
		FROM (SELECT c.CustomerID
			FROM Sales.Customer AS c
			LEFT JOIN Sales.SalesOrderHeader AS o
			ON c.CustomerID = o.CustomerID
			WHERE o.SalesOrderID IS NULL) AS a
		WHERE a.CustomerID = b.BusinessEntityID);