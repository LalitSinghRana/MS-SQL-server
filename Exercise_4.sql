USE AdventureWorks2017;

IF OBJECT_ID (N'Sales.ufn_myFunc', N'IF') IS NOT NULL  
    DROP FUNCTION Sales.ufn_myFunc;  
GO  
CREATE FUNCTION Sales.ufn_myFunc(@SalesID int, @CurrencyCode varchar(3), @Date date)
RETURNS TABLE
AS 
RETURN
(
	SELECT sod.ProductID
		, sod.OrderQty
		, sod.UnitPrice
		, sod.UnitPrice * (
			SELECT EndOfDayRate FROM Sales.CurrencyRate
			WHERE FromCurrencyCode = 'USD' AND ToCurrencyCode = @CurrencyCode AND ModifiedDate = @Date
		) AS 'unit price converted' 
		FROM Sales.SalesOrderDetail AS sod
		WHERE sod.SalesOrderID = @SalesID
); 


--TEST
--Copy paste below in new query window


--SELECT * FROM Sales.ufn_myFunc(43659, 'GBP', '2011-05-31'); 