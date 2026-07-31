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

while getopts d:s:m:i:u:x:r:f:t:h o; do
    case $o in
        d) DB=$OPTARG ;;        # Database name
        s) SPM=$OPTARG ;;       # SQL statements per minute. Very approx. Sets the delay between transactions.
        m) MINUTES=$OPTARG ;;   # Number of minutes to run the workload
        i) I=$OPTARG ;;         # Percentage of inserts
        u) U=$OPTARG ;;         # Percentage of updates
        x) D=$OPTARG ;;         # Percentage of deletes
        r) R=$OPTARG ;;         # Percentage of rollbacks
        f) F=$OPTARG ;;         # Percentage of "special" updates (e.g. update customer set active_flag='Y' where customer_id=...) 
        t) T=$OPTARG ;;         # Maximum number of SQL statements per transaction
        h) echo "workload.sh - Run a workload against an Ingres database" >&2
           echo "Usage: $0 [options]" >&2
           echo "Options:" >&2
           echo "  -d DB     Database name" >&2
           echo "  -s SPM    SQL statements per minute" >&2
           echo "  -m MINUTES Number of minutes to run the workload" >&2
           echo "  -i I      Percentage of inserts" >&2
           echo "  -u U      Percentage of updates" >&2
           echo "  -x D      Percentage of deletes" >&2
           echo "  -r R      Percentage of rollbacks" >&2
           echo "  -f F      Percentage of \"special\" updates" >&2
           echo "  -t T      Maximum number of SQL statements per transaction" >&2
           exit 1
           ;;
        *) echo "Invalid option: -$OPTARG" >&2
           exit 1
           ;;
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

rows[customer]=10000
rows[customer_note]=50000
rows[product]=5000
rows[inventory]=20000
rows[order]=100000
rows[order_item]=300000
rows[shipment]=50000
rows[supplier]=500
rows[purchase]=20000
rows[employee]=2000
rows[config_value]=100
rows[datatype_test]=20000
rows[regions]=20

pick() {
    local arr=(
        customer
        customer_note
        product
        inventory
        order
        order_item
        shipment
        supplier
        purchase
        employee
        config_value
        datatype_test
        region
    )

    echo "${arr[$RANDOM % ${#arr[@]}]}"
}

gen() {
    local tbl op
    tbl=$(pick)
    op=$1

    case $tbl in
        customer)
            if [ "$op" = I ]; then
                echo "insert into customer values($((20000000 + EXEC)),1,'A','B',1,1,'today','now','Y',0);\p\g"
            else
                echo "update customer set balance=balance+1 where customer_id=$((RANDOM % 10000 + 1));\p\g"
            fi
            ;;
        order)
            if [ "$op" = I ]; then
                echo "insert into order values($((20000000 + EXEC)),1,'today','now','NEW',1,0);\p\g"
            else
                echo "update order set total_amount=total_amount+1 where order_id=$((RANDOM % 100000 + 1));\p\g"
            fi
            ;;
        inventory)
            echo "update inventory set quantity=quantity+1 where inventory_id=$((RANDOM % 20000 + 1));\p\g"
            ;;
        product)
            echo "update product set unit_price=unit_price+1 where product_id=$((RANDOM % 5000 + 1));\p\g"
            ;;
        datatype_test)
            echo "update datatype_test set c_integer=c_integer+1,c_timestamp='now' where datatype_test_id=$((RANDOM % 20000 + 1));\p\g"
            ;;
        *)
            echo "update $tbl set upd_col=upd_col+1 where ${tbl}_id=$((RANDOM % ${rows[$tbl]} + 1));\p\g"
            ;;
    esac
}

start=$(date +%s)
end=$((start + MINUTES * 60))

echo "$(date +'%H:%M:%S') STARTING WORKLOAD: DB=$DB SPM=$SPM MINUTES=$MINUTES I=$I U=$U D=$D R=$R F=$F T=$T DELAY=$DELAY" | tee -a "$LOG"
echo LOG=$LOG

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
            sql='delete from customer_note where customer_note_id=0;\p\g'
            DELC=$((DELC + 1))
        fi

        echo "$sql" >> "$tmp"
        EXEC=$((EXEC + 1))
    done

    if [ $((RANDOM % 100)) -lt "$F" ]; then
        echo "update customer set active_flag='Y' where customer_id=$((RANDOM % 10000 + 1));\p\g" >> "$tmp"
        UPD=$((UPD + 1))
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

    ERR=$(grep -c E_ "$LOG")
    
    if [ $((TXNS % 50)) -eq 0 ]; then
        echo "$(date +'%H:%M:%S') TXN=$TXNS SQL=$EXEC I=$INS U=$UPD D=$DELC COM=$COM ROL=$ROL ERR=$ERR" | tee -a "$LOG"
    fi

    sleep "$DELAY"
done

echo "$(date +'%H:%M:%S') COMPLETE TXN=$TXNS SQL=$EXEC" | tee -a "$LOG"
