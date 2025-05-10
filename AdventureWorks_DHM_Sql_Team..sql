SELECT*FROM Sales.Customer

--Tüm çalışanların ortalama maaş ortalaması/ Average salary of whole workers . OrtalamaMaas means AverageSalary
SELECT AVG(Rate) AS OrtalamaMaas
FROM HumanResources.EmployeePayHistory

--1 Ocak 2020'den sonra maaşı değişmiş olan çalışanların ortalama maaşı/average salary of the workers whose salaries are modified after 1st January 2020
SELECT AVG(Rate) AS OrtalamaMaas
FROM HumanResources.EmployeePayHistory
WHERE RateChangeDate >= '2020-01-01'


------
select*from Sales.CreditCard
SELECT CreditCardID, CardType, CardNumber, ExpMonth, ExpYear
FROM Sales.CreditCard
WHERE CardType = 'Visa'

------------------------------------
--adres city dallas olan kayıtlar / Records for the city 'Dallas'
select*from Person.Address

SELECT *
FROM Person.Address
WHERE City = 'Dallas'
-------------------------------------
select*from Sales.SalesOrderDetail
--birim fiyatı 250'nin üzerinde olan satış kalemlerini listele/ List of the items where the item price is above USD250
SELECT SalesOrderID, ProductID, UnitPrice, OrderQty
FROM Sales.SalesOrderDetail
WHERE UnitPrice > 250
--UnitPrice > 250 olan kayıtların ortalamasını verir / this is to provide the average of the recordings where the UnitPrice is more than USD250

SELECT AVG(UnitPrice) AS OrtalamaFiyat 
FROM Sales.SalesOrderDetail
WHERE UnitPrice > 250SELECT * FROM [Production].[ProductCategory]
-- OrtalamaFiyat = AveragePrice
