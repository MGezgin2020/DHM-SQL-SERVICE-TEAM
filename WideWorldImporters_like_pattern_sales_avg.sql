use WideWorldImporters

-- Specific Report Requests:
-- In the WideWorldImporters database, list the customers from the "Customers" table where the "CompanyName" column starts with "Super" and ends with "Corporation" OR ends only with "Enterprises".


SELECT
	CustomerName,
	CustomerID
FROM Sales.Customers
WHERE (CustomerName LIKE 'super%corporation') OR (CustomerName LIKE '%Enterprises') -- Starts with "super", ends with "corporation". Ends with "Enterprises".
ORDER BY CustomerName -- There is no such data matching the request.


-- List the products where the product name contains the word 'Cookie' AND the price is between 20 and 50.

SELECT
	StockItemID,
	StockItemName,
	UnitPrice
FROM Warehouse.StockItems
WHERE StockItemName LIKE '%Cookie%'  -- Contains "Cookie" in the name
AND UnitPrice BETWEEN 20 AND 50 -- Price between 20 and 50
ORDER BY UnitPrice


-- List the products where the product name matches the pattern '%ocks%' AND the stock quantity is greater than 500000.

SELECT 
	W.StockItemID,
	W.StockItemName,
	SIH.QuantityOnHand
FROM Warehouse.StockItems W
JOIN Warehouse.StockItemHoldings SIH ON SIH.StockItemID = W.StockItemID
WHERE W.StockItemName LIKE '%ocks%' -- Contains 'ocks' anywhere in name
AND SIH.QuantityOnHand > 500000
ORDER BY SIH.QuantityOnHand DESC


-- Calculate the total sales amount (Quantity × UnitPrice) only for products that have been sold. Exclude products that haven't been sold (Quantity = 0)

SELECT 
    StockItemID,
    Description,
    FORMAT(SUM(Quantity * UnitPrice), '###,###,##0.000') AS TotalSalesAmount
FROM Sales.InvoiceLines
WHERE 
    Quantity > 0  -- Exclude unsold items
GROUP BY 
	StockItemID,
    Description
ORDER BY 
    TotalSalesAmount DESC


-- Calculate the average price of products with a stock quantity below 50.

SELECT 
	AVG(SI.UnitPrice) AS AveragePrice
FROM Warehouse.StockItems SI
JOIN Warehouse.StockItemHoldings SIH on SIH.StockItemID = SI.StockItemID
WHERE SIH.QuantityOnHand < 50
