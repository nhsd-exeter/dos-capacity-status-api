#!/bin/bash -e

#PROJECT_DIR=${PROJECT_DIR-.}
PROJECT_DIR="../.."

DB_HOST=${DOS_DB_HOST}
DB_PORT=${DOS_DB_PORT}
DB_NAME=${DOS_DB_NAME}
DB_USERNAME=${DOS_DB_USERNAME}
DB_PASSWORD=${DOS_DB_PASSWORD}

tables=(services servicecapacities capacitystatuses)
count=1
for table in ${tables[@]}; do
    echo "Export '$table' table to 'data/sql/04-${count}-data-$table-table.sql'"
    PGPASSWORD=$DOS_DB_PASSWORD pg_dump \
        --host=$DOS_DB_HOST \
        --port=$DOS_DB_PORT \
        --dbname=$DOS_DB_NAME \
        --username=$DOS_DB_USERNAME \
        --data-only \
        --column-inserts \
        --table=$table \
    > $PROJECT_DIR/data/sql/04-${count}-data-$table-table.sql
    let count=count+1
done
