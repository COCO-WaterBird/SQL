/* =========================
   0. Use database
   ========================= */
USE SupplyChainDB_Group1;
GO

/* =========================================================
   1. Function-based CHECK constraint on Inventory.stock_quantity
   ========================================================= */

-- Drop function if it already exists (to avoid errors when re-running the script)
IF OBJECT_ID('dbo.fn_CheckInventoryStock', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_CheckInventoryStock;
GO

-- Function: validate inventory stock quantity range
-- Returns 1 (TRUE) if quantity is between 0 and 10,000; otherwise returns 0 (FALSE)
CREATE FUNCTION dbo.fn_CheckInventoryStock
(
    @Quantity INT
)
RETURNS BIT
AS
BEGIN
    IF @Quantity < 0 OR @Quantity > 10000
        RETURN 0;           -- invalid quantity

    RETURN 1;               -- valid quantity
END;
GO

-- Drop existing CHECK constraint if it exists
IF EXISTS (
    SELECT 1 
    FROM sys.check_constraints 
    WHERE name = 'CK_Inventory_StockRange'
)
BEGIN
    ALTER TABLE dbo.Inventory
    DROP CONSTRAINT CK_Inventory_StockRange;
END;
GO

-- Table-level CHECK constraint that calls the function
ALTER TABLE dbo.Inventory
ADD CONSTRAINT CK_Inventory_StockRange
CHECK (dbo.fn_CheckInventoryStock(stock_quantity) = 1);
GO


/* =========================================================
   2. Column-level data encryption for Customer.email
   ========================================================= */

-- Create database master key if it does not exist
IF NOT EXISTS (
    SELECT * 
    FROM sys.symmetric_keys 
    WHERE name = '##MS_DatabaseMasterKey##'
)
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Str0ng_MasterKey_Pass!';
END;
GO

-- Create a certificate for encryption if it does not exist
IF NOT EXISTS (
    SELECT * 
    FROM sys.certificates 
    WHERE name = 'Cert_SupplyChain'
)
BEGIN
    CREATE CERTIFICATE Cert_SupplyChain
    WITH SUBJECT = 'Supply Chain Data Encryption';
END;
GO

-- Create a symmetric key (AES-256) for customer email encryption
IF NOT EXISTS (
    SELECT * 
    FROM sys.symmetric_keys 
    WHERE name = 'SK_CustomerEmail'
)
BEGIN
    CREATE SYMMETRIC KEY SK_CustomerEmail
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE Cert_SupplyChain;
END;
GO

-- Add an encrypted column for email if it does not already exist
IF COL_LENGTH('dbo.Customer', 'email_encrypted') IS NULL
BEGIN
    ALTER TABLE dbo.Customer
    ADD email_encrypted VARBINARY(256) NULL;
END;
GO

-- Encrypt existing email values into the new encrypted column
OPEN SYMMETRIC KEY SK_CustomerEmail
DECRYPTION BY CERTIFICATE Cert_SupplyChain;
GO

UPDATE dbo.Customer
SET email_encrypted = EncryptByKey(
        Key_GUID('SK_CustomerEmail'),
        CAST(email AS NVARCHAR(256))
    );
GO

CLOSE SYMMETRIC KEY SK_CustomerEmail;
GO


/* =========================================================
   3. Example query to decrypt email when needed
   ========================================================= */

-- Open symmetric key for decryption
OPEN SYMMETRIC KEY SK_CustomerEmail
DECRYPTION BY CERTIFICATE Cert_SupplyChain;
GO

-- Example: select customers with decrypted email
SELECT 
    customer_id,
    name,
    email_encrypted,
    CONVERT(NVARCHAR(256), DecryptByKey(email_encrypted)) AS email_decrypted
FROM dbo.Customer;
GO

-- Close symmetric key after use
CLOSE SYMMETRIC KEY SK_CustomerEmail;
GO


/* =========================================================
   4. Views for reporting
   ========================================================= */

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
    c.name AS customer_name
FROM dbo.[Order] AS o
JOIN dbo.CustomerOrder AS co
    ON o.order_id = co.order_id
JOIN dbo.Customer AS c
    ON co.customer_id = c.customer_id;
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
FROM dbo.Inventory AS i
JOIN dbo.Product   AS p ON i.product_id   = p.product_id
JOIN dbo.Warehouse AS w ON i.warehouse_id = w.warehouse_id;
GO
