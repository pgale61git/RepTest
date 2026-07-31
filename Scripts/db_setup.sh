#!/bin/bash

# Set up source and target databases for replication testing

SRC=$1
TGT=$2

echo "This will destroy the source and target databases: $SRC and $TGT"
echo "Are you sure you want to continue? (y/n)"
read answer
if [ "$answer" != "y" ]; then
    echo "Aborting."
    exit 1
fi

destroydb $SRC
destroydb $TGT

for db in $SRC $TGT; do
    createdb $db
    sql $db < DDL/schema_ddl.sql
    ckpdb +j $db
done
