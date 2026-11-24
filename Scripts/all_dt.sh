#!/bin/bash
#
# Insert into all data types table and select from it

SRC=$1
TGT=$2

sql $SRC <<EOF

-- ROW 1
INSERT INTO all_datatypes_test VALUES
(
    'CHAR_ROW_001',
    'VARCHAR_ROW_001',
    'LONG_VARCHAR_ROW_001',
    'L001_VARCHAR_ROW_001',
    N'NCHAR_ROW_001',
    N'NVARCHAR_ROW_001',
    N'LONG_NVARCHAR_ROW_001',
    N'L001_NVARCHAR_ROW_001',
    'C_ROW_001',
    'TEXT_ROW_001',

    11,
    1101,
    110001,
    110000001,
    111.111,
    1111.111,
    11.111,

    DATE '2024-01-15',
    TIME '08:15:30.111',
    TIME '08:15:30.111+01:00',
    TIME '08:15:30.111',
    TIMESTAMP '2024-01-15 08:15:30.111',
    TIMESTAMP '2024-01-15 08:15:30.111+01:00',
    TIMESTAMP '2024-01-15 08:15:30.111',
    INTERVAL '1-2' YEAR TO MONTH,
    INTERVAL '1 02:03:04.111' DAY TO SECOND,
    '15-Jan-2024 08:15:30',
    DATE '2024-01-15',

    111.11,
    'KEY00001',
    '192.168.1.11',
    '2001:db8:1::11',
    UUID(),

    X'0102030405',
    X'1112131415',
    X'2122232425',

    TRUE
);

\p\g

EOF

sleep 5

sql $TGT <<EOF
SELECT * FROM all_datatypes_test WHERE col_char = 'CHAR_ROW_001'\p\g
EOF