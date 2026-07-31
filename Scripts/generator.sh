#!/bin/bash
set -euo pipefail

out_dir="csv"
mkdir -p "$out_dir"
rm -f "$out_dir"/*.csv

today=$(date '+%Y-%m-%d')
now=$(date '+%Y-%m-%d %H:%M:%S')

for i in $(seq 1 20); do
    printf '%d,Region-%d,Y,0\n' "$i" "$i" >> "$out_dir/region.csv"
done

for i in $(seq 1 10000); do
    printf '%d,%d,First%d,Last%d,1000.00,100.00,%s,%s,Y,0\n' "$i" "$((RANDOM % 20 + 1))" "$i" "$i" "$today" "$now" >> "$out_dir/customer.csv"
done

for i in $(seq 1 50000); do
    printf '%d,%d,Note %d,%s,0\n' "$i" "$((RANDOM % 10000 + 1))" "$i" "$now" >> "$out_dir/customer_note.csv"
done

for i in $(seq 1 5000); do
    printf '%d,SKU%d,Product-%d,9.99,1.5,Y,0\n' "$i" "$i" "$i" >> "$out_dir/product.csv"
done

for i in $(seq 1 20); do
    printf '%d,Warehouse-%d,LOC%d,0\n' "$i" "$i" "$i" >> "$out_dir/warehouse.csv"
done

for i in $(seq 1 20000); do
    printf '%d,%d,%d,100,10,0\n' "$i" "$((RANDOM % 20 + 1))" "$((RANDOM % 5000 + 1))" >> "$out_dir/inventory.csv"
done

for i in $(seq 1 100000); do
    printf '%d,%d,%s,%s,NEW,99.99,0\n' "$i" "$((RANDOM % 10000 + 1))" "$today" "$now" >> "$out_dir/order.csv"
done

for i in $(seq 1 300000); do
    printf '%d,%d,%d,1,9.99,0\n' "$i" "$((RANDOM % 100000 + 1))" "$((RANDOM % 5000 + 1))" >> "$out_dir/order_item.csv"
done

for i in $(seq 1 50000); do
    printf '%d,%d,%s,TRK%d,0\n' "$i" "$((RANDOM % 100000 + 1))" "$today" "$i" >> "$out_dir/shipment.csv"
done

for i in $(seq 1 500); do
    printf '%d,Supplier-%d,5,0\n' "$i" "$i" >> "$out_dir/supplier.csv"
done

for i in $(seq 1 20000); do
    printf '%d,%d,%s,100.00,0\n' "$i" "$((RANDOM % 500 + 1))" "$now" >> "$out_dir/purchase.csv"
done

for i in $(seq 1 2000); do
    printf '%d,Emp%d,Surname%d,50000.00,%s,0\n' "$i" "$i" "$i" "$today" >> "$out_dir/employee.csv"
done

for i in $(seq 1 100); do
    printf '%d,CFG%d,VALUE%d,0\n' "$i" "$i" "$i" >> "$out_dir/config_value.csv"
done

for i in $(seq 1 20000); do
    printf '%d,C%d,V%d,%d,%d,1.1,2.2,123.456789,%s,12:00:00,%s,0\n' "$i" "$i" "$i" "1" "$i" "$today" "$now" >> "$out_dir/datatype_test.csv"
done

printf 'CSV file generation complete. Files written to %s/%s\n' "$PWD" "$out_dir"

