USE SupplyChainDB_Group1;
GO

-- View 1: Order summary with customer information
IF OBJECT_ID('dbo.vOrderSummary', 'V') IS NOT NULL
    DROP VIEW dbo.vOrderSummary;
GO

CREATE VIEW dbo.vOrderSummary
AS
SELECT
    o.order_id,
    o.order_date,
    o.status,
    o.total_amount,
    c.customer_id,
    c.name  AS customer_name
FROM dbo.[Order]        AS o
JOIN dbo.CustomerOrder  AS co ON o.order_id     = co.order_id
JOIN dbo.Customer       AS c  ON co.customer_id = c.customer_id;
GO

-- View 2: Inventory status by product and warehouse
IF OBJECT_ID('dbo.vInventoryStatus', 'V') IS NOT NULL
    DROP VIEW dbo.vInventoryStatus;
GO

CREATE VIEW dbo.vInventoryStatus
AS
SELECT
    i.product_id,
    p.name        AS product_name,
    i.warehouse_id,
    w.location    AS warehouse_location,
    i.stock_quantity
FROM dbo.Inventory  AS i
JOIN dbo.Product    AS p ON i.product_id   = p.product_id
JOIN dbo.Warehouse  AS w ON i.warehouse_id = w.warehouse_id;
GO


-- View 3: Product-level sales summary (quantity and revenue)
IF OBJECT_ID('dbo.vProductSalesSummary', 'V') IS NOT NULL
    DROP VIEW dbo.vProductSalesSummary;
GO

CREATE VIEW dbo.vProductSalesSummary
AS
SELECT
    p.product_id,
    p.name          AS product_name,
    SUM(op.amount)  AS total_quantity_sold,
    SUM(op.amount * p.unit_price) AS total_revenue,
    COUNT(DISTINCT op.order_id)   AS order_count
FROM dbo.OrderProduct AS op
JOIN dbo.Product      AS p ON op.product_id = p.product_id
GROUP BY
    p.product_id,
    p.name;
GO

