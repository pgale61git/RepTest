
CREATE TABLE all_datatypes_test
(
    -- Character data types
    col_char          CHAR(30),
    col_varchar       VARCHAR(100),
    col_long_varchar  LONG VARCHAR(1000),
    col_nchar         NCHAR(30),
    col_nvarchar      NVARCHAR(100),
    col_long_nvarchar LONG NVARCHAR(1000),
    col_c             C(30),
    col_text          TEXT(100),

    -- Numeric data types
    col_integer1      INTEGER1,
    col_integer2      INTEGER2,
    col_integer4      INTEGER4,
    col_integer8      INTEGER8,
    col_decimal       DECIMAL(12,3),
    col_float         FLOAT,
    col_float4        FLOAT4,

    -- Date and time data types
    col_ansidate      ANSIDATE,
    col_time          TIME(3),
    col_time_tz       TIME(3) WITH TIME ZONE,
    col_time_local_tz TIME(3) WITH LOCAL TIME ZONE,
    col_timestamp     TIMESTAMP(3),
    col_timestamp_tz  TIMESTAMP(3) WITH TIME ZONE,
    col_timestamp_ltz TIMESTAMP(3) WITH LOCAL TIME ZONE,
    col_interval_ym   INTERVAL YEAR TO MONTH,
    col_interval_ds   INTERVAL DAY TO SECOND(3),
    col_ingresdate    INGRESDATE,
    col_date          DATE,

    -- Abstract data types
    col_money         MONEY,
    col_logical_key   LOGICAL_KEY NOT SYSTEM_MAINTAINED,
    col_ipv4          IPV4,
    col_ipv6          IPV6,
    col_uuid          UUID,

    -- Binary data types
    col_byte          BYTE(10),
    col_varbyte       VARBYTE(20),
    col_long_byte     LONG BYTE(1000),

    -- Boolean data type
    col_boolean       BOOLEAN
);
\p\g
