#!/bin/bash

ENV_FILE="$(dirname "$0")/.env"
source "$ENV_FILE"

NETWORK_NAME="shvirtd-example-python_backend"
BACKUP_DIR="/opt/backup"

# Создаем папку с sudo, если нет прав
sudo mkdir -p "$BACKUP_DIR"
sudo chown $(whoami):$(whoami) "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql.gz"

docker run --rm \
    --network "$NETWORK_NAME" \
    -v "$BACKUP_DIR:/backup" \
    -e MYSQL_HOST="db" \
    -e MYSQL_USER="$MYSQL_USER" \
    -e MYSQL_PASSWORD="$MYSQL_PASSWORD" \
    -e MYSQL_DATABASE="$MYSQL_DATABASE" \
    schnitzler/mysqldump \
    sh -c "/usr/bin/mysqldump --opt -h db -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}" | gzip > "$BACKUP_FILE"


BACKUP_COUNT=$(find "$BACKUP_DIR" -name "backup_*.sql.gz" | wc -l)
if [ $BACKUP_COUNT -ge 10 ]; then
    OLDEST_BACKUP=$(ls -t "$BACKUP_DIR"/backup_*.sql.gz | tail -1)
    rm -f "$OLDEST_BACKUP"
fi
exit 0