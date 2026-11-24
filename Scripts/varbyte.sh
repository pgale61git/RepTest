#!/bin/bash
#
# Insert into varbyte table and select from it

SRC=$1
TGT=$2


K1=$((RANDOM % 10000))


sql $SRC <<EOF
INSERT INTO varbyte_test (id, varbyte_col) VALUES ($K1, X'0102030405')\p\g
EOF

sleep 5

sql $TGT <<EOF
SELECT * FROM varbyte_test WHERE id = $K1\p\g
EOF