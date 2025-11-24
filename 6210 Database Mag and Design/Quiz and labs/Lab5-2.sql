-- Lab 5 Questions
-- Note: 1.5 points for each question.
-- Lab 5-1
/* Using the SQL PIVOT command, rewrite the following query to present the same data
in a horizontal format, as listed below. Please use AdventureWorks2008R2 for this
question. */
use AdventureWorks2008R2;

select datepart(yy, OrderDate) Year,
SalesPersonID,
FirstName,
LastName,
cast(sum(TotalDue) as int) as TotalSales
from Sales.SalesOrderHeader sh
join Person.Person p
on sh.SalesPersonID = p.BusinessEntityID
where year(OrderDate) in (2006, 2007) and SalesPersonID between 275 and 278
group by SalesPersonID, datepart(yy, OrderDate), FirstName, LastName
having sum(TotalDue) > 1500000;

-- After rewriting the query using PIVOT, the output should look like this:


USE AdventureWorks2008R2;

SELECT 
    Year,
    CASE WHEN [275] IS NULL THEN '' ELSE CAST([275] AS varchar(14)) END AS '275 Michael Blythe',
    CASE WHEN [276] IS NULL THEN '' ELSE CAST([276] AS varchar(14)) END AS '276 Linda Mitchell',
    CASE WHEN [277] IS NULL THEN '' ELSE CAST([277] AS varchar(14)) END AS '277 Jillian Carson',
    CASE WHEN [278] is null then'' ELSE CAST([278] as varchar(14)) END AS'278 Garrett Vargas'
FROM
(
    SELECT 
        datepart(yy, OrderDate) AS Year,
        SalesPersonID,
        cast(sum(TotalDue) as int) AS TotalSales
    FROM Sales.SalesOrderHeader sh
    JOIN Person.Person p ON sh.SalesPersonID = p.BusinessEntityID
    WHERE year(OrderDate) IN (2006, 2007)
    AND SalesPersonID BETWEEN 275 AND 278
    GROUP BY SalesPersonID, datepart(yy, OrderDate)
    HAVING sum(TotalDue) > 1500000
) AS SourceTable
PIVOT
(
    SUM(TotalSales)
    FOR SalesPersonID IN ([275], [276], [277], [278])
) AS PivotTable;




-- Lab 5-2
/* Using data from AdventureWorks2008R2, create a function that accepts
a customer id and returns the full name (last name + first name)
of the customer. */


CREATE DATABASE KeZhang_lab;
GO
USE KeZhang_lab;
GO


CREATE FUNCTION dbo.fn_GetCustomerFullName (@CustomerID INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @FullName NVARCHAR(200);

    SELECT @FullName = p.LastName + ' ' + p.FirstName
    FROM AdventureWorks2008R2.Sales.Customer AS c
    JOIN AdventureWorks2008R2.Person.Person  AS p
        ON c.PersonID = p.BusinessEntityID
    WHERE c.CustomerID = @CustomerID;

    RETURN @FullName;
END;
GO

SELECT dbo.fn_GetCustomerFullName(11000) AS FullName;




-- Lab 5-3
/* Given the following tables, there is a university rule
preventing a student from enrolling in a new class if there is
an unpaid fine. Please write a table-level CHECK constraint
to implement the rule. */
create table Course
(CourseID int primary key,
CourseName varchar(50),
InstructorID int,
AcademicYear int,
Semester smallint);
create table Student
(StudentID int primary key,
LastName varchar (50),
FirstName varchar (50),
Email varchar(30),
PhoneNumber varchar (20));
create table Enrollment
(CourseID int references Course(CourseID),
StudentID int references Student(StudentID),
RegisterDate date,
primary key (CourseID, StudentID));
create table Fine
(StudentID int references Student(StudentID),
IssueDate date,
Amount money,
PaidDate date
primary key (StudentID, IssueDate));
GO







CREATE FUNCTION dbo.fn_NoUnpaidFine(@StudentID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @ok BIT = 1;

    IF EXISTS (
        SELECT 1
        FROM Fine f
        WHERE f.StudentID = @StudentID
          AND f.PaidDate IS NULL
          AND f.Amount > 0
    )
        SET @ok = 0;

    RETURN @ok;
END;
GO


ALTER TABLE Enrollment
ADD CONSTRAINT CK_Enrollment_NoUnpaidFine 
CHECK (dbo.fn_NoUnpaidFine(StudentID) = 1);
GO


-- Check: INFORMATION_SCHEMA
SELECT 
    CONSTRAINT_NAME,
    CHECK_CLAUSE
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS
WHERE CONSTRAINT_NAME = 'CK_Enrollment_NoUnpaidFine';


-- Lab 5-4
/* Given the following tables, there is a $4 shipping fee
for each ordered product.
For example, if an order contains:
Product 1, quantity 2
Product 2, quantity 2
then the order quantity is 4 and the shipping fee is $16.
If the order value is greater than 600, then the shipping fee is $2
for each ordered product. The discounted shipping fee
will be $8,
Use UnitPrice * Quantity of all products contained in an order to calculate
the order value. ShippingFee and Tax are not included in the order value.
Write a trigger to calculate the shipping fee for an order. Save
the shipping fee in the ShippingFee column of the SalesOrder table. */
create table Customer
(CustomerID int primary key,
LastName varchar(50),
FirstName varchar(50),
Membership varchar(10));
create table SalesOrder
(OrderID int primary key,
CustomerID int references Customer(CustomerID),
OrderDate date,
ShippingFee money,
Tax as OrderValue * 0.08,
OrderValue money);
create table OrderDetail
(OrderID int references SalesOrder(OrderID),
ProductID int,
Quantity int,
UnitPrice money
primary key(OrderID, ProductID));
GO





CREATE TRIGGER trg_UpdateShippingFee
ON OrderDetail
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH ChangedOrders AS (
        SELECT DISTINCT OrderID FROM inserted
        UNION
        SELECT DISTINCT OrderID FROM deleted
    )
    UPDATE so
    SET 
        so.OrderValue  = ISNULL(v.OrderValue, 0),
        so.ShippingFee = ISNULL(
                            CASE 
                                WHEN v.OrderValue > 600 
                                     THEN v.TotalQty * 2
                                ELSE v.TotalQty * 4
                            END,
                            0
                         )
    FROM SalesOrder AS so
    JOIN ChangedOrders AS co
        ON so.OrderID = co.OrderID
    OUTER APPLY (
        SELECT 
            SUM(od.UnitPrice * od.Quantity) AS OrderValue,
            SUM(od.Quantity)                AS TotalQty
        FROM OrderDetail AS od
        WHERE od.OrderID = co.OrderID
    ) AS v;
END;
GO

-- /*


-- 1.BUild a Customer
INSERT INTO Customer (CustomerID, LastName, FirstName, Membership)
VALUES (1, 'Zhang', 'Ke', 'Gold');

-- 2. Build two SalesOrders for the customer
INSERT INTO SalesOrder (OrderID, CustomerID, OrderDate, ShippingFee, OrderValue)
VALUES
(1001, 1, '2025-11-16', 0, 0),   -- Amount <= 600
(1002, 1, '2025-11-16', 0, 0);   -- Amount > 600

-- Order 1001 add details
INSERT INTO OrderDetail (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1001, 1, 2, 100.00),
(1001, 2, 2,  50.00);

select * from orderdetail where OrderID in (1001);
select * from SalesOrder where OrderID in (1001);

-- Test the trigger
SELECT OrderID, OrderValue, ShippingFee, Tax
FROM SalesOrder
WHERE OrderID = 1001;

INSERT INTO OrderDetail (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1002, 3, 3, 150.00),
(1002, 4, 2, 100.00);

SELECT OrderID, OrderValue, ShippingFee, Tax
FROM SalesOrder
WHERE OrderID = 1002;

UPDATE OrderDetail
SET UnitPrice = 10
WHERE OrderID = 1001 AND ProductID = 1;

SELECT OrderID, OrderValue, ShippingFee, Tax
FROM SalesOrder
WHERE OrderID = 1001;