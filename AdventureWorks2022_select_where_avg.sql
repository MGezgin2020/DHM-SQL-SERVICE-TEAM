
use AdventureWorks2022

-- Customer provided us [ProductCostHistory] and [ProductListPriceHistory]. Please check the ratio of the list price to the cost of every item (Note: This is not a report request ! ) 

-- 1) The requested report is : Please state which goods have a lower ratio compared to average ratio.

-- Then for these items with a lower ratio, provide: * The inventory count (how many such items exist).- 
-- * The total amount of these items individually. (e.g.: There are 200 pieces of article X in inventory)


SELECT
	PPH.ProductID, 
	PI.Quantity AS InventoryCount, --How many items are in inventory
	PPH.ListPrice / NULLIF(PCH.StandardCost, 0) AS PriceToCostRatio, -- List price divided by cost(avoids division by zero)
	PPH.ListPrice * PI.Quantity AS TotalStock -- Total value of items in stock
FROM Production.ProductListPriceHistory PPH
JOIN Production.ProductCostHistory AS PCH ON PPH.ProductID = PCH.ProductID
JOIN Production.ProductInventory AS PI ON PPH.ProductID = PI.ProductID 
WHERE -- Filter only products with price-to-cost ratio lower than average ratio
	(PPH.ListPrice / NULLIF(PCH.StandardCost, 0)) < (
		SELECT 
			AVG(PPH.ListPrice / NULLIF(PCH.StandardCost, 0)) as AvgRatio  -- Calculate average price-to-cost ratio
		FROM Production.ProductListPriceHistory AS PPH
		JOIN Production.ProductCostHistory AS PCH ON PPH.ProductID = PCH.ProductID)


-- List all products whose standard cost is higher than the average standard cost across all products.
-- Show: ProductID, StandardCost.

SELECT 
	ProductID, 
	StandardCost 
FROM Production.ProductCostHistory
WHERE StandardCost > (
	SELECT 
	AVG(StandardCost) -- Calculate average standard cost
	FROM Production.ProductCostHistory)
	-- This query returns only the products that cost more than the overall average cost.

-- Show the products that have an inventory quantity greater than the average inventory.
-- Show: ProductID, Quantity.

SELECT 
	ProductID,
	Quantity -- Quantity available in inventory
FROM Production.ProductInventory
WHERE Quantity > (
	SELECT AVG(Quantity) -- Calculate the average inventory quantity
	FROM Production.ProductInventory)
	-- This query finds products with inventory levels above the average

-- Display the products whose list price is below the average list price.
-- Show: ProductID, ListPrice.

SELECT 
	ProductID,
	ListPrice -- The list (sale) price of the product
FROM Production.ProductListPriceHistory
WHERE ListPrice < (
	SELECT AVG(ListPrice)
	FROM Production.ProductListPriceHistory)
	-- This query returns products priced lower than the average market price.

