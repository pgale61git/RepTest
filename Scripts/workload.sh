#!/bin/bash

# This script generates a workload against an Ingres database. 
# It randomly performs inserts, updates, and deletes on various tables in the database. 
# The workload can be customized using command-line options.



DB=''
SPM=1000
MINUTES=10
TGT=""
I=35
U=50
D=15
R=10
F=1
T=5
USER=""

while getopts c:d:s:m:i:u:x:r:f:t:U:h o; do
    case $o in
        c) TGT=$OPTARG ;;        # Target db - if provided script will check for success of replication.
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
        U) USER="-u$OPTARG" ;;      # User name for database connection
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
TBL=""
KEY=""
SQL=""
WHERE=""

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
                TBL=customer
                KEY=$((20000000 + EXEC))
                WHERE="customer_id=$KEY"
                SQL="insert into customer values($KEY,1,'A','B',1,1,'today','now','Y',0);\p\g"
            else
                TBL=customer
                KEY=$((RANDOM % 10000 + 1))
                WHERE="customer_id=$KEY"
                SQL="update customer set balance=balance+1 where customer_id=$KEY;\p\g"
            fi
            ;;
        order)
            if [ "$op" = I ]; then
                TBL=order
                KEY=$((20000000 + EXEC))
                WHERE="order_id=$KEY"
                SQL="insert into order values($KEY,1,'today','now','NEW',1,0);\p\g"
            else
                TBL=order
                KEY=$((RANDOM % 100000 + 1))
                WHERE="order_id=$KEY"
                SQL="update order set total_amount=total_amount+1 where order_id=$KEY;\p\g"
            fi
            ;;
        inventory)
            TBL=inventory
            KEY=$((RANDOM % 20000 + 1))
            WHERE="inventory_id=$KEY"
            SQL="update inventory set quantity=quantity+1 where inventory_id=$KEY;\p\g"
            ;;
        product)
            TBL=product
            KEY=$((RANDOM % 5000 + 1))
            WHERE="product_id=$KEY"
            SQL="update product set unit_price=unit_price+1 where product_id=$KEY;\p\g"
            ;;
        datatype_test)
            TBL=datatype_test
            KEY=$((RANDOM % 20000 + 1))
            WHERE="datatype_test_id=$KEY"
            SQL="update datatype_test set c_integer=c_integer+1,c_timestamp='now' where datatype_test_id=$KEY;\p\g"
            ;;
        *)
            TBL=$tbl
            KEY=$((RANDOM % ${rows[$tbl]} + 1))
            WHERE="${tbl}_id=$KEY"
            SQL="update $tbl set upd_col=upd_col+1 where ${tbl}_id=$KEY;\p\g"
            ;;
    esac
}

start=$(date +%s)
end=$((start + MINUTES * 60))

echo "$(date +'%H:%M:%S') STARTING WORKLOAD: DB=$DB TGT=$TGT SPM=$SPM MINUTES=$MINUTES I=$I U=$U D=$D R=$R F=$F T=$T DELAY=$DELAY" | tee -a "$LOG"
echo LOG=$LOG

while [ "$(date +%s)" -lt "$end" ]; do
    tmp=$(mktemp)
    echo 'begin transaction;' > "$tmp"

    count=$((RANDOM % T + 1))

    for x in $(seq 1 "$count"); do
        p=$((RANDOM % 100))

        if [ "$p" -lt "$I" ]; then
            gen I
            INS=$((INS + 1))
        elif [ "$p" -lt $((I + U)) ]; then
            gen U
            UPD=$((UPD + 1))
        else
            TBL=customer_note
            KEY=$((RANDOM % 50000 + 1))
            WHERE="customer_note_id=$KEY"
            SQL="delete from customer_note where customer_note_id=$KEY;\p\g"
            DELC=$((DELC + 1))
        fi

        echo "$SQL" >> "$tmp"
        EXEC=$((EXEC + 1))
    done

    if [ $((RANDOM % 100)) -lt "$F" ]; then
        KEY=$((RANDOM % 10000 + 1))
		TBL=customer
        WHERE="customer_id=$KEY"
        SQL="update customer set active_flag='Y' where customer_id=$KEY;\p\g"
        echo "$SQL" >> "$tmp"
        UPD=$((UPD + 1))
    fi

    outcome=commit
    if [ $((RANDOM % 100)) -lt "$R" ]; then
        outcome=rollback
    fi

    echo "$outcome;\p\g" >> "$tmp"
    sql $USER "$DB" < "$tmp" >> "$LOG" 2>&1
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

echo "$(date +'%H:%M:%S') COMPLETE TXN=$TXNS SQL=$EXEC LAST SQL=$SQL" | tee -a "$LOG"

if [ -n "$TGT" ]; then
    echo "==============================="
    echo "Checking replication to $TGT by examining result of last SQL statement executed on $DB"
    SEL="SELECT * FROM $TBL WHERE $WHERE\p\g"
    echo "SELECT statement to check replication: $SEL"
    while true
    do
        echo "Source : $DB"
        sql -S $USER "$DB" << ! > /var/tmp/src_result.txt
        \vert
        $SEL
!

        sql -S $USER "$TGT" << ! > /var/tmp/tgt_result.txt
        \vert
        $SEL
!
        echo "----------------------------------------------------------------"
        paste /var/tmp/src_result.txt /var/tmp/tgt_result.txt |grep :|grep -v '\*\*'|column -t
        echo "----------------------------------------------------------------"
        diff -y --suppress-common-lines /var/tmp/src_result.txt /var/tmp/tgt_result.txt
        if [ $? -eq 0 ]; then
            echo "Replication check PASSED"
            break
        else
            echo "Replication check FAILED"
            sleep 2
        fi
    done
fi

