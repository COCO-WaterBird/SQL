-- Lab 4 Questions
/* Part A (2 points)
Create 4 tables and the corresponding relationships to implement the ERD below in your own database.
*/
create DATABASE chapter06;
use chapter06;

-- 1) Person
CREATE TABLE Person (
    PersonID INT PRIMARY KEY,
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    DateOfBirth DATE
);

-- 2) Organization
CREATE TABLE Organization (
    OrganizationID INT PRIMARY KEY,
    Name VARCHAR(100),
    MainPhone VARCHAR(20)
);

-- 3) Specialty
CREATE TABLE Specialty (
    SpecialtyID INT PRIMARY KEY,
    Name VARCHAR(100),
    Description VARCHAR(255)
);

-- 4) Volunteering  (Bridge table for relationships)
CREATE TABLE Volunteering (
    VolunteeringID INT PRIMARY KEY,
    PersonID INT,
    OrganizationID INT,
    SpecialtyID INT,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (OrganizationID) REFERENCES Organization(OrganizationID),
    FOREIGN KEY (SpecialtyID) REFERENCES Specialty(SpecialtyID)
);

/* Part B – 1 (2 points)
 Write a query to retrieve the top 3 customers, based on the total purchase,
   for each year. The top 3 customers have the 3 highest total purchase amounts.
   Use TotalDue of SalesOrderHeader to calculate the total purchase.
   Also calculate the top 3 customers' total purchase amount for the year.
   Return the data in the following format.

Year    Total Sale     Top3Customers
2005    748178         29624, 29861, 29562
2006    1112218        29614, 29716, 29722
2007    1230198        29913, 29818, 29701
2008    697280         29923, 29641, 29617
*/
Use AdventureWorks2008R2;


WITH YearlySales AS (
    SELECT 
        YEAR(OrderDate) AS SaleYear,
        CustomerID,
        SUM(TotalDue) AS TotalPurchase,
        ROW_NUMBER() OVER (PARTITION BY YEAR(OrderDate) ORDER BY SUM(TotalDue) DESC) AS SalesRank
    FROM 
        Sales.SalesOrderHeader
    GROUP BY 
        YEAR(OrderDate), CustomerID
), TopCustomers AS (
    SELECT 
        SaleYear,
        CustomerID,
        TotalPurchase
    FROM 
        YearlySales
    WHERE 
        SalesRank <= 3
)
SELECT 
    SaleYear AS Year,
    CAST(CEILING(SUM(TotalPurchase)) AS INT) AS 'Total Sale',
    STRING_AGG(CAST(CustomerID AS VARCHAR), ', ') AS Top3Customers
FROM 
    TopCustomers
GROUP BY 
    SaleYear
ORDER BY 
    SaleYear;





/* Part B – 2 (2 points)*/

/*
Using AdventureWorks2008R2, write a query to retrieve
the salespersons and their order info.
Return a salesperson's id, a salesperson's total order count,
the lowest total product quantity contained in an order
for all orders of a salesperson, and the order values of a
salesperson's bottom 3 orders. The returned data should have
the format displayed below. Include only the orders which
have a salesperson specified for this question.
For the lowest total product quantity contained in an order
for all orders of a salesperson, an example is:
John has 3 orders.
Order #1 has a total sold quantity of 5
Order #2 has a total sold quantity of 25
Order #3 has a total sold quantity of 21
Then the lowest total product quantity contained in an order
for all orders of John is 5.
The bottom 3 orders have the 3 lowest order values.
Use TotalDue in SalesOrderHeader as the order value.
If there is a tie, the tie must be retrieved.
Include only the salespersons who owned the top 3 orders for all
orders which have a salesperson specified. The top 3 orders have
the 3 highest numbers of total sold quantity contained in an order.
Sort the returned data by SalespersonID.
*/
/*
SalesPersonID TotalOrderCount LowestQuantity Lowest3Values
XXX XXX XXX XX.XX, XX.XX, XX.XX
*/

USE AdventureWorks2008R2;

WITH PerOrder AS (
    SELECT 
        soh.SalesPersonID,
        soh.SalesOrderID,
        SUM(sod.OrderQty) AS TotalQty,
        soh.TotalDue
    FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod 
      ON soh.SalesOrderID = sod.SalesOrderID
    WHERE soh.SalesPersonID IS NOT NULL
    GROUP BY soh.SalesPersonID, soh.SalesOrderID, soh.TotalDue
),

Top3Owners AS (
    SELECT DISTINCT SalesPersonID
    FROM (
        SELECT 
            SalesPersonID,
            DENSE_RANK() OVER (ORDER BY TotalQty DESC) AS rk
        FROM PerOrder
    ) t
    WHERE rk <= 3
),

Base AS (
    SELECT p.*
    FROM PerOrder p
    JOIN Top3Owners o ON p.SalesPersonID = o.SalesPersonID
),
Agg AS (
    SELECT 
        SalesPersonID,
        COUNT(*) AS TotalOrderCount,
        MIN(TotalQty) AS LowestQuantity
    FROM Base
    GROUP BY SalesPersonID
),

Bottom3 AS (
    SELECT 
        SalesPersonID,
        TotalDue,
        DENSE_RANK() OVER (PARTITION BY SalesPersonID ORDER BY TotalDue ASC) AS rk
    FROM Base
)
SELECT 
    a.SalesPersonID,
    a.TotalOrderCount,
    a.LowestQuantity,
    
    STUFF((
        SELECT ', ' + CONVERT(VARCHAR(50), CAST(b2.TotalDue AS DECIMAL(18,2)))
        FROM Bottom3 b2
        WHERE b2.SalesPersonID = a.SalesPersonID
          AND b2.rk <= 3
        ORDER BY b2.TotalDue ASC
        FOR XML PATH(''), TYPE
    ).value('.','NVARCHAR(MAX)'), 1, 2, '') AS Lowest3Values
FROM Agg a
ORDER BY a.SalesPersonID;



-- Part C (2 points)
/* Bill of Materials - Recursive */
/* The following code retrieves the components required for manufacturing "Mountain-500
Black, 48" (Product 992). Modify the code to retrieve the most expensive component(s) at
each component level. Use the list price of a component to determine the most expensive
component for each level. Exclude the components which have a list price of 0. Sort the
returned data by the component level. */

WITH Parts AS (
    SELECT
        b.ProductAssemblyID,
        b.ComponentID,
        b.PerAssemblyQty,
        b.EndDate,
        p.Name,
        p.ListPrice,
        0 AS ComponentLevel
    FROM
        Production.BillOfMaterials AS b
    INNER JOIN 
        Production.Product AS p
        ON b.ComponentID = p.ProductID 
    WHERE 
        b.ProductAssemblyID = 992 
        AND b.EndDate IS NULL
        AND p.ListPrice > 0
    
    UNION ALL
    
    SELECT
        bom.ProductAssemblyID,
        bom.ComponentID,
        bom.PerAssemblyQty,
        bom.EndDate,
        prod.Name, 
        prod.ListPrice, 
        p.ComponentLevel + 1
    FROM
        Production.BillOfMaterials AS bom
    INNER JOIN 
        Parts AS p
        ON bom.ProductAssemblyID = p.ComponentID 
    INNER JOIN 
        Production.Product AS prod
        ON bom.ComponentID = prod.ProductID
    WHERE 
        bom.EndDate IS NULL
        AND prod.ListPrice > 0
),
RankedParts AS (
    SELECT 
        ProductAssemblyID,
        ComponentID,
        Name,
        ListPrice,
        PerAssemblyQty,
        ComponentLevel,
        DENSE_RANK() OVER (PARTITION BY ComponentLevel ORDER BY ListPrice DESC) AS PriceRank
    FROM 
        Parts
)
SELECT 
    ProductAssemblyID AS AssemblyID, 
    ComponentID, 
    Name, 
    PerAssemblyQty, 
    ComponentLevel,
    ListPrice
FROM 
    RankedParts
WHERE 
    PriceRank = 1
ORDER BY 
    ComponentLevel;