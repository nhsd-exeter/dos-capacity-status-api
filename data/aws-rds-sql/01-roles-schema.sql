--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE pathwaysdos;
ALTER ROLE pathwaysdos INHERIT NOCREATEROLE NOCREATEDB LOGIN NOBYPASSRLS PASSWORD 'md504e48453245388110ee238a8bc47daa7';
COMMENT ON ROLE pathwaysdos IS 'Accessor role for Pathways DoS application.';
CREATE ROLE pathwaysdos_auth_grp;
ALTER ROLE pathwaysdos_auth_grp INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOBYPASSRLS;
COMMENT ON ROLE pathwaysdos_auth_grp IS 'Group role for Pathways DoS authentication';
CREATE ROLE pathwaysdos_read_grp;
ALTER ROLE pathwaysdos_read_grp INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOBYPASSRLS;
COMMENT ON ROLE pathwaysdos_read_grp IS 'Group role for Pathways DoS application read privileges';
CREATE ROLE pathwaysdos_write_grp;
ALTER ROLE pathwaysdos_write_grp INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOBYPASSRLS;
COMMENT ON ROLE pathwaysdos_write_grp IS 'Group role for Pathways DoS application write privileges';
CREATE ROLE release_manager;
ALTER ROLE release_manager INHERIT NOCREATEROLE NOCREATEDB LOGIN NOBYPASSRLS PASSWORD 'md51b492a1900e707d9434d096aefa6d78e';
COMMENT ON ROLE release_manager IS 'Release manager role to own all applications database objects.';
--
-- User Configurations
--

--
-- User Config "pathwaysdos"
--

 ALTER ROLE pathwaysdos SET search_path TO 'pathwaysdos', 'extn_pgcrypto';

--
-- User Config "release_manager"
--

ALTER ROLE release_manager SET search_path TO 'pathwaysdos';

--
-- PostgreSQL database cluster dump complete
--
