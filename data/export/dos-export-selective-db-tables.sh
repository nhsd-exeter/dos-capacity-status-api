#!/bin/bash -e

#PROJECT_DIR=${PROJECT_DIR-.}
PROJECT_DIR="../.."

DB_HOST=${DB_DOS_HOST}
DB_PORT=${DB_DOS_PORT}
DB_NAME=${DB_DOS_NAME}
DB_USERNAME=${DB_DOS_USERNAME}
DB_PASSWORD=${DB_DOS_PASSWORD}

tables=(services servicecapacities capacitystatuses)
count=1
for table in ${tables[@]}; do
    echo "Export '$table' table to 'data/sql/04-${count}-data-$table-table.sql'"
    PGPASSWORD=$DB_DOS_PASSWORD pg_dump \
        --host=$DB_DOS_HOST \
        --port=$DB_DOS_PORT \
        --dbname=$DB_DOS_NAME \
        --username=$DB_DOS_USERNAME \
        --data-only \
        --column-inserts \
        --table=$table \
    > $PROJECT_DIR/data/sql/04-${count}-data-$table-table.sql
    let count=count+1
done
