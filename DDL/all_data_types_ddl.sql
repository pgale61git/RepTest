-- Table containing the Ingres SQL data types documented at
-- https://docs.actian.com/actianingres/12.1/index.html#page/SQLRef/Understanding_SQL_Data_Types.htm

DROP TABLE IF EXISTS all_data_types
\p\g

CREATE TABLE all_data_types (
    -- Character
    id INTEGER NOT NULL,
    char_col CHAR(20),
    varchar_col VARCHAR(200),
    long_varchar_col LONG VARCHAR,
    clob_col CLOB,
    nchar_col NCHAR(20),
    nvarchar_col NVARCHAR(200),
    long_nvarchar_col LONG NVARCHAR,
    nclob_col NCLOB,
    c_col C(20),
    text_col TEXT(200),

    -- Numeric
    integer1_col INTEGER1,
    tinyint_col TINYINT,
    integer2_col INTEGER2,
    smallint_col SMALLINT,
    integer4_col INTEGER4,
    integer_col INTEGER,
    integer8_col INTEGER8,
    bigint_col BIGINT,
    decimal_col DECIMAL(18,6),
    float_col FLOAT,
    float8_col FLOAT8,
    float4_col FLOAT4,
    real_col REAL,

    -- Date and time
    ansidate_col ANSIDATE,
    time_col TIME(3),
    time_tz_col TIME(3) WITH TIME ZONE,
    time_local_tz_col TIME(3) WITH LOCAL TIME ZONE,
    timestamp_col TIMESTAMP(3),
    timestamp_tz_col TIMESTAMP(3) WITH TIME ZONE,
    timestamp_local_tz_col TIMESTAMP(3) WITH LOCAL TIME ZONE,
    interval_year_month_col INTERVAL YEAR TO MONTH,
    interval_day_second_col INTERVAL DAY TO SECOND(3),
    ingresdate_col INGRESDATE,
    date_col DATE,

    -- Abstract and network types
    money_col MONEY,
    ipv4_col IPV4,
    ipv6_col IPV6,
    uuid_col UUID,

    -- Binary
    byte_col BYTE(8),
    varbyte_col VARBYTE(200),
    long_byte_col LONG BYTE,

    -- Boolean and JSON
    boolean_col BOOLEAN,
    json_col JSON
)
\p\g

ALTER TABLE all_data_types
    ADD CONSTRAINT all_data_types_pk PRIMARY KEY (id)
WITH (INDEX=BASE TABLE STRUCTURE)
\p\g

INSERT INTO all_data_types (
    id,
    char_col, varchar_col, long_varchar_col, clob_col,
    nchar_col, nvarchar_col, long_nvarchar_col, nclob_col, c_col, text_col,
    integer1_col, tinyint_col, integer2_col, smallint_col,
    integer4_col, integer_col, integer8_col, bigint_col,
    decimal_col, float_col, float8_col, float4_col, real_col,
    ansidate_col, time_col, time_tz_col, time_local_tz_col,
    timestamp_col, timestamp_tz_col, timestamp_local_tz_col,
    interval_year_month_col, interval_day_second_col, ingresdate_col, date_col,
    money_col, ipv4_col, ipv6_col, uuid_col,
    byte_col, varbyte_col, long_byte_col,
    boolean_col, json_col
)
VALUES (
    1,
    'fixed', 'variable', 'long variable text', 'clob text',
    'fixed unicode', 'variable unicode', 'long unicode text', 'unicode clob', 'c text', 'text',
    1, 1, 2, 2,
    3, 3, 4, 4,
    CAST(123.456789 AS DECIMAL(18,6)), 1.25, 1.25, 1.25, 1.25,
    ANSIDATE '2026-11-24', TIME '12:34:56', TIME '12:34:56-05:00', TIME '12:34:56',
    TIMESTAMP '2026-11-24 12:34:56.123',
    TIMESTAMP '2026-11-24 12:34:56.123-05:00',
    TIMESTAMP '2026-11-24 12:34:56.123',
    INTERVAL '1-2' YEAR TO MONTH,
    INTERVAL '3 04:05:06.123' DAY TO SECOND(3),
    INGRESDATE '2026-11-24 12:34:56', DATE '2026-11-24',
    CAST(1234.56 AS MONEY), NULL,
    IPV4 '192.0.2.10', IPV6 '2001:0db8:85a3:0042:1000:8a2e:0370:7334',
    UUID '00112233-4455-6677-8899-aabbccddeeff',
    X'4A4D4741', X'01020304', X'0102030405060708',
    TRUE, CAST('{"name":"sample","active":true}' AS JSON)
)
\p\g

