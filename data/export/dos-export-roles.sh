#!/bin/bash -e

#PROJECT_DIR=${PROJECT_DIR-.}
PROJECT_DIR="../.."

DB_HOST=${DOS_DB_HOST}
DB_PORT=${DOS_DB_PORT}
DB_NAME=${DOS_DB_NAME}
DB_USERNAME=${DOS_DB_USERNAME}
DB_PASSWORD=${DOS_DB_PASSWORD}

echo "Export database schema to 'data/sql/01-roles-schema.sql'"
PGPASSWORD=$DOS_DB_PASSWORD pg_dumpall \
    --host=$DOS_DB_HOST \
    --port=$DOS_DB_PORT \
    --username=$DOS_DB_USERNAME \
    --roles-only | \
        sed "s/CREATE ROLE postgres;//g" \
> $PROJECT_DIR/data/sql/01-roles-schema.sql
