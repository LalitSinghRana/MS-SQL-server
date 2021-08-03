USE AdventureWorks2017;

-- 1-1

DECLARE @Number_Of_Records INT;
SELECT @Number_Of_Records = COUNT(*) FROM Sales.SalesPerson;
PRINT 'The number of records in the [SalesPerson] table are ' + CAST(@Number_Of_Records AS VARCHAR(10));


-- 1-2
SELECT FirstName AS 'Given Name'
	, LastName AS 'Surname'
	FROM Person.Person
	WHERE FirstName LIKE 'B%';


-- 1-3
SELECT p.FirstName
	, p.LastName
	, hr.JobTitle
	FROM Person.Person AS p 
	INNER JOIN HumanResources.Employee AS hr
	ON p.BusinessEntityID = hr.BusinessEntityID
	-- ORDER BY hr.JobTitle;
	WHERE hr.JobTitle LIKE 'Design Engineer' 
		OR hr.JobTitle LIKE 'Tool Designer' 
		OR hr.JobTitle LIKE 'Marketing Assistant';


-- 1-4
SELECT TOP 1 p.Name
	, p.Color
	FROM Production.Product AS p
	ORDER BY p.Weight DESC;

SELECT p.Name										-- Another way to do
	, p.Color										-- the same thing
	FROM Production.Product AS p
	WHERE p.Weight = (
		SELECT MAX(Weight) 
		FROM Production.Product);


-- 1-5
SELECT ISNULL(MaxQty, 0.00)
	, Description
	FROM Sales.SpecialOffer;


-- 1-6
SELECT AVG(AverageRate) AS '2005_USDtoGBP_Avg'
	FROM Sales.CurrencyRate
	WHERE FromCurrencyCode = 'USD' 
		AND ToCurrencyCode = 'GBP' 
		AND YEAR(CurrencyRateDate) = 2012;			--Using 2012 as AdventureWorks2017 doesn't contain data for 2005


-- 1-7
SELECT FirstName
	, LastName
	, ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS 'S.No.'
	FROM Person.Person
	WHERE FirstName LIKE '%ss%';


-- 1-8
SELECT BusinessEntityID
	, CASE 
		WHEN CommissionPct <= 0.00 THEN 'Band 0'
		WHEN CommissionPct <= 0.01 THEN 'Band 1'
		WHEN CommissionPct <= 0.015 THEN 'Band 2'
		ELSE 'Band 3'
	END AS 'Commission Band'
	FROM Sales.SalesPerson;


-- 1-9
DECLARE @id int;

SELECT @id = BusinessEntityID
	FROM Person.Person
	WHERE FirstName = 'Ruth' 
		AND LastName = 'Ellerbrock' 
		AND PersonType = 'EM';

EXEC dbo.uspGetEmployeeManagers @BusinessEntityID = @id;


-- 1-10
SELECT TOP 1 ProductID
	FROM Production.Product
	ORDER BY dbo.ufnGetStock(ProductID) DESC;