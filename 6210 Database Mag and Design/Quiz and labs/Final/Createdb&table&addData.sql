CREATE DATABASE SupplyChainDB_Group1;
GO

USE SupplyChainDB_Group1;

-- -- Create Tables
-- -------------------------
-- -- Customer
-- -------------------------
CREATE TABLE dbo.Customer (
    customer_id   INT IDENTITY(1,1) PRIMARY KEY,
    name          NVARCHAR(100) NOT NULL,
    email         NVARCHAR(255) NOT NULL
        
);
GO

-- -------------------------
-- -- Address
-- -------------------------
CREATE TABLE dbo.Address (
    address_id    INT IDENTITY(1,1) PRIMARY KEY,
    street_number NVARCHAR(100) NOT NULL,
    city          NVARCHAR(100) NOT NULL,
    state         NVARCHAR(50)  NOT NULL,
    zipcode       NVARCHAR(20)  NOT NULL
);
GO

-- -------------------------
-- -- CustomerAddress 
-- -------------------------
CREATE TABLE dbo.CustomerAddress (
    customer_id INT NOT NULL,
    address_id  INT NOT NULL,
    CONSTRAINT PK_CustomerAddress PRIMARY KEY (customer_id, address_id),
    CONSTRAINT FK_CustomerAddress_Customer FOREIGN KEY (customer_id)
        REFERENCES dbo.Customer(customer_id),
    CONSTRAINT FK_CustomerAddress_Address  FOREIGN KEY (address_id)
        REFERENCES dbo.Address(address_id)
);
GO

-- -------------------------
-- -- Warehouse
-- -------------------------
CREATE TABLE dbo.Warehouse (
    warehouse_id INT IDENTITY(1,1) PRIMARY KEY,
    location     NVARCHAR(200) NOT NULL
);
GO

-- -------------------------
-- -- Product
-- -------------------------
CREATE TABLE dbo.Product (
    product_id   INT IDENTITY(1,1) PRIMARY KEY,
    name         NVARCHAR(100) NOT NULL,
    category     NVARCHAR(100) NULL,
    description  NVARCHAR(500) NULL,
    unit_price   DECIMAL(10,2) NOT NULL,
    unit_cost    DECIMAL(10,2) NOT NULL
);
GO

-- -------------------------
-- -- Inventory (Product-Warehouse)
-- -------------------------
CREATE TABLE dbo.Inventory (
    product_id     INT NOT NULL,
    warehouse_id   INT NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_Inventory PRIMARY KEY (product_id, warehouse_id),
    CONSTRAINT FK_Inventory_Product   FOREIGN KEY (product_id)
        REFERENCES dbo.Product(product_id),
    CONSTRAINT FK_Inventory_Warehouse FOREIGN KEY (warehouse_id)
        REFERENCES dbo.Warehouse(warehouse_id)
);
GO

-- -------------------------
-- -- Order
-- -------------------------
CREATE TABLE dbo.[Order] (
    order_id     INT IDENTITY(1,1) PRIMARY KEY,
    order_date   DATE NOT NULL,
    status       NVARCHAR(50) NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0
);
GO

-- -------------------------
-- -- CustomerOrder (Order – Customer)
-- -------------------------
CREATE TABLE dbo.CustomerOrder (
    order_id    INT NOT NULL,
    customer_id INT NOT NULL,
    CONSTRAINT PK_CustomerOrder PRIMARY KEY (order_id, customer_id),
    CONSTRAINT FK_CustomerOrder_Order    FOREIGN KEY (order_id)
        REFERENCES dbo.[Order](order_id),
    CONSTRAINT FK_CustomerOrder_Customer FOREIGN KEY (customer_id)
        REFERENCES dbo.Customer(customer_id)
);
GO

-- -------------------------
-- -- OrderProduct (Order – Product )
-- -------------------------
CREATE TABLE dbo.OrderProduct (
    order_id   INT NOT NULL,
    product_id INT NOT NULL,
    amount     INT NOT NULL,
    CONSTRAINT PK_OrderProduct PRIMARY KEY (order_id, product_id),
    CONSTRAINT FK_OrderProduct_Order   FOREIGN KEY (order_id)
        REFERENCES dbo.[Order](order_id),
    CONSTRAINT FK_OrderProduct_Product FOREIGN KEY (product_id)
        REFERENCES dbo.Product(product_id)
);
GO

-- -------------------------
-- -- Shipment
-- -------------------------
CREATE TABLE dbo.Shipment (
    shipment_id     INT IDENTITY(1,1) PRIMARY KEY,
    carrier         NVARCHAR(100) NOT NULL,
    tracking_number NVARCHAR(100) NULL,
    status          NVARCHAR(50) NOT NULL,
    shipped_date    DATE NULL,
    delivered_date  DATE NULL
);
GO

-- -------------------------
-- -- OrderShipment (Order – Shipment )
-- -------------------------
CREATE TABLE dbo.OrderShipment (
    shipment_id INT NOT NULL,
    order_id    INT NOT NULL,
    CONSTRAINT PK_OrderShipment PRIMARY KEY (shipment_id, order_id),
    CONSTRAINT FK_OrderShipment_Shipment FOREIGN KEY (shipment_id)
        REFERENCES dbo.Shipment(shipment_id),
    CONSTRAINT FK_OrderShipment_Order    FOREIGN KEY (order_id)
        REFERENCES dbo.[Order](order_id)
);
GO

-- -------------------------
-- -- Invoice
-- -------------------------
CREATE TABLE dbo.Invoice (
    invoice_id   INT IDENTITY(1,1) PRIMARY KEY,
    invoice_date DATE NOT NULL,
    amount       DECIMAL(12,2) NOT NULL
);
GO

-- -------------------------
-- -- Payments
-- -------------------------
CREATE TABLE dbo.Payments (
    payment_id   INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id   INT NULL,
    payment_date DATE NOT NULL,
    amount       DECIMAL(12,2) NOT NULL,
    method       NVARCHAR(50) NOT NULL,
    type         NVARCHAR(50) NOT NULL,
    CONSTRAINT FK_Payments_Invoice FOREIGN KEY (invoice_id)
        REFERENCES dbo.Invoice(invoice_id)
);
GO

-- -------------------------
-- -- OrderPayments (Order – Payments)
-- -------------------------
CREATE TABLE dbo.OrderPayments (
    payment_id INT NOT NULL,
    order_id   INT NOT NULL,
    CONSTRAINT PK_OrderPayments PRIMARY KEY (payment_id, order_id),
    CONSTRAINT FK_OrderPayments_Payments FOREIGN KEY (payment_id)
        REFERENCES dbo.Payments(payment_id),
    CONSTRAINT FK_OrderPayments_Order    FOREIGN KEY (order_id)
        REFERENCES dbo.[Order](order_id)
);
GO

-- -------------------------
-- -- FinancialReport
-- -------------------------
CREATE TABLE dbo.FinancialReport (
    report_id    INT IDENTITY(1,1) PRIMARY KEY,
    payment_id   INT NOT NULL,
    period_start DATE NOT NULL,
    period_end   DATE NOT NULL,
    total_revenue DECIMAL(14,2) NOT NULL,
    total_cost    DECIMAL(14,2) NOT NULL,
    net_profit    AS (total_revenue - total_cost) PERSISTED,
    CONSTRAINT FK_FinancialReport_Payment FOREIGN KEY (payment_id)
        REFERENCES dbo.Payments(payment_id)
);
GO

-- ------------------------------------------------------------
-- -- 1. Customer  (10 rows)
-- ------------------------------------------------------------
INSERT INTO dbo.Customer (name, email) VALUES
(N'Alice Chen',   N'alice@example.com'),
(N'Bob Wang',     N'bob@example.com'),
(N'Charlie Li',   N'charlie@example.com'),
(N'David Zhang',  N'david@example.com'),
(N'Emma Liu',     N'emma@example.com'),
(N'Frank Wu',     N'frank@example.com'),
(N'Grace Sun',    N'grace@example.com'),
(N'Henry Gao',    N'henry@example.com'),
(N'Ivy Lin',      N'ivy@example.com'),
(N'Jack Zhao',    N'jack@example.com');
GO

-- ------------------------------------------------------------
-- -- 2. Address  (10 rows)
-- ------------------------------------------------------------
INSERT INTO dbo.Address (street_number, city, state, zipcode) VALUES
(N'101 First St',   N'San Jose',    N'CA', N'95101'),
(N'202 Second St',  N'San Jose',    N'CA', N'95102'),
(N'303 Third Ave',  N'San Francisco', N'CA', N'94101'),
(N'404 Fourth Rd',  N'Oakland',    N'CA', N'94601'),
(N'505 Fifth Blvd', N'Fremont',    N'CA', N'94536'),
(N'606 Sixth St',   N'Sunnyvale',  N'CA', N'94085'),
(N'707 Seventh St', N'Santa Clara',N'CA', N'95050'),
(N'808 Eighth St',  N'Mountain View',N'CA', N'94040'),
(N'909 Ninth St',   N'Palo Alto',  N'CA', N'94301'),
(N'111 Tenth St',   N'Berkeley',   N'CA', N'94704');
GO

-- ------------------------------------------------------------
-- -- 3. CustomerAddress 
-- ------------------------------------------------------------
INSERT INTO dbo.CustomerAddress (customer_id, address_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10,10),
(1, 2),
(3, 4);
GO

-- ------------------------------------------------------------
-- -- 4. Warehouse  (10 rows)
-- ------------------------------------------------------------
INSERT INTO dbo.Warehouse (location) VALUES
(N'San Jose Central'),
(N'Oakland Depot'),
(N'San Francisco Hub'),
(N'Fremont DC'),
(N'Sacramento Hub'),
(N'Los Angeles North'),
(N'Los Angeles South'),
(N'Seattle Hub'),
(N'Portland Hub'),
(N'Phoenix DC');
GO

-- ------------------------------------------------------------
-- -- 5. Product  (10 rows)
-- ------------------------------------------------------------
INSERT INTO dbo.Product (name, category, description, unit_price, unit_cost) VALUES
(N'Laptop 14"',     N'Electronics', N'14-inch business laptop',           1200.00, 900.00),
(N'Smartphone',     N'Electronics', N'5G smartphone',                      800.00,  550.00),
(N'Wireless Mouse', N'Accessories', N'Bluetooth mouse',                     30.00,   10.00),
(N'Keyboard',       N'Accessories', N'Mechanical keyboard',                 90.00,   40.00),
(N'27" Monitor',    N'Electronics', N'4K display',                         350.00,  250.00),
(N'USB-C Cable',    N'Accessories', N'1m USB-C cable',                      15.00,    5.00),
(N'Docking Station',N'Accessories', N'USB-C docking station',              200.00,  130.00),
(N'External SSD',   N'Storage',     N'1TB portable SSD',                   180.00,  120.00),
(N'Webcam',         N'Accessories', N'1080p webcam',                        60.00,   25.00),
(N'Headset',        N'Accessories', N'Noise-cancelling headset',           150.00,   80.00);
GO

-- ------------------------------------------------------------
-- -- 6. Inventory  
-- ------------------------------------------------------------
INSERT INTO dbo.Inventory (product_id, warehouse_id, stock_quantity) VALUES
(1, 1, 50),
(1, 2, 30),
(2, 1, 80),
(2, 3, 40),
(3, 1, 200),
(3, 4, 150),
(4, 2, 120),
(5, 3, 60),
(6, 4, 300),
(7, 5, 70),
(8, 6, 40),
(9, 7, 90),
(10,8, 55),
(4, 5, 80),
(5, 6, 45),
(6, 7, 110),
(7, 8, 65),
(8, 9, 35),
(9,10, 25),
(10,1, 40);
GO

-- ------------------------------------------------------------
-- -- 7. Order  (10 rows)
-- ------------------------------------------------------------
INSERT INTO dbo.[Order] (order_date, status, total_amount) VALUES
('2025-01-05', N'Pending',   2350.00),
('2025-01-06', N'Shipped',   820.00),
('2025-01-07', N'Completed', 460.00),
('2025-01-08', N'Completed', 1850.00),
('2025-01-09', N'Pending',   1420.00),
('2025-01-10', N'Shipped',   610.00),
('2025-01-11', N'Completed', 970.00),
('2025-01-12', N'Completed', 1520.00),
('2025-01-13', N'Pending',   390.00),
('2025-01-14', N'Shipped',   780.00);
GO

-- ------------------------------------------------------------
-- -- 8. CustomerOrder  
-- ------------------------------------------------------------
INSERT INTO dbo.CustomerOrder (order_id, customer_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10,10);
GO

-- ------------------------------------------------------------
-- -- 9. OrderProduct  
-- --   amount = quantity
-- ------------------------------------------------------------
INSERT INTO dbo.OrderProduct (order_id, product_id, amount) VALUES
(1, 1, 1),   -- 1 laptop
(1, 3, 2),   -- 2 mouse
(1, 5, 1),   -- 1 monitor
(2, 2, 1),
(2, 3, 1),
(3, 3, 3),
(3, 4, 1),
(4, 1, 1),
(4, 7, 2),
(4, 6, 3),
(5, 2, 1),
(5, 5, 1),
(5, 9, 2),
(6, 8, 1),
(6, 6, 2),
(7, 10,1),
(7, 3, 2),
(8, 1, 1),
(8, 8, 1),
(9, 6, 3);
GO

-- ------------------------------------------------------------
-- -- 10. Shipment  (10 rows)
-- ------------------------------------------------------------
INSERT INTO dbo.Shipment (carrier, tracking_number, status, shipped_date, delivered_date) VALUES
(N'UPS',   N'1Z001', N'Shipped',   '2025-01-06', '2025-01-08'),
(N'FedEx', N'FX002', N'Delivered', '2025-01-06', '2025-01-07'),
(N'DHL',   N'DHL003',N'Delivered', '2025-01-07', '2025-01-09'),
(N'UPS',   N'1Z004', N'Delivered', '2025-01-08', '2025-01-10'),
(N'FedEx', N'FX005', N'Shipped',   '2025-01-09', NULL),
(N'UPS',   N'1Z006', N'Shipped',   '2025-01-10', NULL),
(N'DHL',   N'DHL007',N'Delivered', '2025-01-10', '2025-01-12'),
(N'UPS',   N'1Z008', N'Delivered', '2025-01-11', '2025-01-13'),
(N'FedEx', N'FX009', N'Shipped',   '2025-01-12', NULL),
(N'DHL',   N'DHL010',N'Delivered', '2025-01-13', '2025-01-15');
GO

-- ------------------------------------------------------------
-- -- 11. OrderShipment  (10 rows)
-- ------------------------------------------------------------
INSERT INTO dbo.OrderShipment (shipment_id, order_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10,10);
GO

-- ------------------------------------------------------------
-- -- 12. Invoice  (10 rows)
-- ------------------------------------------------------------
INSERT INTO dbo.Invoice (invoice_date, amount) VALUES
('2025-01-05', 2350.00),
('2025-01-06', 820.00),
('2025-01-07', 460.00),
('2025-01-08', 1850.00),
('2025-01-09', 1420.00),
('2025-01-10', 610.00),
('2025-01-11', 970.00),
('2025-01-12', 1520.00),
('2025-01-13', 390.00),
('2025-01-14', 780.00);
GO

-- ------------------------------------------------------------
-- -- 13. Payments  (10 rows)
-- ------------------------------------------------------------
INSERT INTO dbo.Payments (invoice_id, payment_date, amount, method, type) VALUES
(1, '2025-01-06', 2350.00, N'Credit Card', N'Full'),
(2, '2025-01-07', 820.00,  N'Wire',        N'Full'),
(3, '2025-01-08', 460.00,  N'Credit Card', N'Full'),
(4, '2025-01-09', 1850.00, N'ACH',         N'Full'),
(5, '2025-01-10', 700.00,  N'Credit Card', N'Partial'),
(6, '2025-01-11', 610.00,  N'Wire',        N'Full'),
(7, '2025-01-12', 970.00,  N'Credit Card', N'Full'),
(8, '2025-01-13', 1520.00, N'ACH',         N'Full'),
(9, '2025-01-14', 390.00,  N'Credit Card', N'Full'),
(10,'2025-01-15', 780.00,  N'Wire',        N'Full');
GO

-- ------------------------------------------------------------
-- -- 14. OrderPayments  (10 rows)
-- ------------------------------------------------------------
INSERT INTO dbo.OrderPayments (payment_id, order_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10,10);
GO

-- ------------------------------------------------------------
-- -- 15. FinancialReport  (10 rows)
-- ------------------------------------------------------------
INSERT INTO dbo.FinancialReport (payment_id, period_start, period_end, total_revenue, total_cost) VALUES
(1, '2025-01-01', '2025-01-05', 2500.00, 1800.00),
(2, '2025-01-02', '2025-01-06', 900.00,  650.00),
(3, '2025-01-03', '2025-01-07', 500.00,  320.00),
(4, '2025-01-04', '2025-01-08', 1900.00,1400.00),
(5, '2025-01-05', '2025-01-09', 1600.00,1200.00),
(6, '2025-01-06', '2025-01-10', 700.00,  500.00),
(7, '2025-01-07', '2025-01-11', 1000.00,700.00),
(8, '2025-01-08', '2025-01-12', 1600.00,1150.00),
(9, '2025-01-09', '2025-01-13', 450.00,  300.00),
(10,'2025-01-10','2025-01-14', 850.00,  600.00);
GO


