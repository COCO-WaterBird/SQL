Use Adventureworks2008R2;

/*
Write a query to return the top 2 quarters of a product. The top 2 quarters of a product have the 2 highest total quarterly sales of the product. Use UnitPrice*OrderQty to calculate the product total quarterly sales. Please keep in mind, there are 4 quarters in a year and there is several years' data in the database.

Also return the percentage of the highest product sales in an order containing the product for a quarter as a percentage of the total quarterly sales amount of the product in the same quarter.

Return only the quarters of a product which don't have more than 5 orders which contain the product and each order has an order value less than 45000 in the same quarter. Use TotalDue as the order value.

Keep in mind, for a product quarter to be returned, it must first meet the ranking requirement, then the order count requirement.

Return the data in the format displayed below. The percentage is the highest product sales in an order containing the product for a quarter as the percentage of the total quarterly sales amount of the same product in the same quarter. The name is the product name.

Sort the returned data by productid.

ProductID   Name        Top2Quarters
XXX         XXXXXXXXXX  Year Quarter XX.XX% , Year Quarter XX.XX%
*/


USE AdventureWorks2008R2;

WITH ProductOrderSales AS (
    -- 每个订单中某产品的销售额（用于求订单内该产品最高销售额）
    SELECT 
        p.ProductID,
        p.Name,
        soh.SalesOrderID,
        YEAR(soh.OrderDate) AS [Year],
        DATEPART(QUARTER, soh.OrderDate) AS [Quarter],
        SUM(sod.UnitPrice * sod.OrderQty) AS OrderProductSales,
        soh.TotalDue
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    GROUP BY 
        p.ProductID, p.Name, soh.SalesOrderID,
        YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate),
        soh.TotalDue
),
ProductQuarterly AS (
    -- 每个产品每季度汇总：季度总销售额、<45000 订单数、该季度单笔订单内该产品的最大销售额
    SELECT
        pos.ProductID,
        pos.Name,
        pos.[Year],
        pos.[Quarter],
        SUM(pos.OrderProductSales) AS TotalQuarterlySales,
        COUNT(DISTINCT CASE WHEN pos.TotalDue < 45000 THEN pos.SalesOrderID END) AS LowValueOrderCount,
        MAX(pos.OrderProductSales) AS MaxOrderProductSales
    FROM ProductOrderSales pos
    GROUP BY pos.ProductID, pos.Name, pos.[Year], pos.[Quarter]
),
RankedProductSales AS (
    -- 先对每个产品按季度总销售额排名，取 Top2 使用
    SELECT
        pq.*,
        ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY TotalQuarterlySales DESC) AS SalesRank
    FROM ProductQuarterly pq
),
Filtered AS (
    -- 再对 Top2 季度应用“订单数≤5（TotalDue<45000）”的条件
    SELECT *
    FROM RankedProductSales
    WHERE SalesRank <= 2
      AND LowValueOrderCount <= 5
)
SELECT
    f.ProductID,
    f.Name,
    STUFF(
        (
            SELECT
                ', ' 
                + CAST(f2.[Year] AS varchar(4)) 
                + ' Quarter ' + CAST(f2.[Quarter] AS varchar(1))
                + ' ' 
                + CONVERT(
                      varchar(20),
                      CAST((f2.MaxOrderProductSales * 1.0 / f2.TotalQuarterlySales * 100.0) AS DECIMAL(10,2))
                  )
                + '%'
            FROM Filtered f2
            WHERE f2.ProductID = f.ProductID
            ORDER BY f2.TotalQuarterlySales DESC
            FOR XML PATH(''), TYPE
        ).value('.', 'nvarchar(max)')
    ,1,2,'') AS Top2Quarters
FROM Filtered f
GROUP BY f.ProductID, f.Name
ORDER BY f.ProductID;






-- Question 5

CREATE DATABASE KeZhang2_lab;
GO
USE KeZhang2_lab;

create table Advisor
(advisorid int primary key,
 adviorlastname varchar(50) not null,
 advisorfirstname varchar(50) not null);

create table venue
(venueid int primary key,
 capacity int not null);

create table seminar
(seminarid int primary key, 
 seminardate date not null,
 numberofadvisor tinyint not null,
 venueid int not null references venue(venueid), 
 status varchar(10) not null, -- For simplicity, either Active or Complete
 description varchar(100));

create table advisorseminar
(advisorid int references advisor(advisorid),
 seminarid int references seminar(seminarid)
 primary key (advisorid, seminarid));

create table client
(clientid int primary key,
 clientlastname varchar(50) not null,
 clientfirstname varchar(50) not null); 

create table enrollment
(seminarid int not null references seminar(seminarid),
 clientid int not null references client(clientid),
 registrationdate date not null,
 status varchar(10) not null -- For simplicity, either active or complete
 primary key (seminarid, clientid));

create table audittrail
(audittrailid int identity primary key,
 seminarid int not null,
 timing datetime default getdate());

/*
Wang Institute is a non-profit training organization. Its goal is to help displaced workers make a career change.

Given the above tables, please write a single table-level CHECK constraint based on a single SQL function to implement the following business rules:

An advisor cannot be assigned to more than 12 seminars in a month.

An advisor cannot be assigned to more than 100 seminars in a calendar year.
*/

CREATE FUNCTION dbo.fn_CheckAdvisorSeminarLimits(@advisorid INT, @seminarid INT)
RETURNS BIT
AS
BEGIN
    DECLARE @sdate DATE;
    SELECT @sdate = seminardate FROM seminar WHERE seminarid = @seminarid;
    IF @sdate IS NULL RETURN 0;

    DECLARE @yr INT = YEAR(@sdate);
    DECLARE @mo INT = MONTH(@sdate);

    DECLARE @yearCount INT, @monthCount INT;

    SELECT @yearCount = COUNT(*)
    FROM advisorseminar a
    JOIN seminar s ON a.seminarid = s.seminarid
    WHERE a.advisorid = @advisorid
      AND YEAR(s.seminardate) = @yr;

    SELECT @monthCount = COUNT(*)
    FROM advisorseminar a
    JOIN seminar s ON a.seminarid = s.seminarid
    WHERE a.advisorid = @advisorid
      AND YEAR(s.seminardate) = @yr
      AND MONTH(s.seminardate) = @mo;

    -- include the current assignment being validated
    SET @yearCount = ISNULL(@yearCount,0) + 1;
    SET @monthCount = ISNULL(@monthCount,0) + 1;

    RETURN CASE WHEN @yearCount <= 100 AND @monthCount <= 12 THEN 1 ELSE 0 END;
END;
GO

ALTER TABLE advisorseminar
ADD CONSTRAINT chk_advisorseminar CHECK (dbo.fn_CheckAdvisorSeminarLimits(advisorid, seminarid) = 1);
GO


/*
-- Test the constraint1 
INSERT INTO Advisor(advisorid, adviorlastname, advisorfirstname)
VALUES (1, 'Wang', 'Tom');

INSERT INTO venue(venueid, capacity)
VALUES (1, 100);
--input
INSERT INTO seminar(seminarid, seminardate, numberofadvisor, venueid, status, description)
VALUES(1, '2024-01-05', 1, 1, 'Active', 'Test seminar 1');

SELECT dbo.fn_CheckAdvisorSeminarLimits(1, 1) AS Result;

-- Test the constraint2

BEGIN TRAN;

DECLARE @i INT = 1;

WHILE @i <= 12
BEGIN
    INSERT INTO seminar(seminarid, seminardate, numberofadvisor, venueid, status, description)
    VALUES (1000 + @i, '2024-01-01', 1, 1, 'Active', 'Test');

    INSERT INTO advisorseminar(advisorid, seminarid)
    VALUES (1, 1000 + @i);

    SET @i += 1;
END;
--13th seminar should fail

INSERT INTO seminar(seminarid, seminardate, numberofadvisor, venueid, status, description)
VALUES (1013, '2024-01-01', 1, 1, 'Active', 'Test 13');

INSERT INTO advisorseminar(advisorid, seminarid)
VALUES (1, 1013);

ROLLBACK; 

*/