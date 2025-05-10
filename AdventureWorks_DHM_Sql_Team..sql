SELECT*FROM Sales.Customer

--Tüm çalışanların ortalama maaş ortalaması
SELECT AVG(Rate) AS OrtalamaMaas
FROM HumanResources.EmployeePayHistory

--1 Ocak 2020'den sonra maaşı değişmiş olan çalışanların ortalama maaşı
SELECT AVG(Rate) AS OrtalamaMaas
FROM HumanResources.EmployeePayHistory
WHERE RateChangeDate >= '2020-01-01'


------
select*from Sales.CreditCard
SELECT CreditCardID, CardType, CardNumber, ExpMonth, ExpYear
FROM Sales.CreditCard
WHERE CardType = 'Visa'

------------------------------------
--adres city dallas olan kayıtlar
select*from Person.Address

SELECT *
FROM Person.Address
WHERE City = 'Dallas'
-------------------------------------
select*from Sales.SalesOrderDetail
--birim fiyatı 250'nin üzerinde olan satış kalemlerini listele
SELECT SalesOrderID, ProductID, UnitPrice, OrderQty
FROM Sales.SalesOrderDetail
WHERE UnitPrice > 250
--UnitPrice > 250 olan kayıtların ortalamasını verir

SELECT AVG(UnitPrice) AS OrtalamaFiyat
FROM Sales.SalesOrderDetail
WHERE UnitPrice > 250SELECT * FROM [Production].[ProductCategory]
