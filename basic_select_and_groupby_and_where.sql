
-- Sample Request: Customer provided us [Sales].[Invoices] data. We need to find top 5 customers according to the number of invoices issued. (Not according to the amount of the invoices but according to the number of invoices!)
-- Solution below:

SELECT TOP 5
	CustomerID,
	COUNT(*) AS InvoiceCount
FROM Sales.Invoices
GROUP BY CustomerID
ORDER BY InvoiceCount DESC

-- Additional analysis with Basic Select, Where and Group By below:

-- Find number of customers in each city.
-- Sample Request: We want to know how many customers are located in each city.
-- Solution below:

SELECT 
	DeliveryCityID,
	COUNT(*) AS CustomerCount
FROM Sales.Customers
GROUP BY DeliveryCityID
ORDER BY CustomerCount DESC


-- List all order lines where the quantity is greater than 10.
-- Sample Request: From [Sales].[OrderLines], list products where Quantity > 10.
-- Solution below:

SELECT 
	OrderLineID,
	OrderID,
	StockItemID,
	Quantity
FROM Sales.OrderLines
WHERE Quantity > 10

-- Find top 10 most stocked items.
-- Sample Request: Which products have the highest stock? 
-- Solution below:

SELECT TOP 10
	StockItemID,
	QuantityOnHand
FROM Warehouse.StockItemHoldings
ORDER BY QuantityOnHand DESC


-- Count invoices issued by each salesperson in the year 2016.
-- Sample Request: How many invoices did each salesperson create in 2016?
-- Solution below:

SELECT 
	SalespersonPersonID,
	COUNT(*) as InvoiceCount
FROM Sales.Invoices
WHERE InvoiceDate >= '2016-01-01' AND InvoiceDate < '2017-01-01'
GROUP BY SalespersonPersonID
ORDER BY InvoiceCount DESC
