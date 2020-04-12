#!/bin/bash -ex

DB_HOST=${SERVICE_DB_HOST}
DB_PORT=${SERVICE_DB_PORT}
DB_NAME=${SERVICE_DB_NAME}
DB_USERNAME=${SERVICE_DB_USERNAME}
DB_PASSWORD=${SERVICE_DB_PASSWORD}

psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/01-roles-schema.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/02-database-schema.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/03-data-preload.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/04-1-data-services-table-100-safe.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/04-2-data-servicecapacities-table-100-safe.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/04-3-data-capacitystatuses-table.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/04-4-data-short-permissions-table.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/04-5-data-test-user-tables.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/05-data-postload-100-safe.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/06-create_initial_user_mngt_db.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/07-create_test_user.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/08-create_inactive_test_user.sql
psql "postgres://$DB_USERNAME:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME" -f data/aws-rds-sql/09-assign_inactive_service_to_test_user.sql
