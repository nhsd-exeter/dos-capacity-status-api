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

CREATE ROLE uec_dos_api_cs_role;
ALTER ROLE uec_dos_api_cs WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'uec_dos_api_cs_role';
COMMENT ON ROLE uec_dos_api_cs IS 'Accessor role for the DoS Capacity Status API.';

-- User Configurations
--

ALTER ROLE CREATE ROLE uec_dos_api_cs_role; SET search_path TO 'pathwaysdos';

-- Grant table permissions

GRANT SELECT, UPDATE ON pathwaysdos.servicecapacities TO uec_dos_api_cs_role;

GRANT SELECT ON pathwaysdos.users TO uec_dos_api_cs_role;
GRANT SELECT ON pathwaysdos.userpermissions TO uec_dos_api_cs_role;
GRANT SELECT ON pathwaysdos.userservices TO uec_dos_api_cs_role;
GRANT SELECT ON pathwaysdos.capacitystatuses TO uec_dos_api_cs_role;
GRANT SELECT ON pathwaysdos.services TO uec_dos_api_cs_role;
