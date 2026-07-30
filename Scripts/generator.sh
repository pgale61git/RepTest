#!/bin/bash

# Generate seed SQL
now=$(date '+%Y-%m-%d')

echo "begin transaction;\p\g"

for i in $(seq 1 20); do
    echo "insert into regions values($i,'Region-$i','Y');\p\g"
done

for i in $(seq 1 10000); do
    echo "insert into customers values($i,$((RANDOM % 20 + 1)),'First$i','Last$i',1000.00,100.00,date('$now'),current_timestamp,'Y');\p\g"
done

for i in $(seq 1 50000); do
    echo "insert into customer_notes values($i,$((RANDOM % 10000 + 1)),'Note $i',current_timestamp);\p\g"
done

for i in $(seq 1 5000); do
    echo "insert into products values($i,'SKU$i','Product-$i',9.99,1.5,'Y');\p\g"
done

for i in $(seq 1 20); do
    echo "insert into warehouses values($i,'Warehouse-$i','LOC$i');\p\g"
done

for i in $(seq 1 20000); do
    echo "insert into inventory values($i,$((RANDOM % 20 + 1)),$((RANDOM % 5000 + 1)),100,10);\p\g"
done

for i in $(seq 1 100000); do
    echo "insert into orders values($i,$((RANDOM % 10000 + 1)),current_date,current_timestamp,'NEW',99.99);\p\g"
done

for i in $(seq 1 300000); do
    echo "insert into order_items values($i,$((RANDOM % 100000 + 1)),$((RANDOM % 5000 + 1)),1,9.99);\p\g"
done

for i in $(seq 1 50000); do
    echo "insert into shipments values($i,$((RANDOM % 100000 + 1)),current_date,'TRK$i');\p\g"
done

for i in $(seq 1 500); do
    echo "insert into suppliers values($i,'Supplier-$i',5);\p\g"
done

for i in $(seq 1 20000); do
    echo "insert into purchases values($i,$((RANDOM % 500 + 1)),current_timestamp,100.00);\p\g"
done

for i in $(seq 1 2000); do
    echo "insert into employees values($i,'Emp$i','Surname$i',50000.00,current_date);\p\g"
done

for i in $(seq 1 100); do
    echo "insert into config_values values($i,'CFG$i','VALUE$i');\p\g"
done

for i in $(seq 1 20000); do
    echo "insert into datatype_test values($i,'C$i','V$i',1,$i,1.1,2.2,123.456789,current_date,time('12:00:00'),current_timestamp);\p\g"
done

echo 'commit;\p\g'
