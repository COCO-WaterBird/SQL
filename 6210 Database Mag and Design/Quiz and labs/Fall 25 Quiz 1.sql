/*
Question 5
Use AdventureWorks2008R2 for this question.
Write a query to retrieve the product colors which have been sold in all months of all years as reflected by the data stored in the database.
To be more specific, if there was any sale in a month, the product color was sold in that month. The number of months must be calculated and cannot be hard coded.

Include the color, unique customers the color has been sold to, and number of months a color has been sold in for the returned data.

Return only the colors which have been sold to more than 4000 unique customers altogether and exclude the products which didn't have a color specified in this query.

Sort the returned data by the product color.
*/
Use AdventureWorks2008R2


WITH MonthlySales AS (
    SELECT
        p.Color,
        DATEDIFF(MONTH, 0, soh.OrderDate) AS MonthIdx,
        soh.CustomerID
    FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod
      ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product AS p
      ON sod.ProductID = p.ProductID
    WHERE p.Color IS NOT NULL
),
ColorSales AS (
    SELECT
        Color,
        COUNT(DISTINCT CustomerID)           AS UniqueCustomers,
        COUNT(DISTINCT MonthIdx)             AS MonthsSold
    FROM MonthlySales
    GROUP BY Color
),
TotalMonths AS (
    SELECT COUNT(DISTINCT DATEDIFF(MONTH, 0, OrderDate)) AS TotalMonths
    FROM Sales.SalesOrderHeader
)
SELECT
    cs.Color,
    cs.UniqueCustomers,
    cs.MonthsSold
FROM ColorSales AS cs
CROSS JOIN TotalMonths AS tm
WHERE cs.MonthsSold = tm.TotalMonths  
  AND cs.UniqueCustomers > 4000       
ORDER BY cs.Color;


/*
Write a query to retrieve the products which are within top 10 for both the total sales dollar amount and the number of the states/provinces it has been sold to. Use UnitPrice and OrderQty for calculating a product's total sales dollar amount. Use ShipToAddressID in SalesOrderHeader to determine what state/province a product was sold to. The state/province is a part of an address.

Include only products which have never been contained in a small order. A small order has the TotalDue value < 1000. Include ProductID, number of unique states/provinces a product was sold to, total sales dollar amount of a product, and product name in the returned data. Format the total sales amount as an integer. Sort the returned data by ProductID. */

WITH ProductSales AS (
    SELECT
        p.ProductID,
        p.Name,
        SUM(sod.UnitPrice * sod.OrderQty) AS TotalSales,
        COUNT(DISTINCT a.StateProvinceID) AS UniqueStates
    FROM Production.Product      AS p
    JOIN Sales.SalesOrderDetail  AS sod ON p.ProductID      = sod.ProductID
    JOIN Sales.SalesOrderHeader  AS soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Person.Address          AS a   ON soh.ShipToAddressID = a.AddressID
    WHERE NOT EXISTS (  
        SELECT 1
        FROM Sales.SalesOrderDetail sod2
        JOIN Sales.SalesOrderHeader soh2
          ON soh2.SalesOrderID = sod2.SalesOrderID
        WHERE sod2.ProductID = p.ProductID
          AND soh2.TotalDue  < 1000
    )
    GROUP BY p.ProductID, p.Name
),
Ranked AS (  
    SELECT
        ps.*,
        ROW_NUMBER() OVER (ORDER BY ps.TotalSales   DESC, ps.ProductID) AS rn_sales,
        ROW_NUMBER() OVER (ORDER BY ps.UniqueStates DESC, ps.ProductID) AS rn_states
    FROM ProductSales ps
)
SELECT
    r.ProductID,
    r.Name,
    r.UniqueStates,
    CAST(r.TotalSales AS INT) AS TotalSales
FROM Ranked r
WHERE r.rn_sales  <= 10
  AND r.rn_states <= 10
ORDER BY r.ProductID;



/*
USE AdventureWorks2008R2. Write a query to find the products that have never been ordered. Return the ProductID and Name from the Production.Product table.*/

SELECT 
    P.ProductID,
    P.Name
FROM 
    Production.Product AS P
LEFT JOIN 
    Sales.SalesOrderDetail AS SOD ON P.ProductID = SOD.ProductID
WHERE 
    SOD.ProductID IS NULL;  



