#!/bin/bash
#
# Insert into 2 tables to merge into 1

SRC=$1
TGT=$2


K1=$((RANDOM % 10000))
K2=$((RANDOM % 10000))

sql $SRC <<EOF
INSERT INTO table1 (id, name) VALUES ($K1, 'Alice')\p\g
INSERT INTO table2 (id, description) VALUES ($K1, 'Engineer')\p\g
INSERT INTO table1 (id, name) VALUES ($K2, 'Bob')\p\g
INSERT INTO table2 (id, description) VALUES ($K2, 'Manager')\p\g
EOF

sleep 5

sql $TGT <<EOF
SELECT * FROM merged_target WHERE id IN ($K1, $K2)\p\g
EOF