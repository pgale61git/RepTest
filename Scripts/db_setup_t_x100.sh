#!/bin/bash

# Set up source and target databases for replication testing
# Target uses X100 

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

createdb $SRC
sql $SRC < DDL/schema_ddl.sql
ckpdb +j $SRC

createdb $TGT
sql $TGT < DDL/schema_ddl_x100.sql
ckpdb +j $TGT
