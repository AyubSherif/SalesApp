-- USER
IF OBJECT_ID(N'dbo.users', N'U') IS NULL
CREATE TABLE dbo.users (
    user_id INT IDENTITY PRIMARY KEY,
    full_name NVARCHAR(50),
    role NVARCHAR(20),
    username NVARCHAR(30),
    password NVARCHAR(100),
    create_date DATE DEFAULT CAST(GETDATE() AS DATE),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- CHANGE LOG
IF OBJECT_ID(N'dbo.change_log', N'U') IS NULL
CREATE TABLE dbo.change_log (
    log_id INT IDENTITY PRIMARY KEY,
    table_name NVARCHAR(50),
    record_id INT,
    operation NVARCHAR(10),
    old_data NVARCHAR(MAX),
    new_data NVARCHAR(MAX),
    change_user_id INT,
    change_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- CUSTOMER
IF OBJECT_ID(N'dbo.customer', N'U') IS NULL
CREATE TABLE dbo.customer (
    customer_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(50),
    phone NVARCHAR(14),
    address NVARCHAR(100),
    notes NVARCHAR(200),
    create_date DATE DEFAULT CAST(GETDATE() AS DATE),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- PRODUCT
IF OBJECT_ID(N'dbo.product', N'U') IS NULL
CREATE TABLE dbo.product (
    product_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100),
    brand NVARCHAR(50),
    size NVARCHAR(5),
    color NVARCHAR(15),
    category NVARCHAR(20),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- VENDOR
IF OBJECT_ID(N'dbo.vendor', N'U') IS NULL
CREATE TABLE dbo.vendor (
    vendor_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(50),
    website NVARCHAR(100),
    contact NVARCHAR(100),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- SHIP VIA
IF OBJECT_ID(N'dbo.ship_via', N'U') IS NULL
CREATE TABLE dbo.ship_via (
    ship_via_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(50),
    notes NVARCHAR(200),
    create_date DATE DEFAULT CAST(GETDATE() AS DATE),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- SALES ORDER
IF OBJECT_ID(N'dbo.sales_order', N'U') IS NULL
CREATE TABLE dbo.sales_order (
    sales_order_id INT IDENTITY PRIMARY KEY,
    customer_id INT,
    sales_type CHAR(1),
    order_date DATE DEFAULT CAST(GETDATE() AS DATE),
    due_date DATE,
    status CHAR(1),
    status_date DATE DEFAULT CAST(GETDATE() AS DATE),
    deposit_amount DECIMAL(10,2),
    deposit_status CHAR(1),
    deposit_status_date DATE,
    currency_code NVARCHAR(10),
    total_sales DECIMAL(12,2),
    tax DECIMAL(10,2),
    notes NVARCHAR(200),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- SALES ORDER LINE
IF OBJECT_ID(N'dbo.sales_order_line', N'U') IS NULL
CREATE TABLE dbo.sales_order_line (
    sales_order_line_id INT IDENTITY PRIMARY KEY,
    sales_order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(12,2),
    status CHAR(1) DEFAULT 'O',
    status_date DATE DEFAULT CAST(GETDATE() AS DATE),
    notes NVARCHAR(200),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- PURCHASE ORDER
IF OBJECT_ID(N'dbo.purchase_order', N'U') IS NULL
CREATE TABLE dbo.purchase_order (
    purchase_order_id INT IDENTITY PRIMARY KEY,
    vendor_id INT,
    vendor_order_number NVARCHAR(50),
    purchase_date DATE DEFAULT CAST(GETDATE() AS DATE),
    currency_code NVARCHAR(10),
    total_cost DECIMAL(12,2),
    tax DECIMAL(10,2),
    notes NVARCHAR(200),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- PURCHASE ORDER LINE
IF OBJECT_ID(N'dbo.purchase_order_line', N'U') IS NULL
CREATE TABLE dbo.purchase_order_line (
    purchase_order_line_id INT IDENTITY PRIMARY KEY,
    purchase_order_id INT,
    sales_order_line_id INT NULL,
    product_id INT,
    quantity INT,
    unit_cost DECIMAL(12,2),
    notes NVARCHAR(200),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- SHIPMENT SEGMENT
IF OBJECT_ID(N'dbo.shipment_segment', N'U') IS NULL
CREATE TABLE dbo.shipment_segment (
    shipment_segment_id INT IDENTITY PRIMARY KEY,
    purchase_order_line_id INT,
    ship_via_id INT,
    tracking_number NVARCHAR(100),
    ship_date DATE,
    receive_date DATE,
    shipping_cost DECIMAL(12,2),
    currency_code NVARCHAR(10),
    status NVARCHAR(20),
    status_date DATE,
    notes NVARCHAR(200),
    last_update_timestamp DATETIME DEFAULT GETDATE()
)
GO

-- INVENTORY
IF OBJECT_ID(N'dbo.inventory', N'U') IS NULL
CREATE TABLE dbo.inventory (
    inventory_id INT IDENTITY PRIMARY KEY,
    purchase_order_line_id INT,
    received_date DATE,
    status NVARCHAR(20),
    status_date DATE,
    tag_id INT,
    tag_date DATE,
    quantity INT,
    notes NVARCHAR(200),
    last_update_timestamp DATETIME DEFAULT GETDATE()
)
GO

-- GL ACCOUNT
IF OBJECT_ID(N'dbo.gl_account', N'U') IS NULL
CREATE TABLE dbo.gl_account (
    gl_account_id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(50),
    currency_code NVARCHAR(10),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- CASH RECEIPT
IF OBJECT_ID(N'dbo.cash_receipt', N'U') IS NULL
CREATE TABLE dbo.cash_receipt (
    cash_receipt_id INT IDENTITY PRIMARY KEY,
    customer_id INT,
    receipt_date DATE,
    amount DECIMAL(12,2),
    currency_code NVARCHAR(10),
    status NVARCHAR(20),
    gl_account_id INT,
    source NVARCHAR(30),
    notes NVARCHAR(200),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- CASH RECEIPT APPLICATION
IF OBJECT_ID(N'dbo.cash_receipt_application', N'U') IS NULL
CREATE TABLE dbo.cash_receipt_application (
    cash_receipt_application_id INT IDENTITY PRIMARY KEY,
    cash_receipt_id INT,
    sales_order_id INT,
    applied_amount DECIMAL(12,2),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- PAYABLE
IF OBJECT_ID(N'dbo.payable', N'U') IS NULL
CREATE TABLE dbo.payable (
    payable_id INT IDENTITY PRIMARY KEY,
    vendor_id INT,
    source NVARCHAR(20),
    purchase_order_id INT NULL,
    shipment_segment_id INT NULL,
    amount DECIMAL(12,2),
    currency_code NVARCHAR(10),
    status NVARCHAR(20),
    gl_account_id INT,
    notes NVARCHAR(200),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- CASH DISBURSEMENT
IF OBJECT_ID(N'dbo.cash_disbursement', N'U') IS NULL
CREATE TABLE dbo.cash_disbursement (
    disbursement_id INT IDENTITY PRIMARY KEY,
    pay_to_type NVARCHAR(20),
    pay_to_id INT,
    pay_date DATE,
    amount DECIMAL(12,2),
    currency_code NVARCHAR(10),
    gl_account_id INT,
    notes NVARCHAR(200),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- ACCOUNT TRANSFER
IF OBJECT_ID(N'dbo.account_transfer', N'U') IS NULL
CREATE TABLE dbo.account_transfer (
    transfer_id INT IDENTITY PRIMARY KEY,
    from_account_id INT,
    to_account_id INT,
    transfer_date DATE,
    amount DECIMAL(12,2),
    exchange_rate DECIMAL(10,4),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO

-- ACCRUAL REGISTER
IF OBJECT_ID(N'dbo.accrual_register', N'U') IS NULL
CREATE TABLE dbo.accrual_register (
    entry_id INT IDENTITY PRIMARY KEY,
    source_type NVARCHAR(30),
    source_id INT,
    gl_account_id INT,
    amount DECIMAL(12,2),
    entry_date DATE,
    currency_code NVARCHAR(10),
    debit_credit CHAR(1),
    description NVARCHAR(200),
    last_update_timestamp DATETIME DEFAULT GETDATE()
);
GO
