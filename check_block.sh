#!/bin/bash

CONTAINER_NAME="sdk-postgres-1"
LOG_FILE="./block_check.log"
DB_USER="postgres"
DB_NAME="syncer"
MAX_LINES=200

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] Checking latest block & pool counts..." >> $LOG_FILE

    docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -c \
    "SELECT * FROM block ORDER BY id DESC LIMIT 1;
     SELECT COUNT(*) AS stable_pool_count FROM stable_pool;
     SELECT COUNT(*) AS pool_v1_count FROM pool_v1;
     SELECT COUNT(*) AS pool_v2_count FROM pool_v2;" >> $LOG_FILE 2>&1

    echo "--------------------------------------------" >> $LOG_FILE

    # Giữ lại chỉ 200 dòng cuối
    tail -n $MAX_LINES $LOG_FILE > $LOG_FILE.tmp && mv $LOG_FILE.tmp $LOG_FILE

    sleep 60
done