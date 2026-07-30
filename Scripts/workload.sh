#!/bin/bash

DB=''
SPM=1000
MINUTES=10
I=35
U=50
D=15
R=10
F=1
T=5

while getopts d:s:m:i:u:x:r:f:t: o; do
    case $o in
        d) DB=$OPTARG ;;
        s) SPM=$OPTARG ;;
        m) MINUTES=$OPTARG ;;
        i) I=$OPTARG ;;
        u) U=$OPTARG ;;
        x) D=$OPTARG ;;
        r) R=$OPTARG ;;
        f) F=$OPTARG ;;
        t) T=$OPTARG ;;
    esac
done

mkdir -p logs
LOG="logs/workload_$(date +%Y%m%d_%H%M%S).log"
DELAY=$(awk "BEGIN { print 60 / $SPM }")

EXEC=0
INS=0
UPD=0
DELC=0
COM=0
ROL=0
ERR=0
TXNS=0

pick() {
    local arr=(
        customers
        customer_notes
        products
        inventory
        orders
        order_items
        shipments
        suppliers
        purchases
        employees
        config_values
        datatype_test
    )

    echo "${arr[$RANDOM % ${#arr[@]}]}"
}

gen() {
    local tbl op
    tbl=$(pick)
    op=$1

    case $tbl in
        customers)
            if [ "$op" = I ]; then
                echo "insert into customers values($((20000000 + EXEC)),1,'A','B',1,1,'today','now','Y');\p\g"
            else
                echo "update customers set balance=balance+1 where customer_id=$((RANDOM % 10000 + 1));\p\g"
            fi
            ;;
        orders)
            if [ "$op" = I ]; then
                echo "insert into orders values($((20000000 + EXEC)),1,'today','now','NEW',1);\p\g"
            else
                echo "update orders set total_amount=total_amount+1 where order_id=$((RANDOM % 100000 + 1));\p\g"
            fi
            ;;
        inventory)
            echo "update inventory set quantity=quantity+1 where inventory_id=$((RANDOM % 20000 + 1));\p\g"
            ;;
        products)
            echo "update products set unit_price=unit_price+1 where product_id=$((RANDOM % 5000 + 1));\p\g"
            ;;
        datatype_test)
            echo "update datatype_test set c_integer=c_integer+1,c_timestamp='now' where test_id=$((RANDOM % 20000 + 1));\p\g"
            ;;
        *)
            echo "update $tbl set rowid=rowid where 1=0;\p\g"
            ;;
    esac
}

start=$(date +%s)
end=$((start + MINUTES * 60))

while [ "$(date +%s)" -lt "$end" ]; do
    tmp=$(mktemp)
    echo 'begin transaction;' > "$tmp"

    count=$((RANDOM % T + 1))

    for x in $(seq 1 "$count"); do
        p=$((RANDOM % 100))

        if [ "$p" -lt "$I" ]; then
            sql=$(gen I)
            INS=$((INS + 1))
        elif [ "$p" -lt $((I + U)) ]; then
            sql=$(gen U)
            UPD=$((UPD + 1))
        else
            sql='delete from customer_notes where note_id=0;\p\g'
            DELC=$((DELC + 1))
        fi

        echo "$sql" >> "$tmp"
        EXEC=$((EXEC + 1))
    done

    if [ $((RANDOM % 100)) -lt "$F" ]; then
        echo 'update customers set badcol=1 where customer_id=1;\p\g' >> "$tmp"
    fi

    outcome=commit
    if [ $((RANDOM % 100)) -lt "$R" ]; then
        outcome=rollback
    fi

    echo "$outcome;\p\g" >> "$tmp"
    sql "$DB" < "$tmp" >> "$LOG" 2>&1
    rc=$?
    rm -f "$tmp"

    TXNS=$((TXNS + 1))
    if [ "$outcome" = commit ]; then
        COM=$((COM + 1))
    else
        ROL=$((ROL + 1))
    fi

    if [ "$rc" -ne 0 ]; then
        ERR=$((ERR + 1))
    fi

    if [ $((TXNS % 50)) -eq 0 ]; then
        echo "TXN=$TXNS SQL=$EXEC I=$INS U=$UPD D=$DELC COM=$COM ROL=$ROL ERR=$ERR" | tee -a "$LOG"
    fi

    sleep "$DELAY"
done

echo "COMPLETE TXN=$TXNS SQL=$EXEC" | tee -a "$LOG"
