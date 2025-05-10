
--Customer needs till next Monday the following information to decide further purchase :
--We are provided the following tables : [Purchasing].[SupplierCategories] . [Purchasing].[Suppliers] and [Warehouse].[StockItems]

--1) Basic Query with JOIN
--List all suppliers (Suppliers) along with their categories (SupplierCategories). The result set should include supplier name, category name, and phone number.

--2) Grouping and Sorting
--Calculate the total stock quantity (StockItems) for each supplier category (SupplierCategories). Order the results from the category with the highest stock to the lowest.

--They will have further questions about these tables on Monday.


-- List all suppliers with their corresponding category names and phone numbers by joining Suppliers and SupplierCategories tables.

SELECT 
SupplierName, SupplierCategoryName, PhoneNumber 
FROM Purchasing.Suppliers S
JOIN Purchasing.SupplierCategories AS SC ON S.SupplierCategoryID = SC.SupplierCategoryID

-- Calculate and list total stock quantities per supplier category, formatted with thousand separators for readability.

SELECT SupplierCategoryName, FORMAT(SUM(SIH.QuantityOnHand), 'N0', 'tr-TR') AS TotalStock FROM Purchasing.SupplierCategories SC
JOIN Purchasing.Suppliers AS SI ON SC.SupplierCategoryID = SI.SupplierCategoryID
JOIN Warehouse.StockItems AS WS ON SI.SupplierID = WS.SupplierID
JOIN Warehouse.StockItemHoldings AS SIH ON SIH.StockItemID = WS.StockItemID
GROUP BY SC.SupplierCategoryName
ORDER BY SUM(SIH.QuantityOnHand) DESC

-- Show how many products are provided under each supplier category.

SELECT 
	SC.SupplierCategoryName, 
	COUNT(WSI.StockItemID) AS TotalProducts 
FROM Purchasing.SupplierCategories SC
JOIN Purchasing.Suppliers AS PS ON SC.SupplierCategoryID = PS.SupplierCategoryID
JOIN Warehouse.StockItems AS WSI ON PS.SupplierID = WSI.SupplierID
GROUP BY SC.SupplierCategoryName
ORDER BY TotalProducts DESC

-- List products along with their stock quantity and corresponding supplier category.
SELECT 
	SC.SupplierCategoryName, 
	SI.StockItemName, 
	SIH.QuantityOnHand 
FROM Purchasing.SupplierCategories SC
JOIN Purchasing.Suppliers AS S ON SC.SupplierCategoryID = S.SupplierCategoryID
JOIN  Warehouse.StockItems AS SI ON SI.SupplierID = S.SupplierID
JOIN Warehouse.StockItemHoldings AS SIH ON SI.StockItemID = SIH.StockItemID
ORDER BY SC.SupplierCategoryName, SIH.QuantityOnHand DESC


-- Calculate the total revenue generated from each order.

SELECT 
	SO.OrderID,
	COUNT(SOL.OrderLineID) as TotalItems,
    FORMAT(SUM(SOL.UnitPrice * SOL.Quantity), 'C', 'en-US') AS TotalRevenue
FROM Sales.Orders SO
JOIN Sales.OrderLines AS SOL ON SO.OrderID = SOL.OrderID
GROUP BY SO.OrderID
ORDER BY
	SUM(SOL.UnitPrice * SOL.Quantity) DESC

-- Calculate the total number of orders and the total amount spent by customers per city. Only include cities where the total amount spent is greater than $5000.

SELECT 
    C.DeliveryCityID,
    COUNT(O.OrderID) AS TotalOrders, 
    FORMAT(SUM(OD.UnitPrice * OD.Quantity), 'C', 'en-US') AS TotalAmountSpent
FROM 
    Sales.Orders O
JOIN 
    Sales.Customers C ON O.CustomerID = C.CustomerID
JOIN 
    Sales.OrderLines OD ON O.OrderID = OD.OrderID
GROUP BY 
    C.DeliveryCityID
HAVING 
    SUM(OD.UnitPrice * OD.Quantity) > 5000
ORDER BY 
    TotalAmountSpent DESC