#!/bin/bash -e

#PROJECT_DIR=${PROJECT_DIR-.}
PROJECT_DIR="../.."

DB_HOST=${DB_DOS_HOST}
DB_PORT=${DB_DOS_PORT}
DB_NAME=${DB_DOS_NAME}
DB_USERNAME=${DB_DOS_USERNAME}
DB_PASSWORD=${DB_DOS_PASSWORD}

echo "Export database schema to 'data/sql/02-database-schema.sql'"
PGPASSWORD=$DB_DOS_PASSWORD pg_dump \
    --host=$DB_DOS_HOST \
    --port=$DB_DOS_PORT \
    --dbname=$DB_DOS_NAME \
    --username=$DB_DOS_USERNAME \
    --no-tablespaces \
    --schema-only | \
        sed "s/CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;/-- CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;/g" | \
        sed "s/COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';/-- COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';/g" | \
        sed "s/GRANT ALL ON FUNCTION pgagent.pga_exception_trigger() TO pgagent_executor;/-- GRANT ALL ON FUNCTION pgagent.pga_exception_trigger() TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON FUNCTION pgagent.pga_is_leap_year(smallint) TO pgagent_executor;/-- GRANT ALL ON FUNCTION pgagent.pga_is_leap_year(smallint) TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON FUNCTION pgagent.pga_job_trigger() TO pgagent_executor;/-- GRANT ALL ON FUNCTION pgagent.pga_job_trigger() TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON FUNCTION pgagent.pga_next_schedule(integer, timestamp with time zone, timestamp with time zone, boolean\[\], boolean\[\], boolean\[\], boolean\[\], boolean\[\]) TO pgagent_executor;/-- GRANT ALL ON FUNCTION pgagent.pga_next_schedule(integer, timestamp with time zone, timestamp with time zone, boolean\[\], boolean\[\], boolean\[\], boolean\[\], boolean\[\]) TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON FUNCTION pgagent.pga_schedule_trigger() TO pgagent_executor;/-- GRANT ALL ON FUNCTION pgagent.pga_schedule_trigger() TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON FUNCTION pgagent.pgagent_schema_version() TO pgagent_executor;/-- GRANT ALL ON FUNCTION pgagent.pgagent_schema_version() TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_exception TO pgagent_executor;/-- GRANT ALL ON TABLE pgagent.pga_exception TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_exception TO release_manager;/-- GRANT ALL ON TABLE pgagent.pga_exception TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_exception_jexid_seq TO release_manager;/-- GRANT ALL ON SEQUENCE pgagent.pga_exception_jexid_seq TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_exception_jexid_seq TO pgagent_executor;/-- GRANT ALL ON SEQUENCE pgagent.pga_exception_jexid_seq TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_job TO pgagent_executor;/-- GRANT ALL ON TABLE pgagent.pga_job TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_job TO release_manager;/-- GRANT ALL ON TABLE pgagent.pga_job TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_job_jobid_seq TO release_manager;/-- GRANT ALL ON SEQUENCE pgagent.pga_job_jobid_seq TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_job_jobid_seq TO pgagent_executor;/-- GRANT ALL ON SEQUENCE pgagent.pga_job_jobid_seq TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_jobagent TO pgagent_executor;/-- GRANT ALL ON TABLE pgagent.pga_jobagent TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_jobagent TO release_manager;/-- GRANT ALL ON TABLE pgagent.pga_jobagent TO release_manager;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_jobclass TO pgagent_executor;/-- GRANT ALL ON TABLE pgagent.pga_jobclass TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_jobclass TO release_manager;/-- GRANT ALL ON TABLE pgagent.pga_jobclass TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_jobclass_jclid_seq TO release_manager;/-- GRANT ALL ON SEQUENCE pgagent.pga_jobclass_jclid_seq TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_jobclass_jclid_seq TO pgagent_executor;/-- GRANT ALL ON SEQUENCE pgagent.pga_jobclass_jclid_seq TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_joblog TO pgagent_executor;/-- GRANT ALL ON TABLE pgagent.pga_joblog TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_joblog TO release_manager;/-- GRANT ALL ON TABLE pgagent.pga_joblog TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_joblog_jlgid_seq TO release_manager;/-- GRANT ALL ON SEQUENCE pgagent.pga_joblog_jlgid_seq TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_joblog_jlgid_seq TO pgagent_executor;/-- GRANT ALL ON SEQUENCE pgagent.pga_joblog_jlgid_seq TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_jobstep TO pgagent_executor;/-- GRANT ALL ON TABLE pgagent.pga_jobstep TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_jobstep TO release_manager;/-- GRANT ALL ON TABLE pgagent.pga_jobstep TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_jobstep_jstid_seq TO release_manager;/-- GRANT ALL ON SEQUENCE pgagent.pga_jobstep_jstid_seq TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_jobstep_jstid_seq TO pgagent_executor;/-- GRANT ALL ON SEQUENCE pgagent.pga_jobstep_jstid_seq TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_jobsteplog TO pgagent_executor;/-- GRANT ALL ON TABLE pgagent.pga_jobsteplog TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_jobsteplog TO release_manager;/-- GRANT ALL ON TABLE pgagent.pga_jobsteplog TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_jobsteplog_jslid_seq TO release_manager;/-- GRANT ALL ON SEQUENCE pgagent.pga_jobsteplog_jslid_seq TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_jobsteplog_jslid_seq TO pgagent_executor;/-- GRANT ALL ON SEQUENCE pgagent.pga_jobsteplog_jslid_seq TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_schedule TO pgagent_executor;/-- GRANT ALL ON TABLE pgagent.pga_schedule TO pgagent_executor;/g" | \
        sed "s/GRANT ALL ON TABLE pgagent.pga_schedule TO release_manager;/-- GRANT ALL ON TABLE pgagent.pga_schedule TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_schedule_jscid_seq TO release_manager;/-- GRANT ALL ON SEQUENCE pgagent.pga_schedule_jscid_seq TO release_manager;/g" | \
        sed "s/GRANT ALL ON SEQUENCE pgagent.pga_schedule_jscid_seq TO pgagent_executor;/-- GRANT ALL ON SEQUENCE pgagent.pga_schedule_jscid_seq TO pgagent_executor;/g" \
> $PROJECT_DIR/data/sql/02-database-schema.sql
