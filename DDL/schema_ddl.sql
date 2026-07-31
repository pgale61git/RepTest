-- Full Replicator Test Schema
SET NOJOURNALING\p\g
SET AUTOCOMMIT ON\p\g

DROP TABLE IF EXISTS region\p\g

CREATE TABLE region (
    region_id   INTEGER NOT NULL,
    region_name VARCHAR(50),
    active_flag CHAR(1),
    upd_col     INTEGER
);
\p\g
MODIFY region to BTREE UNIQUE on region_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE region ADD CONSTRAINT region_pk PRIMARY KEY (region_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY region (region_id=c0comma,region_name=c0comma,active_flag=c0comma,upd_col=c0nl) FROM 'csv/region.csv'\p\g
SET JOURNALING ON region\p\g

DROP TABLE IF EXISTS customer\p\g

CREATE TABLE customer (
    customer_id  INTEGER NOT NULL,
    region_id    INTEGER,
    first_name   VARCHAR(50),
    last_name    VARCHAR(50),
    credit_limit DECIMAL(12,2),
    balance      DECIMAL(12,2),
    birth_date   DATE,
    created_ts   TIMESTAMP,
    active_flag  CHAR(1),
    upd_col      INTEGER
);
\p\g
MODIFY customer to BTREE UNIQUE on customer_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY (customer_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY customer (customer_id=c0comma,region_id=c0comma,first_name=c0comma,last_name=c0comma,credit_limit=c0comma,balance=c0comma,birth_date=c0comma,created_ts=c0comma,active_flag=c0comma,upd_col=c0nl) FROM 'csv/customer.csv'\p\g
SET JOURNALING ON customer\p\g

DROP TABLE IF EXISTS customer_note\p\g

CREATE TABLE customer_note (
    customer_note_id    INTEGER NOT NULL,
    customer_id INTEGER,
    note_text  VARCHAR(500),
    created_ts TIMESTAMP,
    upd_col     INTEGER
);
MODIFY customer_note to BTREE UNIQUE on customer_note_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE customer_note ADD CONSTRAINT customer_note_pk PRIMARY KEY (customer_note_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY customer_note (customer_note_id=c0comma,customer_id=c0comma,note_text=c0comma,created_ts=c0comma,upd_col=c0nl) FROM 'csv/customer_note.csv'\p\g
SET JOURNALING ON customer_note\p\g

DROP TABLE IF EXISTS product\p\g

CREATE TABLE product (
    product_id   INTEGER NOT NULL,
    sku          CHAR(12),
    product_name VARCHAR(100),
    unit_price   DECIMAL(10,2),
    weight_kg    FLOAT,
    active_flag  CHAR(1),
    upd_col      INTEGER
);
\p\g
MODIFY product to BTREE UNIQUE on product_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE product ADD CONSTRAINT product_pk PRIMARY KEY (product_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY product (product_id=c0comma,sku=c0comma,product_name=c0comma,unit_price=c0comma,weight_kg=c0comma,active_flag=c0comma,upd_col=c0nl) FROM 'csv/product.csv'\p\g
SET JOURNALING ON product\p\g

DROP TABLE IF EXISTS warehouse\p\g

CREATE TABLE warehouse (
    warehouse_id   INTEGER NOT NULL,
    warehouse_name VARCHAR(100),
    location_code  CHAR(10),
    upd_col        INTEGER
);
MODIFY warehouse to BTREE UNIQUE on warehouse_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE warehouse ADD CONSTRAINT warehouse_pk PRIMARY KEY (warehouse_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY warehouse (warehouse_id=c0comma,warehouse_name=c0comma,location_code=c0comma,upd_col=c0nl) FROM 'csv/warehouse.csv'\p\g
SET JOURNALING ON warehouse\p\g

DROP TABLE IF EXISTS inventory\p\g

CREATE TABLE inventory (
    inventory_id INTEGER NOT NULL,
    warehouse_id INTEGER,
    product_id   INTEGER,
    quantity     INTEGER,
    reorder_level SMALLINT,
    upd_col       INTEGER
);
\p\g
MODIFY inventory to BTREE UNIQUE on inventory_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE inventory ADD CONSTRAINT inventory_pk PRIMARY KEY (inventory_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY inventory (inventory_id=c0comma,warehouse_id=c0comma,product_id=c0comma,quantity=c0comma,reorder_level=c0comma,upd_col=c0nl) FROM 'csv/inventory.csv'\p\g
SET JOURNALING ON inventory\p\g

DROP TABLE IF EXISTS order\p\g

CREATE TABLE order (
    order_id     INTEGER NOT NULL,
    customer_id  INTEGER,
    order_date   DATE,
    order_ts     TIMESTAMP,
    order_status VARCHAR(20),
    total_amount DECIMAL(14,2),
    upd_col      INTEGER
);
MODIFY order to BTREE UNIQUE on order_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE order ADD CONSTRAINT order_pk PRIMARY KEY (order_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY order (order_id=c0comma,customer_id=c0comma,order_date=c0comma,order_ts=c0comma,order_status=c0comma,total_amount=c0comma,upd_col=c0nl) FROM 'csv/order.csv'\p\g
SET JOURNALING ON order\p\g

DROP TABLE IF EXISTS order_item\p\g

CREATE TABLE order_item (
    order_item_id INTEGER NOT NULL,
    order_id      INTEGER,
    product_id    INTEGER,
    quantity      SMALLINT,
    unit_price    DECIMAL(10,2),
    upd_col       INTEGER
);
\p\g
MODIFY order_item to BTREE UNIQUE on order_item_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE order_item ADD CONSTRAINT order_item_pk PRIMARY KEY (order_item_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY order_item (order_item_id=c0comma,order_id=c0comma,product_id=c0comma,quantity=c0comma,unit_price=c0comma,upd_col=c0nl) FROM 'csv/order_item.csv'\p\g
SET JOURNALING ON order_item\p\g

DROP TABLE IF EXISTS shipment\p\g

CREATE TABLE shipment (
    shipment_id INTEGER NOT NULL,
    order_id    INTEGER,
    ship_date   DATE,
    tracking_no VARCHAR(60),
    upd_col      INTEGER
);
MODIFY shipment to BTREE UNIQUE on shipment_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE shipment ADD CONSTRAINT shipment_pk PRIMARY KEY (shipment_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY shipment (shipment_id=c0comma,order_id=c0comma,ship_date=c0comma,tracking_no=c0comma,upd_col=c0nl) FROM 'csv/shipment.csv'\p\g
SET JOURNALING ON shipment\p\g

DROP TABLE IF EXISTS supplier\p\g

CREATE TABLE supplier (
    supplier_id   INTEGER NOT NULL,
    supplier_name VARCHAR(100),
    rating        SMALLINT,
    upd_col       INTEGER
);
\p\g
MODIFY supplier to BTREE UNIQUE on supplier_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE supplier ADD CONSTRAINT supplier_pk PRIMARY KEY (supplier_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY supplier (supplier_id=c0comma,supplier_name=c0comma,rating=c0comma,upd_col=c0nl) FROM 'csv/supplier.csv'\p\g
SET JOURNALING ON supplier\p\g

DROP TABLE IF EXISTS purchase\p\g

CREATE TABLE purchase (
    purchase_id    INTEGER NOT NULL,
    supplier_id    INTEGER,
    purchase_ts    TIMESTAMP,
    purchase_value DECIMAL(14,2),
    upd_col        INTEGER
);
MODIFY purchase to BTREE UNIQUE on purchase_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE purchase ADD CONSTRAINT purchase_pk PRIMARY KEY (purchase_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY purchase (purchase_id=c0comma,supplier_id=c0comma,purchase_ts=c0comma,purchase_value=c0comma,upd_col=c0nl) FROM 'csv/purchase.csv'\p\g
SET JOURNALING ON purchase\p\g

DROP TABLE IF EXISTS employee\p\g

CREATE TABLE employee (
    employee_id INTEGER NOT NULL,
    first_name  VARCHAR(50),
    surname     VARCHAR(50),
    salary      DECIMAL(12,2),
    hire_date   DATE,
    upd_col     INTEGER
);
\p\g
MODIFY employee to BTREE UNIQUE on employee_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE employee ADD CONSTRAINT employee_pk PRIMARY KEY (employee_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY employee (employee_id=c0comma,first_name=c0comma,surname=c0comma,salary=c0comma,hire_date=c0comma,upd_col=c0nl) FROM 'csv/employee.csv'\p\g
SET JOURNALING ON employee\p\g

DROP TABLE IF EXISTS config_value\p\g

CREATE TABLE config_value (
    config_value_id    INTEGER NOT NULL,
    config_name  VARCHAR(100),
    config_value VARCHAR(500),
    upd_col      INTEGER
);
MODIFY config_value to BTREE UNIQUE on config_value_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE config_value ADD CONSTRAINT config_value_pk PRIMARY KEY (config_value_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY config_value (config_value_id=c0comma,config_name=c0comma,config_value=c0comma,upd_col=c0nl) FROM 'csv/config_value.csv'\p\g
SET JOURNALING ON config_value\p\g

DROP TABLE IF EXISTS binary_test\p\g

CREATE TABLE binary_test (
    binary_id     INTEGER NOT NULL,
    fixed_data    BYTE(64),
    variable_data BYTE VARYING(256),
    upd_col       INTEGER
);
\p\g
MODIFY binary_test to BTREE UNIQUE on binary_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE binary_test ADD CONSTRAINT binary_test_pk PRIMARY KEY (binary_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
SET JOURNALING ON binary_test\p\g

DROP TABLE IF EXISTS datatype_test\p\g

CREATE TABLE datatype_test (
    datatype_test_id     INTEGER NOT NULL,
    c_char      CHAR(20),
    c_varchar   VARCHAR(200),
    c_smallint  SMALLINT,
    c_integer   INTEGER,
    c_float     FLOAT,
    c_real      REAL,
    c_decimal   DECIMAL(18,6),
    c_date      DATE,
    c_time      TIME,
    c_timestamp TIMESTAMP,
    upd_col     INTEGER
);
\p\g
MODIFY datatype_test to BTREE UNIQUE on datatype_test_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE datatype_test ADD CONSTRAINT datatype_test_pk PRIMARY KEY (datatype_test_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
COPY datatype_test (datatype_test_id=c0comma,c_char=c0comma,c_varchar=c0comma,c_smallint=c0comma,c_integer=c0comma,c_float=c0comma,c_real=c0comma,c_decimal=c0comma,c_date=c0comma,c_time=c0comma,c_timestamp=c0comma,upd_col=c0nl) FROM 'csv/datatype_test.csv'\p\g
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
    error_text     VARCHAR(255),
    upd_col        INTEGER
);
\p\g
MODIFY workload_log to BTREE UNIQUE on log_id WITH UNIQUE_SCOPE=statement\p\g
ALTER TABLE workload_log ADD CONSTRAINT workload_log_pk PRIMARY KEY (log_id) WITH ( INDEX=BASE TABLE STRUCTURE )\p\g
SET JOURNALING ON workload_log\p\g

