use AdventureWorks2008R2;
-- select * from dbo.a_new_table;

--Lab 3-1
/* Modify the following query to add a column that identifies the
frequency of repeat customers and contains the following values
based on the number of orders:
'No Order' for count = 0
'One Time' for count = 1
'Regular' for count range of 2-5
'Often' for count range of 6-10
'Loyal' for count greater than 10
Give the new column an alias to make the report more readable.
*/

SELECT 
    c.CustomerID, 
    c.TerritoryID, 
    FirstName, 
    LastName,
    COUNT(o.SalesOrderID) [Total Orders],
    CASE 
        WHEN COUNT(o.SalesOrderID) = 0 THEN 'No Order'
        WHEN COUNT(o.SalesOrderID) = 1 THEN 'One Time'
        WHEN COUNT(o.SalesOrderID) BETWEEN 2 AND 5 THEN 'Regular'
        WHEN COUNT(o.SalesOrderID) BETWEEN 6 AND 10 THEN 'Often'
        WHEN COUNT(o.SalesOrderID) > 10 THEN 'Loyal'
    END AS [Customer Frequency]
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader o 
    ON c.CustomerID = o.CustomerID
JOIN Person.Person p 
    ON p.BusinessEntityID = c.PersonID
WHERE c.CustomerID > 25000
GROUP BY c.TerritoryID, c.CustomerID, FirstName, LastName;

-- Lab 3-2
/* Modify the following query to add a rank without gaps in the
ranking based on total orders in the descending order. Also
partition by territory.*/

SELECT 
    o.TerritoryID, 
    s.Name, 
    YEAR(o.OrderDate) AS Year,
    COUNT(o.SalesOrderID) AS [Total Orders],
    DENSE_RANK() OVER (PARTITION BY o.TerritoryID ORDER BY COUNT(o.SalesOrderID) DESC) AS [Rank]
FROM Sales.SalesTerritory s
JOIN Sales.SalesOrderHeader o 
    ON s.TerritoryID = o.TerritoryID
GROUP BY o.TerritoryID, s.Name, YEAR(o.OrderDate)
ORDER BY o.TerritoryID, YEAR(o.OrderDate);

-- Lab 3-3
/* Write a query to retrieve the most valuable customer of each year.
The most valuable customer of a year is the customer who has
made the most purchase for the year. Use the yearly sum of the
TotalDue column in SalesOrderHeader as a customer's total purchase
for a year. If there is a tie for the most valuable customer,
your solution should retrieve it.
Include the customer's id, total purchase, and total order count
for the year. Display the total purchase as an integer using CAST.
Sort the returned data by the year. */

   
WITH YearlyCustomerPurchase AS (
    SELECT 
        o.CustomerID,
        YEAR(o.OrderDate) AS OrderYear,
        SUM(o.TotalDue) AS TotalPurchase,
        COUNT(o.SalesOrderID) AS TotalOrders,
        RANK() OVER (
            PARTITION BY YEAR(o.OrderDate)
            ORDER BY SUM(o.TotalDue) DESC
        ) AS PurchaseRank
    FROM Sales.SalesOrderHeader AS o
    GROUP BY 
        o.CustomerID, 
        YEAR(o.OrderDate)
)
SELECT 
    CustomerID,
    OrderYear,
    CAST(TotalPurchase AS INT) AS TotalPurchase,
    TotalOrders
FROM YearlyCustomerPurchase
WHERE PurchaseRank = 1
ORDER BY OrderYear;

-- Lab 3-4
/* Provide a unique list of customer id’s which have ordered both
the red and yellow products after May 1, 2008. Sort the list
by customer id. */


SELECT
    soh.CustomerID
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesOrderDetail AS sod
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product AS p
    ON p.ProductID = sod.ProductID
WHERE soh.OrderDate > '2008-05-01'
  AND p.Color IN ('Red', 'Yellow')
GROUP BY soh.CustomerID
HAVING COUNT(DISTINCT p.Color) = 2
ORDER BY soh.CustomerID;


-- Lab 3-5
/*
Use the content of AdventureWorks2008R2, write a query that returns
the Territory which had the smallest difference between the total sold value
of the most sold product color and the total sold value of the least sold
product color. In the same query, also return the territory which had the
largest difference between the total sold value of the most sold product color
and the total sold value of the least sold product color. If there is a tie,
the tie must be returned. Exclude the sold products which didn't have a color
specified for this query.
The most sold product color had the highest total sold value. The least sold
product color had the lowest total sold value. Use UnitPrice * OrderQty to
calculate the total sold value. UnitPrice and OrderQty are in
Sales.SalesOrderDetail.
Include only the orders which had a total due greater than $65000 for
this query. Include the TerritoryID, highest total, lowest total,
and difference in the returned data. Format the numbers as an integer.
Sort the returned data by TerritoryID in asc.
*/



WITH ColorSales AS (
    SELECT 
        o.TerritoryID,
        p.Color,
        CAST(SUM(d.UnitPrice * d.OrderQty) AS INT) AS TotalSoldValue
    FROM Sales.SalesOrderHeader o
    JOIN Sales.SalesOrderDetail d 
        ON o.SalesOrderID = d.SalesOrderID
    JOIN Production.Product p 
        ON d.ProductID = p.ProductID
    WHERE o.TotalDue > 65000
      AND p.Color IS NOT NULL
    GROUP BY o.TerritoryID, p.Color
),
TerritoryColorStats AS (
    SELECT 
        TerritoryID,
        MAX(TotalSoldValue) AS HighestTotal,
        MIN(TotalSoldValue) AS LowestTotal,
        MAX(TotalSoldValue) - MIN(TotalSoldValue) AS Difference
    FROM ColorSales
    GROUP BY TerritoryID
)
SELECT TerritoryID, HighestTotal, LowestTotal, Difference
FROM (
    SELECT 
        tcs.*,
        DENSE_RANK() OVER (ORDER BY Difference)      AS r_min,
        DENSE_RANK() OVER (ORDER BY Difference DESC) AS r_max
    FROM TerritoryColorStats tcs
) x
WHERE r_min = 1 OR r_max = 1
ORDER BY TerritoryID;
