--
-- This script will create a role that the Capacity Status API will use to connect to
-- the DoS database. The role will consist of the minmimum amount of priviledges required
-- in order for the API to retrieve and update the capacity status information of a
-- service.
--
SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--
CREATE ROLE capacity_status_api;
ALTER ROLE capacity_status_api INHERIT NOCREATEROLE NOCREATEDB LOGIN NOBYPASSRLS PASSWORD 'capacity_status_api';
COMMENT ON ROLE capacity_status_api IS 'Accessor role to the DoS DB for the DoS Capacity Status API.';

-- User Configurations
--
ALTER ROLE capacity_status_api SET search_path TO 'pathwaysdos';

-- Grant usage of schema
GRANT USAGE ON SCHEMA pathwaysdos TO capacity_status_api;

-- Grant specific table permissions
GRANT SELECT, UPDATE ON pathwaysdos.servicecapacities TO capacity_status_api;

GRANT SELECT ON pathwaysdos.users TO capacity_status_api;
GRANT SELECT ON pathwaysdos.userpermissions TO capacity_status_api;
GRANT SELECT ON pathwaysdos.userservices TO capacity_status_api;
GRANT SELECT ON pathwaysdos.capacitystatuses TO capacity_status_api;
GRANT SELECT ON pathwaysdos.services TO capacity_status_api;
