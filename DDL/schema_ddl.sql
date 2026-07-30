-- Full Replicator Test Schema

CREATE TABLE regions (
    region_id   INTEGER NOT NULL PRIMARY KEY,
    region_name VARCHAR(50),
    active_flag CHAR(1)
);
\p\g

CREATE TABLE customers (
    customer_id  INTEGER NOT NULL PRIMARY KEY,
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

CREATE TABLE customer_notes (
    note_id    INTEGER NOT NULL PRIMARY KEY,
    customer_id INTEGER,
    note_text  VARCHAR(500),
    created_ts TIMESTAMP
);

CREATE TABLE products (
    product_id   INTEGER NOT NULL PRIMARY KEY,
    sku          CHAR(12),
    product_name VARCHAR(100),
    unit_price   DECIMAL(10,2),
    weight_kg    FLOAT,
    active_flag  CHAR(1)
);
\p\g

CREATE TABLE warehouses (
    warehouse_id   INTEGER NOT NULL PRIMARY KEY,
    warehouse_name VARCHAR(100),
    location_code  CHAR(10)
);

CREATE TABLE inventory (
    inventory_id INTEGER NOT NULL PRIMARY KEY,
    warehouse_id INTEGER,
    product_id   INTEGER,
    quantity     INTEGER,
    reorder_level SMALLINT
);
\p\g

CREATE TABLE orders (
    order_id     INTEGER NOT NULL PRIMARY KEY,
    customer_id  INTEGER,
    order_date   DATE,
    order_ts     TIMESTAMP,
    order_status VARCHAR(20),
    total_amount DECIMAL(14,2)
);

CREATE TABLE order_items (
    order_item_id INTEGER NOT NULL PRIMARY KEY,
    order_id      INTEGER,
    product_id    INTEGER,
    quantity      SMALLINT,
    unit_price    DECIMAL(10,2)
);
\p\g

CREATE TABLE shipments (
    shipment_id INTEGER NOT NULL PRIMARY KEY,
    order_id    INTEGER,
    ship_date   DATE,
    tracking_no VARCHAR(60)
);

CREATE TABLE suppliers (
    supplier_id   INTEGER NOT NULL PRIMARY KEY,
    supplier_name VARCHAR(100),
    rating        SMALLINT
);
\p\g

CREATE TABLE purchases (
    purchase_id    INTEGER NOT NULL PRIMARY KEY,
    supplier_id    INTEGER,
    purchase_ts    TIMESTAMP,
    purchase_value DECIMAL(14,2)
);

CREATE TABLE employees (
    employee_id INTEGER NOT NULL PRIMARY KEY,
    first_name  VARCHAR(50),
    surname     VARCHAR(50),
    salary      DECIMAL(12,2),
    hire_date   DATE
);
\p\g

CREATE TABLE config_values (
    config_id    INTEGER NOT NULL PRIMARY KEY,
    config_name  VARCHAR(100),
    config_value VARCHAR(500)
);

CREATE TABLE binary_test (
    binary_id     INTEGER NOT NULL PRIMARY KEY,
    fixed_data    BYTE(64),
    variable_data BYTE VARYING(256)
);
\p\g

CREATE TABLE datatype_test (
    test_id     INTEGER NOT NULL PRIMARY KEY,
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

CREATE TABLE workload_log (
    log_id         INTEGER NOT NULL PRIMARY KEY,
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

