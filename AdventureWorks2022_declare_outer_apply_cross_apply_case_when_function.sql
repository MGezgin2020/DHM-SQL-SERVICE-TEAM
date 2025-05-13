
use AdventureWorks2022

-- Here are two report requests in English based on AdventureWorks2022 OLTP, each requiring the use of FUNCTION, DECLARE (variables), and CASE WHEN logic.

-- Report Request 1: Customer Order Summary by Territory
-- Objective:
-- Generate a report that shows, for a given sales territory, each customer’s total number of orders, total order amount, and a classification of their spending behavior.

-- Requirements:
-- Use a scalar-valued function to return the total order amount per customer.
-- Use DECLARE to store the territory name as a variable.
-- Use CASE WHEN to categorize customers:
-- High if total > $50,000
-- Medium if $20,000–$50,000
-- Low if < $20,000
-- Relevant Tables:
-- Sales.SalesOrderHeader
-- Sales.Customer
-- Sales.SalesTerritory

-- Create function to get total order amount per customer:

GO
CREATE FUNCTION dbo.GetCustomerTotalOrderAmount(@CustomerID INT) -- create function to get total order amount by customer
RETURNS MONEY
AS
BEGIN
	DECLARE @Total MONEY;

	SELECT 
	@Total = SUM(TotalDue) 
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @CustomerID

RETURN ISNULL(@Total, 0)
END
GO


-- Declare territory name variable
DECLARE @TerritoryName NVARCHAR(50) = 'Northwest'

-- Customer order summary report by territory
SELECT
	C.CustomerID,
	T.Name AS Territory,
	OrderStats.OrderCount, -- Get total order count
	OrderStats.TotalOrderAmount,
	dbo.GetCustomerTotalOrderAmount(C.CustomerID) AS TotalAmountViaFunction,
	CASE -- classify spending behavior
		WHEN OrderStats.TotalOrderAmount > 50000 THEN 'High'
		When OrderStats.TotalOrderAmount Between 20000 and 50000 then 'Medium'
		Else 'Low'
	END AS SpendingCategory

FROM Sales.Customer C
JOIN Sales.SalesTerritory T ON C.TerritoryID = T.TerritoryID
OUTER APPLY ( -- Used to retrieve order summary data per customer (even if no orders exist)
		SELECT
			COUNT(SOH.SalesOrderID) as OrderCount,
			SUM(SOH.TotalDue) as TotalOrderAmount
		FROM Sales.SalesOrderHeader SOH
		WHERE SOH.CustomerID = C.CustomerID
) AS OrderStats
WHERE T.Name = @TerritoryName



-- Report Request 2: Employee Salary Classification by Department
-- Generate a report that shows, for a given department, each employee's salary and their classification (Low, Medium, High) based on the salary range.
-- Requirements:
-- Use a scalar function to return the salary of each employee.
-- Use DECLARE to store the department name as a variable.
-- Use CASE WHEN to classify employees by salary:
-- High if salary > $90,000
-- Medium if salary is between $50,000 and $90,000
-- Low if salary < $50,000

-- Relevant Tables:
-- HumanResources.Employee
-- HumanResources.Department
-- HumanResources.EmployeeDepartmentHistory

GO
CREATE FUNCTION dbo.GetEmployeeSalary(@EmployeeID INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @HourlyRate MONEY

	--Get the most recent salary from the EmployeePayHistory table
	SELECT TOP 1
		@HourlyRate = eph.Rate
	FROM HumanResources.EmployeePayHistory eph
	WHERE eph.BusinessEntityID = @EmployeeID
	ORDER BY eph.RateChangeDate DESC
	RETURN ISNULL (CAST(@HourlyRate * 40 * 52 AS MONEY, 0) -- Calculate annual salary assuming 40 hours/week and 52 weeks/year
END
GO

DECLARE @DepartmentName NVARCHAR(100) = 'Engineering'

SELECT  
	e.BusinessEntityID,
	e.NationalIDNumber,
	e.JobTitle,
	d.Name AS DepartmentName,
	salary.EmployeeSalary as EmployeeSalary,
	CASE
		WHEN salary.EmployeeSalary > 90.000 THEN 'High'
		WHEN salary.EmployeeSalary BETWEEN 50.000 AND 90.000 THEN 'Medium'
		WHEN salary.EmployeeSalary < 50.000 THEN 'Low'
		ELSE 'Unknown'
	END AS SalaryClassification
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
-- Call the scalar function for each employee to get their salary
CROSS APPLY (SELECT dbo.GetEmployeeSalary(e.BusinessEntityID) AS EmployeeSalary) salary
WHERE d.Name = @DepartmentName
ORDER BY e.JobTitle

