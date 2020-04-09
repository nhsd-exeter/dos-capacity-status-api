--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.15
-- Dumped by pg_dump version 12.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: capacitystatuses; Type: TABLE DATA; Schema: pathwaysdos; Owner: release_manager
--

INSERT INTO pathwaysdos.capacitystatuses (capacitystatusid, color) VALUES (1, 'GREEN');
INSERT INTO pathwaysdos.capacitystatuses (capacitystatusid, color) VALUES (2, 'AMBER');
INSERT INTO pathwaysdos.capacitystatuses (capacitystatusid, color) VALUES (3, 'RED');


--
-- Name: capacitystatuses_capacitystatusid_seq; Type: SEQUENCE SET; Schema: pathwaysdos; Owner: release_manager
--

SELECT pg_catalog.setval('pathwaysdos.capacitystatuses_capacitystatusid_seq', 33, true);


--
-- PostgreSQL database dump complete
--

