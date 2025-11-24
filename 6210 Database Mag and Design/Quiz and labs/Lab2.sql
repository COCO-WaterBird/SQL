USE AdventureWorks2008R2;
SELECT * FROM  Production.Product;

--2.1
/* Write a query to select the product id, name, list price,
and selling start date for the product(s) that have a list
price greater than the highest list price - $10.
Use the CAST function to display the date only for
the selling start date. Use an alias to make the report more
presentable if a column header is missing.
Sort the returned data by the selling start date.
Hint: a) You need to work with the Production.Product table.
b) You’ll need to use a simple subquery to get the highest
list price and use it in a WHERE clause.
c) The syntax for CAST is CAST(expression AS data_type),
where expression is the column name we want to format and
we can use DATE as data_type for this question to display
just the date. */

SELECT ProductID, Name, ListPrice,
       CAST(SellStartDate AS DATE) AS SellStartDate
FROM Production.Product
WHERE ListPrice > (SELECT MAX(ListPrice) - 10 FROM Production.Product)
ORDER BY SellStartDate;

--2.2
/* Retrieve the customer ID, most recent order date, and total number
of orders for each customer. Use a column alias to make the report
more presentable if a column header is missing.
Sort the returned data by the total number of orders in
the descending order.
Hint: You need to work with the Sales.SalesOrderHeader table. */

SELECT CustomerID,
       MAX(OrderDate) AS MostRecentOrderDate,
       COUNT(SalesOrderID) AS TotalNumberOfOrders
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalNumberOfOrders DESC;

-- 2-3
/* Write a query to calculate the "orders to customer ratio"
(number of orders / unique customers) for each sales territory.
Return only the sales territories which have a ratio >= 5.
Include the Territory ID and Territory Name in the returned data.
Sort the returned data by TerritoryID.*/

SELECT st.TerritoryID, st.Name AS TerritoryName,
       CAST(COUNT(soh.SalesOrderID) AS FLOAT) / COUNT(DISTINCT soh.CustomerID) AS OrdersToCustomerRatio
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesTerritory AS st
ON soh.TerritoryID = st.TerritoryID
GROUP BY st.TerritoryID, st.Name
HAVING CAST(COUNT(soh.SalesOrderID) AS FLOAT) / COUNT(DISTINCT soh.CustomerID) >= 5
ORDER BY st.TerritoryID;

--2.4
/* Write a query to create a report containing the customer id,
first name, last name and email address for all customers.
Make sure a customer is returned even if the names and/or
email address is missing.
Sort the returned data by CustomerID. Return only the customers
who have a customer id between 25000 and 27000. */

SELECT c.CustomerID, p.FirstName, p.LastName, e.EmailAddress
FROM Sales.Customer AS c
LEFT JOIN Person.Person AS p
ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.EmailAddress AS e
ON c.PersonID = e.BusinessEntityID
WHERE c.CustomerID BETWEEN 25000 AND 27000
ORDER BY c.CustomerID;

-- 2.5
/* Write a query to retrieve the years in which there were orders
placed but no order worth more than $150000 was placed.
Use TotalDue in Sales.SalesOrderHeader as the order value.
Return the "year" and "total product quantity sold for the year"
columns. The order quantity column is in SalesOrderDetail.
Sort the returned data by the
"total product quantity sold for the year" column in desc. */


SELECT YEAR(soh.OrderDate) AS OrderYear,
       SUM(sod.OrderQty) AS TotalProductQuantitySold
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesOrderDetail AS sod
ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY YEAR(soh.OrderDate)
HAVING MAX(soh.TotalDue) <= 150000
ORDER BY TotalProductQuantitySold DESC;

-- 2.6
/*
Using AdventureWorks2008R2, write a query to return the territory id
and total sales of orders on all new year days for each territory.
Pease keep in mind it's one combined total sales per territory for
all new year days regardless of the year as reflected by the data
stored in the database. The database has several years' data.
Include only orders which contained at least a product in black and
more than 40 unique products when calculating the total sales.
Use TotalDue in SalesOrderHeader as an order's value when calculating
the total sales. Return the total sales as an integer. Sort the returned
data by the territory id in asc.
*/


SELECT soh.TerritoryID,
       CAST(SUM(soh.TotalDue) AS INT) AS TotalSales
FROM Sales.SalesOrderHeader AS soh
WHERE MONTH(soh.OrderDate) = 1 
  AND DAY(soh.OrderDate) = 1  -- All New Year's Days (1st Jan of any year)
  AND soh.SalesOrderID IN (
      SELECT DISTINCT sod.SalesOrderID
      FROM Sales.SalesOrderDetail AS sod
      JOIN Production.Product AS p
        ON sod.ProductID = p.ProductID
      GROUP BY sod.SalesOrderID
      HAVING
        SUM(CASE WHEN p.Color = 'Black' THEN 1 ELSE 0 END) >= 1  -- At least one black product
        AND 
        COUNT(DISTINCT sod.ProductID) > 40                  
  )
GROUP BY soh.TerritoryID
ORDER BY soh.TerritoryID ASC;




