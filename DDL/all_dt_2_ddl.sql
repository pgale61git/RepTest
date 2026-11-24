
DROP TABLE IF EXISTS all_datatypes_test;
\p\g
CREATE TABLE all_datatypes_test
(
    -- Character data types
    col_char          CHAR(30) NOT NULL,
    col_varchar       VARCHAR(100) NOT NULL,
    col_long_varchar  LONG VARCHAR NOT NULL,
    col_long_varchar_inline  LONG VARCHAR(10) NOT NULL,
    col_nchar         NCHAR(30) NOT NULL,
    col_nvarchar      NVARCHAR(100) NOT NULL,
    col_long_nvarchar LONG NVARCHAR NOT NULL,
    col_long_nvarchar_inline LONG NVARCHAR(10) NOT NULL,
    col_c             C(30) NOT NULL,
    col_text          TEXT(100) NOT NULL,

    -- Numeric data types
    col_integer1      INTEGER1 NOT NULL,
    col_integer2      INTEGER2 NOT NULL,
    col_integer4      INTEGER4 NOT NULL,
    col_integer8      INTEGER8 NOT NULL,
    col_decimal       DECIMAL(12,3) NOT NULL,
    col_float         FLOAT NOT NULL,
    col_float4        FLOAT4 NOT NULL,

    -- Date and time data types
    col_ansidate      ANSIDATE NOT NULL,
    col_time          TIME(3) NOT NULL,
    col_time_tz       TIME(3) WITH TIME ZONE NOT NULL,
    col_time_local_tz TIME(3) WITH LOCAL TIME ZONE NOT NULL,
    col_timestamp     TIMESTAMP(3) NOT NULL,
    col_timestamp_tz  TIMESTAMP(3) WITH TIME ZONE NOT NULL,
    col_timestamp_ltz TIMESTAMP(3) WITH LOCAL TIME ZONE NOT NULL,
    col_interval_ym   INTERVAL YEAR TO MONTH NOT NULL,
    col_interval_ds   INTERVAL DAY TO SECOND(3) NOT NULL,
    col_ingresdate    INGRESDATE NOT NULL,
    col_date          DATE NOT NULL,

    -- Abstract data types
    col_money         MONEY NOT NULL,
    col_ipv4          IPV4 NOT NULL,
    col_ipv6          IPV6 NOT NULL,
    col_uuid          UUID NOT NULL,

    -- Binary data types
    col_byte          BYTE(10) NOT NULL,
    col_varbyte       VARBYTE(20) NOT NULL,
    col_long_byte     LONG BYTE NOT NULL,
    col_long_byte_inline LONG BYTE(10) NOT NULL,

    -- Boolean data type
    col_boolean       BOOLEAN NOT NULL
)
WITH JOURNALING
\p\g
ALTER TABLE all_datatypes_test ADD CONSTRAINT adt_pk PRIMARY KEY (col_char)
\p\g
