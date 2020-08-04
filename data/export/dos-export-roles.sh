#!/bin/bash -e

#PROJECT_DIR=${PROJECT_DIR-.}
PROJECT_DIR="../.."

DB_HOST=${DB_DOS_HOST}
DB_PORT=${DB_DOS_PORT}
DB_NAME=${DB_DOS_NAME}
DB_USERNAME=${DB_DOS_USERNAME}
DB_PASSWORD=${DB_DOS_PASSWORD}

echo "Export database schema to 'data/sql/01-roles-schema.sql'"
PGPASSWORD=$DB_DOS_PASSWORD pg_dumpall \
    --host=$DB_DOS_HOST \
    --port=$DB_DOS_PORT \
    --username=$DB_DOS_USERNAME \
    --roles-only | \
        sed "s/CREATE ROLE postgres;//g" \
> $PROJECT_DIR/data/sql/01-roles-schema.sql
