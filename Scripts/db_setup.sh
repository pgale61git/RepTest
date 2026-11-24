#!/bin/bash

# Set up source and target databases for replication testing

SRC=$1
TGT=$2
USER=$3

[[ "$USER" != "" ]] && USER="-u$USER"

echo "This will destroy the source and target databases: $SRC and $TGT"
echo "Are you sure you want to continue? (y/n)"
read answer
if [ "$answer" != "y" ]; then
    echo "Aborting."
    exit 1
fi

destroydb $USER $SRC
destroydb $USER $TGT

for db in $SRC $TGT; do
    createdb $USER $db
    sql $USER $db < DDL/schema_ddl.sql
    ckpdb $USER +j $db
done
