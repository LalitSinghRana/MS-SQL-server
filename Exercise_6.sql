USE AdventureWorks2017;

IF OBJECT_ID (N'Production.list_price_update_check') IS NOT NULL  
    DROP TRIGGER Production.list_price_update_check;  
GO  


--For update check
CREATE TRIGGER Production.list_price_update_check
ON Production.Product
FOR UPDATE 
AS	
BEGIN
	SET NOCOUNT ON;
	DECLARE @new_price MONEY, @old_price MONEY
	SELECT
		@new_price = inserted.ListPrice
	FROM inserted
	SELECT
		@old_price = deleted.ListPrice
	FROM deleted

	IF(@new_price > 1.15*@old_price) 
		BEGIN
			RAISERROR('Transaction failed: Price cannot be increased more than 15 percent', 11, 1);
			ROLLBACK TRAN;
		END
	ELSE
		BEGIN
			PRINT('Price updated successfully');
		END
END
GO


--After update check (uncomment the code)
/*
CREATE TRIGGER Production.list_price_update_check
ON Production.Product
AFTER UPDATE 
AS
BEGIN
	SET NOCOUNT ON;
	IF UPDATE(ListPrice)
		BEGIN
			DECLARE @new_price MONEY, @old_price MONEY
			SELECT
				@new_price = inserted.ListPrice
			FROM inserted
			SELECT
				@old_price = deleted.ListPrice
			FROM deleted

			IF(@new_price > 1.15*@old_price) 
				BEGIN
					RAISERROR('Transaction failed : Price cannot be increased more than 15 percent', 11, 1);
					ROLLBACK TRAN;
				END
			ELSE
				BEGIN
					PRINT('Price updated successfully');
				END
		END
END;
GO


--sample tests
SELECT ProductID, ListPrice
FROM Production.Product
WHERE ListPrice = 49.99;

UPDATE Production.Product
SET ListPrice = 149.99
WHERE ProductID = 714;

UPDATE Production.Product
SET ListPrice = 50.11
WHERE ProductID = 714;

SELECT ProductID, ListPrice
FROM Production.Product
WHERE ProductID = 714;
*/