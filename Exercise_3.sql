USE AdventureWorks2017;

WITH Acc_CTE AS (
	SELECT a.CustomerID
		, a.SalesOrderID
		, a.OrderDate
		, ROW_NUMBER() OVER (PARTITION BY a.CustomerID ORDER BY OrderDate DESC) AS 'RNK'
		FROM Sales.SalesOrderHeader AS a 
			INNER JOIN (
				SELECT x.CustomerID
					FROM Sales.SalesOrderHeader AS x
					, Purchasing.Vendor
					GROUP BY x.CustomerID
					HAVING SUM(TotalDue) > 70000
				) AS b
		ON a.CustomerID = b.CustomerID
	)


SELECT * FROM Acc_CTE WHERE RNK <= 5 ORDER BY CustomerID, RNK;