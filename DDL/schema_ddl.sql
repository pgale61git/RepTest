-- Full Replicator Test Schema
SET NOJOURNALING\p\g
SET AUTOCOMMIT ON\p\g

DROP TABLE IF EXISTS regions\p\g

CREATE TABLE regions (
    region_id   INTEGER NOT NULL,
    region_name VARCHAR(50),
    active_flag CHAR(1)
);
\p\g
MODIFY regions to BTREE UNIQUE on region_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE regions ADD CONSTRAINT regions_pk PRIMARY KEY (region_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY regions (region_id=c0comma,region_name=c0comma,active_flag=c0nl) FROM 'csv/regions.csv'\p\g
SET JOURNALING ON regions\p\g

DROP TABLE IF EXISTS customers\p\g

CREATE TABLE customers (
    customer_id  INTEGER NOT NULL,
    region_id    INTEGER,
    first_name   VARCHAR(50),
    last_name    VARCHAR(50),
    credit_limit DECIMAL(12,2),
    balance      DECIMAL(12,2),
    birth_date   DATE,
    created_ts   TIMESTAMP,
    active_flag  CHAR(1)
);
\p\g
MODIFY customers to BTREE UNIQUE on customer_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE customers ADD CONSTRAINT customers_pk PRIMARY KEY (customer_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY customers (customer_id=c0comma,region_id=c0comma,first_name=c0comma,last_name=c0comma,credit_limit=c0comma,balance=c0comma,birth_date=c0comma,created_ts=c0comma,active_flag=c0nl) FROM 'csv/customers.csv'\p\g
SET JOURNALING ON customers\p\g

DROP TABLE IF EXISTS customer_notes\p\g

CREATE TABLE customer_notes (
    note_id    INTEGER NOT NULL,
    customer_id INTEGER,
    note_text  VARCHAR(500),
    created_ts TIMESTAMP
);
MODIFY customer_notes to BTREE UNIQUE on note_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE customer_notes ADD CONSTRAINT customer_notes_pk PRIMARY KEY (note_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY customer_notes (note_id=c0comma,customer_id=c0comma,note_text=c0comma,created_ts=c0nl) FROM 'csv/customer_notes.csv'\p\g
SET JOURNALING ON customer_notes\p\g

DROP TABLE IF EXISTS products\p\g

CREATE TABLE products (
    product_id   INTEGER NOT NULL,
    sku          CHAR(12),
    product_name VARCHAR(100),
    unit_price   DECIMAL(10,2),
    weight_kg    FLOAT,
    active_flag  CHAR(1)
);
\p\g
MODIFY products to BTREE UNIQUE on product_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE products ADD CONSTRAINT products_pk PRIMARY KEY (product_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY products (product_id=c0comma,sku=c0comma,product_name=c0comma,unit_price=c0comma,weight_kg=c0comma,active_flag=c0nl) FROM 'csv/products.csv'\p\g
SET JOURNALING ON products\p\g

DROP TABLE IF EXISTS warehouses\p\g

CREATE TABLE warehouses (
    warehouse_id   INTEGER NOT NULL,
    warehouse_name VARCHAR(100),
    location_code  CHAR(10)
);
MODIFY warehouses to BTREE UNIQUE on warehouse_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE warehouses ADD CONSTRAINT warehouses_pk PRIMARY KEY (warehouse_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY warehouses (warehouse_id=c0comma,warehouse_name=c0comma,location_code=c0nl) FROM 'csv/warehouses.csv'\p\g
SET JOURNALING ON warehouses\p\g

DROP TABLE IF EXISTS inventory\p\g

CREATE TABLE inventory (
    inventory_id INTEGER NOT NULL,
    warehouse_id INTEGER,
    product_id   INTEGER,
    quantity     INTEGER,
    reorder_level SMALLINT
);
\p\g
MODIFY inventory to BTREE UNIQUE on inventory_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE inventory ADD CONSTRAINT inventory_pk PRIMARY KEY (inventory_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY inventory (inventory_id=c0comma,warehouse_id=c0comma,product_id=c0comma,quantity=c0comma,reorder_level=c0nl) FROM 'csv/inventory.csv'\p\g
SET JOURNALING ON inventory\p\g

DROP TABLE IF EXISTS orders\p\g

CREATE TABLE orders (
    order_id     INTEGER NOT NULL,
    customer_id  INTEGER,
    order_date   DATE,
    order_ts     TIMESTAMP,
    order_status VARCHAR(20),
    total_amount DECIMAL(14,2)
);
MODIFY orders to BTREE UNIQUE on order_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE orders ADD CONSTRAINT orders_pk PRIMARY KEY (order_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY orders (order_id=c0comma,customer_id=c0comma,order_date=c0comma,order_ts=c0comma,order_status=c0comma,total_amount=c0nl) FROM 'csv/orders.csv'\p\g
SET JOURNALING ON orders\p\g

DROP TABLE IF EXISTS order_items\p\g

CREATE TABLE order_items (
    order_item_id INTEGER NOT NULL,
    order_id      INTEGER,
    product_id    INTEGER,
    quantity      SMALLINT,
    unit_price    DECIMAL(10,2)
);
\p\g
MODIFY order_items to BTREE UNIQUE on order_item_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE order_items ADD CONSTRAINT order_items_pk PRIMARY KEY (order_item_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY order_items (order_item_id=c0comma,order_id=c0comma,product_id=c0comma,quantity=c0comma,unit_price=c0nl) FROM 'csv/order_items.csv'\p\g
SET JOURNALING ON order_items\p\g

DROP TABLE IF EXISTS shipments\p\g

CREATE TABLE shipments (
    shipment_id INTEGER NOT NULL,
    order_id    INTEGER,
    ship_date   DATE,
    tracking_no VARCHAR(60)
);
MODIFY shipments to BTREE UNIQUE on shipment_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE shipments ADD CONSTRAINT shipments_pk PRIMARY KEY (shipment_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY shipments (shipment_id=c0comma,order_id=c0comma,ship_date=c0comma,tracking_no=c0nl) FROM 'csv/shipments.csv'\p\g
SET JOURNALING ON shipments\p\g

DROP TABLE IF EXISTS suppliers\p\g

CREATE TABLE suppliers (
    supplier_id   INTEGER NOT NULL,
    supplier_name VARCHAR(100),
    rating        SMALLINT
);
\p\g
MODIFY suppliers to BTREE UNIQUE on supplier_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE suppliers ADD CONSTRAINT suppliers_pk PRIMARY KEY (supplier_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY suppliers (supplier_id=c0comma,supplier_name=c0comma,rating=c0nl) FROM 'csv/suppliers.csv'\p\g
SET JOURNALING ON suppliers\p\g

DROP TABLE IF EXISTS purchases\p\g

CREATE TABLE purchases (
    purchase_id    INTEGER NOT NULL,
    supplier_id    INTEGER,
    purchase_ts    TIMESTAMP,
    purchase_value DECIMAL(14,2)
);
MODIFY purchases to BTREE UNIQUE on purchase_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE purchases ADD CONSTRAINT purchases_pk PRIMARY KEY (purchase_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY purchases (purchase_id=c0comma,supplier_id=c0comma,purchase_ts=c0comma,purchase_value=c0nl) FROM 'csv/purchases.csv'\p\g
SET JOURNALING ON purchases\p\g

DROP TABLE IF EXISTS employees\p\g

CREATE TABLE employees (
    employee_id INTEGER NOT NULL,
    first_name  VARCHAR(50),
    surname     VARCHAR(50),
    salary      DECIMAL(12,2),
    hire_date   DATE
);
\p\g
MODIFY employees to BTREE UNIQUE on employee_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE employees ADD CONSTRAINT employees_pk PRIMARY KEY (employee_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY employees (employee_id=c0comma,first_name=c0comma,surname=c0comma,salary=c0comma,hire_date=c0nl) FROM 'csv/employees.csv'\p\g
SET JOURNALING ON employees\p\g

DROP TABLE IF EXISTS config_values\p\g

CREATE TABLE config_values (
    config_id    INTEGER NOT NULL,
    config_name  VARCHAR(100),
    config_value VARCHAR(500)
);
MODIFY config_values to BTREE UNIQUE on config_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE config_values ADD CONSTRAINT config_values_pk PRIMARY KEY (config_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY config_values (config_id=c0comma,config_name=c0comma,config_value=c0nl) FROM 'csv/config_values.csv'\p\g
SET JOURNALING ON config_values\p\g

DROP TABLE IF EXISTS binary_test\p\g

CREATE TABLE binary_test (
    binary_id     INTEGER NOT NULL,
    fixed_data    BYTE(64),
    variable_data BYTE VARYING(256)
);
\p\g
MODIFY binary_test to BTREE UNIQUE on binary_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE binary_test ADD CONSTRAINT binary_test_pk PRIMARY KEY (binary_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
SET JOURNALING ON binary_test\p\g

DROP TABLE IF EXISTS datatype_test\p\g

CREATE TABLE datatype_test (
    test_id     INTEGER NOT NULL,
    c_char      CHAR(20),
    c_varchar   VARCHAR(200),
    c_smallint  SMALLINT,
    c_integer   INTEGER,
    c_float     FLOAT,
    c_real      REAL,
    c_decimal   DECIMAL(18,6),
    c_date      DATE,
    c_time      TIME,
    c_timestamp TIMESTAMP
);
\p\g
MODIFY datatype_test to BTREE UNIQUE on test_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE datatype_test ADD CONSTRAINT datatype_test_pk PRIMARY KEY (test_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY datatype_test (test_id=c0comma,c_char=c0comma,c_varchar=c0comma,c_smallint=c0comma,c_integer=c0comma,c_float=c0comma,c_real=c0comma,c_decimal=c0comma,c_date=c0comma,c_time=c0comma,c_timestamp=c0nl) FROM 'csv/datatype_test.csv'\p\g
SET JOURNALING ON datatype_test\p\g

DROP TABLE IF EXISTS workload_log\p\g

CREATE TABLE workload_log (
    log_id         INTEGER NOT NULL,
    event_ts       TIMESTAMP,
    txn_id         VARCHAR(64),
    operation_type CHAR(1),
    table_name     VARCHAR(50),
    pk_value       VARCHAR(100),
    commit_flag    CHAR(1),
    status         VARCHAR(20),
    error_text     VARCHAR(255)
);
\p\g
MODIFY workload_log to BTREE UNIQUE on log_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE workload_log ADD CONSTRAINT workload_log_pk PRIMARY KEY (log_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
SET JOURNALING ON workload_log\p\g

