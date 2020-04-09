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
-- Name: extn_pgcrypto; Type: SCHEMA; Schema: -; Owner: release_manager
--

CREATE SCHEMA extn_pgcrypto;


ALTER SCHEMA extn_pgcrypto OWNER TO release_manager;

--
-- Name: pathwaysdos; Type: SCHEMA; Schema: -; Owner: release_manager
--

CREATE SCHEMA pathwaysdos;


ALTER SCHEMA pathwaysdos OWNER TO release_manager;

--
-- Name: pgagent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgagent;


ALTER SCHEMA pgagent OWNER TO postgres;

--
-- Name: SCHEMA pgagent; Type: COMMENT; Schema: -; Owner: postgres
--

--COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

--COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

---CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner:
--

--COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: pageinspect; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pageinspect WITH SCHEMA public;


--
-- Name: EXTENSION pageinspect; Type: COMMENT; Schema: -; Owner:
--

--COMMENT ON EXTENSION pageinspect IS 'inspect the contents of database pages at a low level';


--
-- Name: pg_buffercache; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_buffercache WITH SCHEMA public;


--
-- Name: EXTENSION pg_buffercache; Type: COMMENT; Schema: -; Owner:
--

--COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';


--
-- Name: pg_freespacemap; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_freespacemap WITH SCHEMA public;


--
-- Name: EXTENSION pg_freespacemap; Type: COMMENT; Schema: -; Owner:
--

--COMMENT ON EXTENSION pg_freespacemap IS 'examine the free space map (FSM)';


--
-- Name: pg_prewarm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_prewarm WITH SCHEMA public;


--
-- Name: EXTENSION pg_prewarm; Type: COMMENT; Schema: -; Owner:
--

--COMMENT ON EXTENSION pg_prewarm IS 'prewarm relation data';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner:
--

--COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: pgagent; Type: EXTENSION; Schema: -; Owner: -
--

-- CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;


--
-- Name: EXTENSION pgagent; Type: COMMENT; Schema: -; Owner:
--

-- COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extn_pgcrypto;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner:
--

--COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgrowlocks; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgrowlocks WITH SCHEMA public;


--
-- Name: EXTENSION pgrowlocks; Type: COMMENT; Schema: -; Owner:
--

--COMMENT ON EXTENSION pgrowlocks IS 'show row-level locking information';


--
-- Name: pgstattuple; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgstattuple WITH SCHEMA public;


--
-- Name: EXTENSION pgstattuple; Type: COMMENT; Schema: -; Owner:
--

---COMMENT ON EXTENSION pgstattuple IS 'show tuple-level statistics';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner:
--

--COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: assignservicesuid(); Type: FUNCTION; Schema: pathwaysdos; Owner: release_manager
--

CREATE FUNCTION pathwaysdos.assignservicesuid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
   new.uid := nextval('services_uid_seq');
   return NEW;
 END;
$$;


ALTER FUNCTION pathwaysdos.assignservicesuid() OWNER TO release_manager;

--
-- Name: deletecapacitygrid(); Type: FUNCTION; Schema: pathwaysdos; Owner: release_manager
--

CREATE FUNCTION pathwaysdos.deletecapacitygrid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            BEGIN
                DELETE FROM pathwaysdos.capacityGridSheets
                WHERE capacityGridSheetId = OLD.capacityGridSheetId;
            EXCEPTION
                WHEN foreign_key_violation THEN NULL;
            END;
            RETURN NULL;
        END; $$;


ALTER FUNCTION pathwaysdos.deletecapacitygrid() OWNER TO release_manager;

--
-- Name: deletedispositiongroup(); Type: FUNCTION; Schema: pathwaysdos; Owner: release_manager
--

CREATE FUNCTION pathwaysdos.deletedispositiongroup() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            BEGIN
                DELETE FROM pathwaysdos.dispositionGroups
                WHERE id = OLD.dispositionGroupId;
            EXCEPTION
                WHEN OTHERS THEN NULL;
            END;
            RETURN NULL;
        END; $$;


ALTER FUNCTION pathwaysdos.deletedispositiongroup() OWNER TO release_manager;

--
-- Name: deletesymptomgroup(); Type: FUNCTION; Schema: pathwaysdos; Owner: release_manager
--

CREATE FUNCTION pathwaysdos.deletesymptomgroup() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            BEGIN
                DELETE FROM pathwaysdos.symptomGroups
                WHERE id = OLD.symptomGroupId;
            EXCEPTION
                WHEN foreign_key_violation THEN NULL;
            END;
            RETURN NULL;
        END; $$;


ALTER FUNCTION pathwaysdos.deletesymptomgroup() OWNER TO release_manager;

--
-- Name: upsert_pga_jobagent(); Type: FUNCTION; Schema: pgagent; Owner: postgres
--

CREATE FUNCTION pgagent.upsert_pga_jobagent() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
       existing record;
begin
     if (select EXISTS(select 1 from pgagent.pga_jobagent where jagpid  = NEW.jagpid)) then

        --found; update, and return null to prevent insert
        UPDATE pgagent.pga_jobagent SET
            jaglogintime= NEW.jaglogintime, jagstation = NEW.jagstation
         WHERE jagpid  = NEW.jagpid;

         return null;

     end if;

     return new;
end
$$;


ALTER FUNCTION pgagent.upsert_pga_jobagent() OWNER TO postgres;

--
-- Name: agegroups; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.agegroups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    fromyears integer NOT NULL,
    toyears integer NOT NULL
);


ALTER TABLE pathwaysdos.agegroups OWNER TO release_manager;

--
-- Name: capacitygridconditionalstyles; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.capacitygridconditionalstyles (
    id integer NOT NULL,
    conditionalstylename character varying(255) NOT NULL
);


ALTER TABLE pathwaysdos.capacitygridconditionalstyles OWNER TO release_manager;

--
-- Name: capacitygridconditionalstyles_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.capacitygridconditionalstyles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.capacitygridconditionalstyles_id_seq OWNER TO release_manager;

--
-- Name: capacitygridconditionalstyles_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.capacitygridconditionalstyles_id_seq OWNED BY pathwaysdos.capacitygridconditionalstyles.id;


--
-- Name: capacitygridcustomformulas; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.capacitygridcustomformulas (
    capacitygridcustomformulaid integer NOT NULL,
    capacitygridsheetid bigint NOT NULL,
    uid character varying(255) NOT NULL,
    modifiedtime timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    capacitygriddataid integer
);


ALTER TABLE pathwaysdos.capacitygridcustomformulas OWNER TO release_manager;

--
-- Name: capacitygridcustomformulas_capacitygridcustomformulaid_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.capacitygridcustomformulas_capacitygridcustomformulaid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.capacitygridcustomformulas_capacitygridcustomformulaid_seq OWNER TO release_manager;

--
-- Name: capacitygridcustomformulas_capacitygridcustomformulaid_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.capacitygridcustomformulas_capacitygridcustomformulaid_seq OWNED BY pathwaysdos.capacitygridcustomformulas.capacitygridcustomformulaid;


--
-- Name: capacitygridcustomformulastyles; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.capacitygridcustomformulastyles (
    id integer NOT NULL,
    formulaid integer,
    styleid integer
);


ALTER TABLE pathwaysdos.capacitygridcustomformulastyles OWNER TO release_manager;

--
-- Name: capacitygridcustomformulastyles_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.capacitygridcustomformulastyles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.capacitygridcustomformulastyles_id_seq OWNER TO release_manager;

--
-- Name: capacitygridcustomformulastyles_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.capacitygridcustomformulastyles_id_seq OWNED BY pathwaysdos.capacitygridcustomformulastyles.id;


--
-- Name: capacitygriddata; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.capacitygriddata (
    capacitygriddataid integer NOT NULL,
    columnid integer,
    rowid integer,
    data text,
    style character varying(255) DEFAULT NULL::character varying,
    parsed text,
    calc character varying(255) DEFAULT NULL::character varying,
    uid character varying(255) DEFAULT NULL::character varying,
    modifiedtimestamp timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    capacitygridsheetid bigint
);


ALTER TABLE pathwaysdos.capacitygriddata OWNER TO release_manager;

--
-- Name: capacitygriddata_capacitygriddataid_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.capacitygriddata_capacitygriddataid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.capacitygriddata_capacitygriddataid_seq OWNER TO release_manager;

--
-- Name: capacitygriddata_capacitygriddataid_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.capacitygriddata_capacitygriddataid_seq OWNED BY pathwaysdos.capacitygriddata.capacitygriddataid;


--
-- Name: capacitygridheaders; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.capacitygridheaders (
    capacitygridheaderid integer NOT NULL,
    uid character varying(255) DEFAULT NULL::character varying,
    columnid character varying(255) DEFAULT NULL::character varying,
    label character varying(255) DEFAULT NULL::character varying,
    width character varying(255) DEFAULT NULL::character varying,
    capacitygridsheetid bigint
);


ALTER TABLE pathwaysdos.capacitygridheaders OWNER TO release_manager;

--
-- Name: capacitygridheaders_capacitygridheaderid_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.capacitygridheaders_capacitygridheaderid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.capacitygridheaders_capacitygridheaderid_seq OWNER TO release_manager;

--
-- Name: capacitygridheaders_capacitygridheaderid_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.capacitygridheaders_capacitygridheaderid_seq OWNED BY pathwaysdos.capacitygridheaders.capacitygridheaderid;


--
-- Name: capacitygridparentsheets; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.capacitygridparentsheets (
    id integer NOT NULL,
    capacitygridparentid bigint,
    capacitygridsheetid bigint
);


ALTER TABLE pathwaysdos.capacitygridparentsheets OWNER TO release_manager;

--
-- Name: capacitygridparentsheets_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.capacitygridparentsheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.capacitygridparentsheets_id_seq OWNER TO release_manager;

--
-- Name: capacitygridparentsheets_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.capacitygridparentsheets_id_seq OWNED BY pathwaysdos.capacitygridparentsheets.id;


--
-- Name: capacitygridservicetypes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.capacitygridservicetypes (
    id integer NOT NULL,
    servicetypeid integer,
    capacitygridsheetid bigint
);


ALTER TABLE pathwaysdos.capacitygridservicetypes OWNER TO release_manager;

--
-- Name: capacitygridservicetypes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.capacitygridservicetypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.capacitygridservicetypes_id_seq OWNER TO release_manager;

--
-- Name: capacitygridservicetypes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.capacitygridservicetypes_id_seq OWNED BY pathwaysdos.capacitygridservicetypes.id;


--
-- Name: capacitygridsheethistories; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.capacitygridsheethistories (
    id integer NOT NULL,
    capacitygridsheetid bigint,
    uid character varying(255) DEFAULT NULL::character varying,
    changevalue character varying(255) DEFAULT NULL::character varying,
    username character varying(255) DEFAULT NULL::character varying,
    gridcelllastupdated timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    gridsnapshot text,
    serviceid integer
);


ALTER TABLE pathwaysdos.capacitygridsheethistories OWNER TO release_manager;

--
-- Name: capacitygridsheethistories_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.capacitygridsheethistories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.capacitygridsheethistories_id_seq OWNER TO release_manager;

--
-- Name: capacitygridsheethistories_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.capacitygridsheethistories_id_seq OWNED BY pathwaysdos.capacitygridsheethistories.id;


--
-- Name: capacitygridsheets; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.capacitygridsheets (
    capacitygridsheetid bigint NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    config character varying(255) DEFAULT NULL::character varying,
    notes character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE pathwaysdos.capacitygridsheets OWNER TO release_manager;

--
-- Name: capacitygridsheets_capacitygridsheetid_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.capacitygridsheets_capacitygridsheetid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.capacitygridsheets_capacitygridsheetid_seq OWNER TO release_manager;

--
-- Name: capacitygridsheets_capacitygridsheetid_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.capacitygridsheets_capacitygridsheetid_seq OWNED BY pathwaysdos.capacitygridsheets.capacitygridsheetid;


--
-- Name: capacitygridtriggers; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.capacitygridtriggers (
    capacitygridtriggerid integer NOT NULL,
    cmsgridid character varying(255) DEFAULT NULL::character varying,
    uid character varying(255) DEFAULT NULL::character varying,
    trigger character varying(255) DEFAULT NULL::character varying,
    source character varying(255) DEFAULT NULL::character varying,
    capacitygridsheetid bigint
);


ALTER TABLE pathwaysdos.capacitygridtriggers OWNER TO release_manager;

--
-- Name: capacitygridtriggers_capacitygridtriggerid_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.capacitygridtriggers_capacitygridtriggerid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.capacitygridtriggers_capacitygridtriggerid_seq OWNER TO release_manager;

--
-- Name: capacitygridtriggers_capacitygridtriggerid_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.capacitygridtriggers_capacitygridtriggerid_seq OWNED BY pathwaysdos.capacitygridtriggers.capacitygridtriggerid;


--
-- Name: capacitystatuses; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.capacitystatuses (
    capacitystatusid integer NOT NULL,
    color character varying(255) NOT NULL
);


ALTER TABLE pathwaysdos.capacitystatuses OWNER TO release_manager;

--
-- Name: capacitystatuses_capacitystatusid_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.capacitystatuses_capacitystatusid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.capacitystatuses_capacitystatusid_seq OWNER TO release_manager;

--
-- Name: capacitystatuses_capacitystatusid_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.capacitystatuses_capacitystatusid_seq OWNED BY pathwaysdos.capacitystatuses.capacitystatusid;


--
-- Name: changes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.changes (
    id character varying(255) NOT NULL,
    approvestatus character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    initiatorname character varying(255) NOT NULL,
    servicename character varying(255) NOT NULL,
    servicetype character varying(255) DEFAULT NULL::character varying,
    value text NOT NULL,
    createdtimestamp timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    creatorsname character varying(255) DEFAULT NULL::character varying,
    modifiedtimestamp timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    modifiersname character varying(255) DEFAULT NULL::character varying,
    serviceid integer,
    externalsystem character varying(100) DEFAULT NULL::character varying,
    externalref character varying(100) DEFAULT NULL::character varying,
    message text
);


ALTER TABLE pathwaysdos.changes OWNER TO release_manager;

--
-- Name: dispositiongroupdispositions; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.dispositiongroupdispositions (
    id integer NOT NULL,
    dispositionid integer NOT NULL,
    dispositiongroupid integer NOT NULL
);


ALTER TABLE pathwaysdos.dispositiongroupdispositions OWNER TO release_manager;

--
-- Name: dispositiongroupdispositions_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.dispositiongroupdispositions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.dispositiongroupdispositions_id_seq OWNER TO release_manager;

--
-- Name: dispositiongroupdispositions_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.dispositiongroupdispositions_id_seq OWNED BY pathwaysdos.dispositiongroupdispositions.id;


--
-- Name: dispositiongroups; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.dispositiongroups (
    id integer NOT NULL,
    uid integer NOT NULL,
    dispositiontime integer,
    defaultdos character varying(255) DEFAULT NULL::character varying,
    name character varying(255) NOT NULL
);


ALTER TABLE pathwaysdos.dispositiongroups OWNER TO release_manager;

--
-- Name: dispositiongroups_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.dispositiongroups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.dispositiongroups_id_seq OWNER TO release_manager;

--
-- Name: dispositiongroups_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.dispositiongroups_id_seq OWNED BY pathwaysdos.dispositiongroups.id;


--
-- Name: dispositiongroupservicetypes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.dispositiongroupservicetypes (
    id integer NOT NULL,
    dispositiongroupid integer NOT NULL,
    servicetypeid integer NOT NULL
);


ALTER TABLE pathwaysdos.dispositiongroupservicetypes OWNER TO release_manager;

--
-- Name: dispositiongroupservicetypes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.dispositiongroupservicetypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.dispositiongroupservicetypes_id_seq OWNER TO release_manager;

--
-- Name: dispositiongroupservicetypes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.dispositiongroupservicetypes_id_seq OWNED BY pathwaysdos.dispositiongroupservicetypes.id;


--
-- Name: dispositions; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.dispositions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    dxcode character varying(255) DEFAULT NULL::character varying,
    dispositiontime integer
);


ALTER TABLE pathwaysdos.dispositions OWNER TO release_manager;

--
-- Name: dispositions_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.dispositions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.dispositions_id_seq OWNER TO release_manager;

--
-- Name: dispositions_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.dispositions_id_seq OWNED BY pathwaysdos.dispositions.id;


--
-- Name: dispositionservicetypes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.dispositionservicetypes (
    id integer NOT NULL,
    dispositionid integer NOT NULL,
    servicetypeid integer NOT NULL
);


ALTER TABLE pathwaysdos.dispositionservicetypes OWNER TO release_manager;

--
-- Name: dispositionservicetypes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.dispositionservicetypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.dispositionservicetypes_id_seq OWNER TO release_manager;

--
-- Name: dispositionservicetypes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.dispositionservicetypes_id_seq OWNED BY pathwaysdos.dispositionservicetypes.id;


--
-- Name: genders; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.genders (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    letter character varying(1) NOT NULL
);


ALTER TABLE pathwaysdos.genders OWNER TO release_manager;

--
-- Name: genders_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.genders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.genders_id_seq OWNER TO release_manager;

--
-- Name: genders_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.genders_id_seq OWNED BY pathwaysdos.genders.id;


--
-- Name: jobqueue; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.jobqueue (
    id integer NOT NULL,
    bashcommand text NOT NULL,
    completedstatus character varying(255) DEFAULT NULL::character varying,
    completedtime timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    completedresult character varying(255) DEFAULT NULL::character varying,
    scheduledtime timestamp(0) with time zone NOT NULL,
    startedtime timestamp(0) with time zone DEFAULT NULL::timestamp with time zone
);


ALTER TABLE pathwaysdos.jobqueue OWNER TO release_manager;

--
-- Name: jobqueue_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.jobqueue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.jobqueue_id_seq OWNER TO release_manager;

--
-- Name: jobqueue_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.jobqueue_id_seq OWNED BY pathwaysdos.jobqueue.id;


--
-- Name: json_corrections; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.json_corrections (
    serviceid integer,
    old_history text,
    new_history text,
    resolved boolean
);


ALTER TABLE pathwaysdos.json_corrections OWNER TO release_manager;

--
-- Name: json_corrections_p2; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.json_corrections_p2 (
    serviceid integer,
    old_history text,
    new_history text,
    resolved boolean,
    ldap_history text,
    ldap_history_corr text,
    ldap_history_corr_resolved boolean
);


ALTER TABLE pathwaysdos.json_corrections_p2 OWNER TO release_manager;

--
-- Name: legacycollisions; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.legacycollisions (
    id integer NOT NULL,
    legacyid integer NOT NULL,
    serviceagerangeid integer NOT NULL
);


ALTER TABLE pathwaysdos.legacycollisions OWNER TO release_manager;

--
-- Name: legacycollisions_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.legacycollisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.legacycollisions_id_seq OWNER TO release_manager;

--
-- Name: legacycollisions_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.legacycollisions_id_seq OWNED BY pathwaysdos.legacycollisions.id;


--
-- Name: locations; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.locations (
    id integer NOT NULL,
    postcode character varying(255) DEFAULT NULL::character varying,
    easting integer,
    northing integer,
    postaltown character varying(255) DEFAULT NULL::character varying,
    postaladdress character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE pathwaysdos.locations OWNER TO release_manager;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.locations_id_seq OWNER TO release_manager;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.locations_id_seq OWNED BY pathwaysdos.locations.id;


--
-- Name: news; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.news (
    id integer NOT NULL,
    uid character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    detail text NOT NULL,
    creatorname character varying(255) NOT NULL,
    createtimestamp timestamp(0) with time zone DEFAULT NULL::timestamp with time zone
);


ALTER TABLE pathwaysdos.news OWNER TO release_manager;

--
-- Name: news_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.news_id_seq OWNER TO release_manager;

--
-- Name: news_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.news_id_seq OWNED BY pathwaysdos.news.id;


--
-- Name: newsacknowledgedbyusers; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.newsacknowledgedbyusers (
    id integer NOT NULL,
    newsid integer,
    userid integer
);


ALTER TABLE pathwaysdos.newsacknowledgedbyusers OWNER TO release_manager;

--
-- Name: newsacknowledgedbyusers_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.newsacknowledgedbyusers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.newsacknowledgedbyusers_id_seq OWNER TO release_manager;

--
-- Name: newsacknowledgedbyusers_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.newsacknowledgedbyusers_id_seq OWNED BY pathwaysdos.newsacknowledgedbyusers.id;


--
-- Name: newsforpermissions; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.newsforpermissions (
    id integer NOT NULL,
    newsid integer,
    permissionid integer
);


ALTER TABLE pathwaysdos.newsforpermissions OWNER TO release_manager;

--
-- Name: newsforpermissions4_16_1; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.newsforpermissions4_16_1 (
    id integer NOT NULL,
    newsid integer,
    permissionid integer
);


ALTER TABLE pathwaysdos.newsforpermissions4_16_1 OWNER TO release_manager;

--
-- Name: newsforpermissions_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.newsforpermissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.newsforpermissions_id_seq OWNER TO release_manager;

--
-- Name: newsforpermissions_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.newsforpermissions_id_seq OWNED BY pathwaysdos.newsforpermissions.id;


--
-- Name: odsimports; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.odsimports (
    id bigint NOT NULL,
    pcd2 character varying(10) NOT NULL,
    pcds character varying(10) NOT NULL,
    dointr integer,
    doterm integer,
    oseast100m numeric,
    osnrth100m numeric,
    oscty character varying(10),
    odslaua character varying(5),
    oslaua character varying(10),
    osward character varying(10),
    usertype smallint,
    osgrdind smallint,
    ctry character varying(10),
    oshlthau character varying(3),
    rgn character varying(10),
    oldha character varying(3),
    nhser character varying(3),
    ccg character varying(10) NOT NULL,
    psed character varying(10),
    cened character varying(6),
    edind character varying(1),
    ward98 character varying(6),
    oa01 character varying(10),
    nhsrlo character varying(3),
    hro character varying(3),
    lsoa01 character varying(10),
    ur01ind character varying(1),
    msoa01 character varying(10),
    cannet character varying(3),
    scn character varying(3),
    oshaprev character varying(3),
    oldpct character varying(3),
    oldhro character varying(3),
    pcon character varying(10),
    canreg character varying(5),
    pct character varying(3),
    oseast1m numeric,
    osnrth1m numeric,
    oa11 character varying(10),
    lsoa11 character varying(10),
    msoa11 character varying(10),
    calncv character varying(10),
    stp character varying(10)
);


ALTER TABLE pathwaysdos.odsimports OWNER TO release_manager;

--
-- Name: COLUMN odsimports.calncv; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.odsimports.calncv IS 'Cancer Alliance or National Cancer Vanguard identifier.';


--
-- Name: COLUMN odsimports.stp; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.odsimports.stp IS 'Sustainability and Transformation Partnership identifier.';


--
-- Name: odsimports_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.odsimports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.odsimports_id_seq OWNER TO release_manager;

--
-- Name: odsimports_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.odsimports_id_seq OWNED BY pathwaysdos.odsimports.id;


--
-- Name: odspostcodes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.odspostcodes (
    id bigint NOT NULL,
    postcode character varying(10) NOT NULL,
    orgcode character varying(10) NOT NULL,
    createdtime timestamp(0) with time zone NOT NULL,
    mappedtime timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    deletedtime timestamp(0) with time zone DEFAULT NULL::timestamp with time zone
);


ALTER TABLE pathwaysdos.odspostcodes OWNER TO release_manager;

--
-- Name: odspostcodes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.odspostcodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.odspostcodes_id_seq OWNER TO release_manager;

--
-- Name: odspostcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.odspostcodes_id_seq OWNED BY pathwaysdos.odspostcodes.id;


--
-- Name: openingtimedays; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.openingtimedays (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE pathwaysdos.openingtimedays OWNER TO release_manager;

--
-- Name: openingtimedays_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.openingtimedays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.openingtimedays_id_seq OWNER TO release_manager;

--
-- Name: openingtimedays_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.openingtimedays_id_seq OWNED BY pathwaysdos.openingtimedays.id;


--
-- Name: organisationpostcodes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.organisationpostcodes (
    id integer NOT NULL,
    locationid integer NOT NULL,
    organisationid integer NOT NULL
);


ALTER TABLE pathwaysdos.organisationpostcodes OWNER TO release_manager;

--
-- Name: organisationpostcodes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.organisationpostcodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.organisationpostcodes_id_seq OWNER TO release_manager;

--
-- Name: organisationpostcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.organisationpostcodes_id_seq OWNED BY pathwaysdos.organisationpostcodes.id;


--
-- Name: organisationrankingstrategies; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.organisationrankingstrategies (
    id integer NOT NULL,
    servicetypeid integer,
    localranking integer,
    organisationid integer NOT NULL
);


ALTER TABLE pathwaysdos.organisationrankingstrategies OWNER TO release_manager;

--
-- Name: organisationrankingstrategies_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.organisationrankingstrategies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.organisationrankingstrategies_id_seq OWNER TO release_manager;

--
-- Name: organisationrankingstrategies_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.organisationrankingstrategies_id_seq OWNED BY pathwaysdos.organisationrankingstrategies.id;


--
-- Name: organisations; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.organisations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(10) NOT NULL,
    startdate timestamp(0) with time zone NOT NULL,
    enddate timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    organisationtypeid integer NOT NULL
);


ALTER TABLE pathwaysdos.organisations OWNER TO release_manager;

--
-- Name: organisations_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.organisations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.organisations_id_seq OWNER TO release_manager;

--
-- Name: organisations_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.organisations_id_seq OWNED BY pathwaysdos.organisations.id;


--
-- Name: organisationtypes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.organisationtypes (
    id integer NOT NULL,
    name text
);


ALTER TABLE pathwaysdos.organisationtypes OWNER TO release_manager;

--
-- Name: organisationtypes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.organisationtypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.organisationtypes_id_seq OWNER TO release_manager;

--
-- Name: organisationtypes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.organisationtypes_id_seq OWNED BY pathwaysdos.organisationtypes.id;


--
-- Name: permissionattributedict; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.permissionattributedict (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE pathwaysdos.permissionattributedict OWNER TO release_manager;

--
-- Name: permissionattributedict_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.permissionattributedict_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.permissionattributedict_id_seq OWNER TO release_manager;

--
-- Name: permissionattributedict_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.permissionattributedict_id_seq OWNED BY pathwaysdos.permissionattributedict.id;


--
-- Name: permissionattributes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.permissionattributes (
    id integer NOT NULL,
    permissionid integer,
    permissionattributedictid integer
);


ALTER TABLE pathwaysdos.permissionattributes OWNER TO release_manager;

--
-- Name: permissionattributes4_16_1; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.permissionattributes4_16_1 (
    id integer NOT NULL,
    permissionattributedictid integer,
    permissionid integer
);


ALTER TABLE pathwaysdos.permissionattributes4_16_1 OWNER TO release_manager;

--
-- Name: permissionattributes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.permissionattributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.permissionattributes_id_seq OWNER TO release_manager;

--
-- Name: permissionattributes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.permissionattributes_id_seq OWNED BY pathwaysdos.permissionattributes.id;


--
-- Name: permissions; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.permissions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) DEFAULT NULL::character varying,
    functionalarea character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE pathwaysdos.permissions OWNER TO release_manager;

--
-- Name: permissions4_16_1; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.permissions4_16_1 (
    id integer NOT NULL,
    name character varying(255),
    type character varying(255),
    functionalarea character varying(255)
);


ALTER TABLE pathwaysdos.permissions4_16_1 OWNER TO release_manager;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.permissions_id_seq OWNER TO release_manager;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.permissions_id_seq OWNED BY pathwaysdos.permissions.id;


--
-- Name: publicholidays; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.publicholidays (
    id integer NOT NULL,
    holidaydate timestamp with time zone,
    description character varying(100) DEFAULT NULL::character varying
);


ALTER TABLE pathwaysdos.publicholidays OWNER TO release_manager;

--
-- Name: TABLE publicholidays; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON TABLE pathwaysdos.publicholidays IS 'Public holidays in England.';


--
-- Name: COLUMN publicholidays.id; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.publicholidays.id IS 'Identifier for public holidays.';


--
-- Name: COLUMN publicholidays.holidaydate; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.publicholidays.holidaydate IS 'Date of public holiday.';


--
-- Name: COLUMN publicholidays.description; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.publicholidays.description IS 'Narrative for public holiday, e.g. Spring Bank Holiday.';


--
-- Name: publicholidays_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.publicholidays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.publicholidays_id_seq OWNER TO release_manager;

--
-- Name: publicholidays_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.publicholidays_id_seq OWNED BY pathwaysdos.publicholidays.id;


--
-- Name: purgedusers; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.purgedusers (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    firstname character varying(255) NOT NULL,
    lastname character varying(255) NOT NULL,
    email character varying(255) DEFAULT NULL::character varying,
    password character varying(255) DEFAULT NULL::character varying,
    badpasswordcount integer,
    badpasswordtime timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    phone character varying(255) DEFAULT NULL::character varying,
    status character varying(255) DEFAULT NULL::character varying,
    createdtime timestamp(0) with time zone NOT NULL,
    lastlogintime timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    homeorganisation character varying(255) DEFAULT NULL::character varying,
    accessreason text,
    approvedby character varying(255) DEFAULT NULL::character varying,
    approveddate timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    validationtoken character varying(255) DEFAULT NULL::character varying,
    purgeddate timestamp(0) with time zone NOT NULL
);


ALTER TABLE pathwaysdos.purgedusers OWNER TO release_manager;

--
-- Name: referralroles; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.referralroles (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE pathwaysdos.referralroles OWNER TO release_manager;

--
-- Name: report_nhs_choices; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.report_nhs_choices (
    id character varying(255),
    name text,
    type character varying(255),
    status character varying(255),
    address text,
    postcode character varying(255),
    publicphone character varying(255),
    fax character varying(255),
    url character varying(512),
    openallhours text,
    monday text,
    tuesday text,
    wednesday text,
    thursday text,
    friday text,
    saturday text,
    sunday text,
    bankholiday text,
    bankholidayspecifiedtimes text,
    patientagegroups text,
    servicetypeid character varying(255)
);


ALTER TABLE pathwaysdos.report_nhs_choices OWNER TO release_manager;

--
-- Name: savedsearches; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.savedsearches (
    id integer NOT NULL,
    params text NOT NULL,
    isshared boolean DEFAULT false NOT NULL
);


ALTER TABLE pathwaysdos.savedsearches OWNER TO release_manager;

--
-- Name: savedsearches_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.savedsearches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.savedsearches_id_seq OWNER TO release_manager;

--
-- Name: savedsearches_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.savedsearches_id_seq OWNED BY pathwaysdos.savedsearches.id;


--
-- Name: searchdistances; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.searchdistances (
    id bigint NOT NULL,
    code character varying(10) NOT NULL,
    radius numeric(3,1) NOT NULL
);


ALTER TABLE pathwaysdos.searchdistances OWNER TO release_manager;

--
-- Name: TABLE searchdistances; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON TABLE pathwaysdos.searchdistances IS 'Search radius distances used by search algorithms.';


--
-- Name: COLUMN searchdistances.id; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.searchdistances.id IS 'Identifier for search distances.';


--
-- Name: COLUMN searchdistances.code; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.searchdistances.code IS 'Full postcode, sector code, or outcode assigned a search radius.';


--
-- Name: COLUMN searchdistances.radius; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.searchdistances.radius IS 'Radius in kilometres used by search algorithms.';


--
-- Name: searchdistances_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.searchdistances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.searchdistances_id_seq OWNER TO release_manager;

--
-- Name: searchdistances_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.searchdistances_id_seq OWNED BY pathwaysdos.searchdistances.id;


--
-- Name: searchimports; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.searchimports (
    id bigint NOT NULL,
    code character varying(10) NOT NULL,
    radius numeric(3,1) NOT NULL
);


ALTER TABLE pathwaysdos.searchimports OWNER TO release_manager;

--
-- Name: TABLE searchimports; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON TABLE pathwaysdos.searchimports IS 'Staging table used to import search distances.  Always truncated prior to import.';


--
-- Name: COLUMN searchimports.id; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.searchimports.id IS 'Identifier for search imports.';


--
-- Name: COLUMN searchimports.code; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.searchimports.code IS 'Full postcode, sector code, or outcode assigned a search radius.';


--
-- Name: COLUMN searchimports.radius; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.searchimports.radius IS 'Radius in kilometres used by search algorithm.';


--
-- Name: searchimports_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.searchimports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.searchimports_id_seq OWNER TO release_manager;

--
-- Name: searchimports_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.searchimports_id_seq OWNED BY pathwaysdos.searchimports.id;


--
-- Name: serviceagegroups; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.serviceagegroups (
    id integer NOT NULL,
    serviceid integer NOT NULL,
    agegroupid integer NOT NULL
);


ALTER TABLE pathwaysdos.serviceagegroups OWNER TO release_manager;

--
-- Name: serviceagegroups_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.serviceagegroups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.serviceagegroups_id_seq OWNER TO release_manager;

--
-- Name: serviceagegroups_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.serviceagegroups_id_seq OWNED BY pathwaysdos.serviceagegroups.id;


--
-- Name: serviceagerange; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.serviceagerange (
    id integer NOT NULL,
    daysfrom double precision NOT NULL,
    daysto double precision NOT NULL,
    serviceid integer NOT NULL
);


ALTER TABLE pathwaysdos.serviceagerange OWNER TO release_manager;

--
-- Name: serviceagerange_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.serviceagerange_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.serviceagerange_id_seq OWNER TO release_manager;

--
-- Name: serviceagerange_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.serviceagerange_id_seq OWNED BY pathwaysdos.serviceagerange.id;


--
-- Name: servicealignments; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicealignments (
    id bigint NOT NULL,
    serviceid integer NOT NULL,
    commissioningorganisationid integer NOT NULL,
    islimited boolean,
    CONSTRAINT servicealignments_chk1 CHECK (((serviceid <> commissioningorganisationid) OR (serviceid IS NULL) OR (commissioningorganisationid IS NULL)))
);


ALTER TABLE pathwaysdos.servicealignments OWNER TO release_manager;

--
-- Name: servicealignments_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicealignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicealignments_id_seq OWNER TO release_manager;

--
-- Name: servicealignments_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicealignments_id_seq OWNED BY pathwaysdos.servicealignments.id;


--
-- Name: serviceattributes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.serviceattributes (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255),
    serviceattributetypeid integer NOT NULL,
    status boolean NOT NULL,
    createddatetime timestamp with time zone NOT NULL,
    createduserid integer NOT NULL,
    modifieddatetime timestamp with time zone NOT NULL,
    modifieduserid integer NOT NULL
);


ALTER TABLE pathwaysdos.serviceattributes OWNER TO release_manager;

--
-- Name: serviceattributes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.serviceattributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.serviceattributes_id_seq OWNER TO release_manager;

--
-- Name: serviceattributes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.serviceattributes_id_seq OWNED BY pathwaysdos.serviceattributes.id;


--
-- Name: serviceattributetypes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.serviceattributetypes (
    id integer NOT NULL,
    type character varying(50) NOT NULL,
    description character varying(255),
    typevaluesjson character varying(255)
);


ALTER TABLE pathwaysdos.serviceattributetypes OWNER TO release_manager;

--
-- Name: serviceattributetypes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.serviceattributetypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.serviceattributetypes_id_seq OWNER TO release_manager;

--
-- Name: serviceattributetypes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.serviceattributetypes_id_seq OWNED BY pathwaysdos.serviceattributetypes.id;


--
-- Name: serviceattributevalues; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.serviceattributevalues (
    id integer NOT NULL,
    serviceattributeid integer NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE pathwaysdos.serviceattributevalues OWNER TO release_manager;

--
-- Name: serviceattributevalues_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.serviceattributevalues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.serviceattributevalues_id_seq OWNER TO release_manager;

--
-- Name: serviceattributevalues_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.serviceattributevalues_id_seq OWNED BY pathwaysdos.serviceattributevalues.id;


--
-- Name: servicecapacities; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicecapacities (
    id integer NOT NULL,
    notes text,
    modifiedbyid integer,
    modifiedby text,
    modifieddate timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    serviceid integer,
    capacitystatusid integer,
    resetdatetime timestamp with time zone
);


ALTER TABLE pathwaysdos.servicecapacities OWNER TO release_manager;

--
-- Name: COLUMN servicecapacities.resetdatetime; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.servicecapacities.resetdatetime IS 'Date and time after which the capacity status will be reset to Green.';


--
-- Name: servicecapacities_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicecapacities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicecapacities_id_seq OWNER TO release_manager;

--
-- Name: servicecapacities_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicecapacities_id_seq OWNED BY pathwaysdos.servicecapacities.id;


--
-- Name: servicecapacitygrids; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicecapacitygrids (
    id integer NOT NULL,
    capacitygridsheetid bigint,
    servicecapacityid integer
);


ALTER TABLE pathwaysdos.servicecapacitygrids OWNER TO release_manager;

--
-- Name: servicecapacitygrids_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicecapacitygrids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicecapacitygrids_id_seq OWNER TO release_manager;

--
-- Name: servicecapacitygrids_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicecapacitygrids_id_seq OWNED BY pathwaysdos.servicecapacitygrids.id;


--
-- Name: servicedayopenings; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicedayopenings (
    id integer NOT NULL,
    serviceid integer NOT NULL,
    dayid integer
);


ALTER TABLE pathwaysdos.servicedayopenings OWNER TO release_manager;

--
-- Name: servicedayopenings_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicedayopenings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicedayopenings_id_seq OWNER TO release_manager;

--
-- Name: servicedayopenings_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicedayopenings_id_seq OWNED BY pathwaysdos.servicedayopenings.id;


--
-- Name: servicedayopeningtimes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicedayopeningtimes (
    id integer NOT NULL,
    starttime time(0) without time zone NOT NULL,
    endtime time(0) without time zone NOT NULL,
    servicedayopeningid integer
);


ALTER TABLE pathwaysdos.servicedayopeningtimes OWNER TO release_manager;

--
-- Name: servicedayopeningtimes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicedayopeningtimes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicedayopeningtimes_id_seq OWNER TO release_manager;

--
-- Name: servicedayopeningtimes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicedayopeningtimes_id_seq OWNED BY pathwaysdos.servicedayopeningtimes.id;


--
-- Name: servicedispositions; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicedispositions (
    id integer NOT NULL,
    serviceid integer NOT NULL,
    dispositionid integer NOT NULL
);


ALTER TABLE pathwaysdos.servicedispositions OWNER TO release_manager;

--
-- Name: servicedispositions_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicedispositions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicedispositions_id_seq OWNER TO release_manager;

--
-- Name: servicedispositions_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicedispositions_id_seq OWNED BY pathwaysdos.servicedispositions.id;


--
-- Name: serviceendpoints; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.serviceendpoints (
    id integer NOT NULL,
    endpointorder integer,
    transport character varying(255) DEFAULT NULL::character varying,
    format character varying(255) DEFAULT NULL::character varying,
    interaction character varying(255) DEFAULT NULL::character varying,
    businessscenario character varying(255) DEFAULT NULL::character varying,
    address character varying(255) DEFAULT NULL::character varying,
    comment text,
    iscompressionenabled character varying(255) DEFAULT NULL::character varying,
    serviceid integer NOT NULL
);


ALTER TABLE pathwaysdos.serviceendpoints OWNER TO release_manager;

--
-- Name: serviceendpoints_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.serviceendpoints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.serviceendpoints_id_seq OWNER TO release_manager;

--
-- Name: serviceendpoints_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.serviceendpoints_id_seq OWNED BY pathwaysdos.serviceendpoints.id;


--
-- Name: servicegenders; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicegenders (
    id integer NOT NULL,
    serviceid integer,
    genderid integer
);


ALTER TABLE pathwaysdos.servicegenders OWNER TO release_manager;

--
-- Name: servicegenders_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicegenders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicegenders_id_seq OWNER TO release_manager;

--
-- Name: servicegenders_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicegenders_id_seq OWNED BY pathwaysdos.servicegenders.id;


--
-- Name: servicehistories; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicehistories (
    serviceid integer NOT NULL,
    history text NOT NULL
);


ALTER TABLE pathwaysdos.servicehistories OWNER TO release_manager;

--
-- Name: servicerankingstrategies; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicerankingstrategies (
    id integer NOT NULL,
    servicetype integer,
    localranking integer,
    serviceid integer NOT NULL
);


ALTER TABLE pathwaysdos.servicerankingstrategies OWNER TO release_manager;

--
-- Name: servicerankingstrategies_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicerankingstrategies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicerankingstrategies_id_seq OWNER TO release_manager;

--
-- Name: servicerankingstrategies_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicerankingstrategies_id_seq OWNED BY pathwaysdos.servicerankingstrategies.id;


--
-- Name: servicereferralroles; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicereferralroles (
    id integer NOT NULL,
    serviceid integer,
    referralroleid integer
);


ALTER TABLE pathwaysdos.servicereferralroles OWNER TO release_manager;

--
-- Name: servicereferralroles_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicereferralroles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicereferralroles_id_seq OWNER TO release_manager;

--
-- Name: servicereferralroles_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicereferralroles_id_seq OWNED BY pathwaysdos.servicereferralroles.id;


--
-- Name: servicereferrals; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicereferrals (
    id integer NOT NULL,
    referralserviceid integer NOT NULL,
    referredserviceid integer NOT NULL
);


ALTER TABLE pathwaysdos.servicereferrals OWNER TO release_manager;

--
-- Name: servicereferrals_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicereferrals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicereferrals_id_seq OWNER TO release_manager;

--
-- Name: servicereferrals_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicereferrals_id_seq OWNED BY pathwaysdos.servicereferrals.id;


--
-- Name: services; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.services (
    id integer NOT NULL,
    uid character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    odscode character varying(255) DEFAULT NULL::character varying,
    isnational character varying(255) DEFAULT NULL::character varying,
    openallhours boolean DEFAULT false NOT NULL,
    publicreferralinstructions text,
    telephonetriagereferralinstructions text,
    restricttoreferrals boolean DEFAULT false NOT NULL,
    address character varying(512) DEFAULT NULL::character varying,
    town character varying(255) DEFAULT NULL::character varying,
    postcode character varying(255) DEFAULT NULL::character varying,
    easting integer,
    northing integer,
    publicphone character varying(255) DEFAULT NULL::character varying,
    nonpublicphone character varying(255) DEFAULT NULL::character varying,
    fax character varying(255) DEFAULT NULL::character varying,
    email character varying(255) DEFAULT NULL::character varying,
    web character varying(512) DEFAULT NULL::character varying,
    createdby character varying(255) DEFAULT NULL::character varying,
    createdtime timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    modifiedby character varying(255) DEFAULT NULL::character varying,
    modifiedtime timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    lasttemplatename text,
    lasttemplateid integer,
    typeid integer,
    parentid integer,
    subregionid integer,
    statusid integer,
    organisationid integer,
    returnifopenminutes integer,
    publicname character varying(255)
);


ALTER TABLE pathwaysdos.services OWNER TO release_manager;

--
-- Name: COLUMN services.returnifopenminutes; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.services.returnifopenminutes IS 'The service will only return from a search if currently open or due to open within the timeframe.';


--
-- Name: COLUMN services.publicname; Type: COMMENT; Schema: pathwaysdos; Owner: release_manager
--

COMMENT ON COLUMN pathwaysdos.services.publicname IS 'The service name as it is known publically.';


--
-- Name: services_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.services_id_seq OWNER TO release_manager;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.services_id_seq OWNED BY pathwaysdos.services.id;


--
-- Name: services_uid_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.services_uid_seq
    START WITH 2000000000
    INCREMENT BY 1
    MINVALUE 2000000000
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE pathwaysdos.services_uid_seq OWNER TO release_manager;

--
-- Name: serviceserviceattributes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.serviceserviceattributes (
    id integer NOT NULL,
    serviceattributeid integer NOT NULL,
    value character varying(255),
    serviceattributevalueid integer,
    serviceid integer NOT NULL,
    priority integer
);


ALTER TABLE pathwaysdos.serviceserviceattributes OWNER TO release_manager;

--
-- Name: serviceserviceattributes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.serviceserviceattributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.serviceserviceattributes_id_seq OWNER TO release_manager;

--
-- Name: serviceserviceattributes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.serviceserviceattributes_id_seq OWNED BY pathwaysdos.serviceserviceattributes.id;


--
-- Name: servicesgsds; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicesgsds (
    id integer NOT NULL,
    serviceid integer NOT NULL,
    sdid integer NOT NULL,
    sgid integer NOT NULL
);


ALTER TABLE pathwaysdos.servicesgsds OWNER TO release_manager;

--
-- Name: servicesgsds_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicesgsds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicesgsds_id_seq OWNER TO release_manager;

--
-- Name: servicesgsds_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicesgsds_id_seq OWNED BY pathwaysdos.servicesgsds.id;


--
-- Name: servicespecifiedopeningdates; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicespecifiedopeningdates (
    id integer NOT NULL,
    date date NOT NULL,
    serviceid integer
);


ALTER TABLE pathwaysdos.servicespecifiedopeningdates OWNER TO release_manager;

--
-- Name: servicespecifiedopeningdates_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicespecifiedopeningdates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicespecifiedopeningdates_id_seq OWNER TO release_manager;

--
-- Name: servicespecifiedopeningdates_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicespecifiedopeningdates_id_seq OWNED BY pathwaysdos.servicespecifiedopeningdates.id;


--
-- Name: servicespecifiedopeningtimes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicespecifiedopeningtimes (
    id integer NOT NULL,
    starttime time(0) without time zone NOT NULL,
    endtime time(0) without time zone NOT NULL,
    isclosed boolean NOT NULL,
    servicespecifiedopeningdateid integer
);


ALTER TABLE pathwaysdos.servicespecifiedopeningtimes OWNER TO release_manager;

--
-- Name: servicespecifiedopeningtimes_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicespecifiedopeningtimes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicespecifiedopeningtimes_id_seq OWNER TO release_manager;

--
-- Name: servicespecifiedopeningtimes_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicespecifiedopeningtimes_id_seq OWNED BY pathwaysdos.servicespecifiedopeningtimes.id;


--
-- Name: servicestatuses; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicestatuses (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE pathwaysdos.servicestatuses OWNER TO release_manager;

--
-- Name: servicestatuses_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.servicestatuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.servicestatuses_id_seq OWNER TO release_manager;

--
-- Name: servicestatuses_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.servicestatuses_id_seq OWNED BY pathwaysdos.servicestatuses.id;


--
-- Name: servicetypes; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.servicetypes (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    nationalranking character varying(255) DEFAULT NULL::character varying,
    searchcapacitystatus boolean,
    capacitymodel character varying(255) DEFAULT NULL::character varying,
    capacityreset character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE pathwaysdos.servicetypes OWNER TO release_manager;

--
-- Name: srsbackup; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.srsbackup (
    id integer,
    servicetype integer,
    localranking integer,
    serviceid integer
);


ALTER TABLE pathwaysdos.srsbackup OWNER TO release_manager;

--
-- Name: symptomdiscriminators; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.symptomdiscriminators (
    id integer NOT NULL,
    description character varying(255) NOT NULL
);


ALTER TABLE pathwaysdos.symptomdiscriminators OWNER TO release_manager;

--
-- Name: symptomdiscriminatorsynonyms; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.symptomdiscriminatorsynonyms (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    symptomdiscriminatorid integer NOT NULL
);


ALTER TABLE pathwaysdos.symptomdiscriminatorsynonyms OWNER TO release_manager;

--
-- Name: symptomdiscriminatorsynonyms_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.symptomdiscriminatorsynonyms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.symptomdiscriminatorsynonyms_id_seq OWNER TO release_manager;

--
-- Name: symptomdiscriminatorsynonyms_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.symptomdiscriminatorsynonyms_id_seq OWNED BY pathwaysdos.symptomdiscriminatorsynonyms.id;


--
-- Name: symptomgroups; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.symptomgroups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    zcodeexists boolean
);


ALTER TABLE pathwaysdos.symptomgroups OWNER TO release_manager;

--
-- Name: symptomgroupsymptomdiscriminators; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.symptomgroupsymptomdiscriminators (
    id integer NOT NULL,
    symptomgroupid integer NOT NULL,
    symptomdiscriminatorid integer NOT NULL
);


ALTER TABLE pathwaysdos.symptomgroupsymptomdiscriminators OWNER TO release_manager;

--
-- Name: symptomgroupsymptomdiscriminators_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.symptomgroupsymptomdiscriminators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.symptomgroupsymptomdiscriminators_id_seq OWNER TO release_manager;

--
-- Name: symptomgroupsymptomdiscriminators_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.symptomgroupsymptomdiscriminators_id_seq OWNED BY pathwaysdos.symptomgroupsymptomdiscriminators.id;


--
-- Name: userpermissions; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.userpermissions (
    id integer NOT NULL,
    userid integer,
    permissionid integer
);


ALTER TABLE pathwaysdos.userpermissions OWNER TO release_manager;

--
-- Name: userpermissions4_16_1; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.userpermissions4_16_1 (
    id integer NOT NULL,
    userid integer,
    permissionid integer
);


ALTER TABLE pathwaysdos.userpermissions4_16_1 OWNER TO release_manager;

--
-- Name: userpermissions_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.userpermissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.userpermissions_id_seq OWNER TO release_manager;

--
-- Name: userpermissions_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.userpermissions_id_seq OWNED BY pathwaysdos.userpermissions.id;


--
-- Name: userreferralroles; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.userreferralroles (
    id integer NOT NULL,
    userid integer,
    referralroleid integer
);


ALTER TABLE pathwaysdos.userreferralroles OWNER TO release_manager;

--
-- Name: userreferralroles_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.userreferralroles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.userreferralroles_id_seq OWNER TO release_manager;

--
-- Name: userreferralroles_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.userreferralroles_id_seq OWNED BY pathwaysdos.userreferralroles.id;


--
-- Name: userregions; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.userregions (
    id integer NOT NULL,
    userid integer,
    regionid integer
);


ALTER TABLE pathwaysdos.userregions OWNER TO release_manager;

--
-- Name: userregions_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.userregions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.userregions_id_seq OWNER TO release_manager;

--
-- Name: userregions_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.userregions_id_seq OWNED BY pathwaysdos.userregions.id;


--
-- Name: users; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    firstname character varying(255) NOT NULL,
    lastname character varying(255) NOT NULL,
    email character varying(255) DEFAULT NULL::character varying,
    password character varying(255) DEFAULT NULL::character varying,
    badpasswordcount integer,
    badpasswordtime timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    phone character varying(255) DEFAULT NULL::character varying,
    status character varying(255) DEFAULT NULL::character varying,
    createdtime timestamp(0) with time zone NOT NULL,
    lastlogintime timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    homeorganisation character varying(255) DEFAULT NULL::character varying,
    accessreason text,
    approvedby character varying(255) DEFAULT NULL::character varying,
    approveddate timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    validationtoken character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE pathwaysdos.users OWNER TO release_manager;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.users_id_seq OWNER TO release_manager;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.users_id_seq OWNED BY pathwaysdos.users.id;


--
-- Name: usersavedsearches; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.usersavedsearches (
    id integer NOT NULL,
    userid integer,
    savedsearchid integer
);


ALTER TABLE pathwaysdos.usersavedsearches OWNER TO release_manager;

--
-- Name: usersavedsearches_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.usersavedsearches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.usersavedsearches_id_seq OWNER TO release_manager;

--
-- Name: usersavedsearches_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.usersavedsearches_id_seq OWNED BY pathwaysdos.usersavedsearches.id;


--
-- Name: userservices; Type: TABLE; Schema: pathwaysdos; Owner: release_manager
--

CREATE TABLE pathwaysdos.userservices (
    id integer NOT NULL,
    userid integer,
    serviceid integer
);


ALTER TABLE pathwaysdos.userservices OWNER TO release_manager;

--
-- Name: userservices_id_seq; Type: SEQUENCE; Schema: pathwaysdos; Owner: release_manager
--

CREATE SEQUENCE pathwaysdos.userservices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pathwaysdos.userservices_id_seq OWNER TO release_manager;

--
-- Name: userservices_id_seq; Type: SEQUENCE OWNED BY; Schema: pathwaysdos; Owner: release_manager
--

ALTER SEQUENCE pathwaysdos.userservices_id_seq OWNED BY pathwaysdos.userservices.id;


--
-- Name: pg_stat_statements_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pg_stat_statements_backup (
    userid oid,
    dbid oid,
    queryid bigint,
    query text,
    calls bigint,
    total_time double precision,
    min_time double precision,
    max_time double precision,
    mean_time double precision,
    stddev_time double precision,
    rows bigint,
    shared_blks_hit bigint,
    shared_blks_read bigint,
    shared_blks_dirtied bigint,
    shared_blks_written bigint,
    local_blks_hit bigint,
    local_blks_read bigint,
    local_blks_dirtied bigint,
    local_blks_written bigint,
    temp_blks_read bigint,
    temp_blks_written bigint,
    blk_read_time double precision,
    blk_write_time double precision
);


ALTER TABLE public.pg_stat_statements_backup OWNER TO postgres;

--
-- Name: pg_stat_statements_invest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pg_stat_statements_invest (
    userid oid,
    dbid oid,
    queryid bigint,
    query text,
    calls bigint,
    total_time double precision,
    min_time double precision,
    max_time double precision,
    mean_time double precision,
    stddev_time double precision,
    rows bigint,
    shared_blks_hit bigint,
    shared_blks_read bigint,
    shared_blks_dirtied bigint,
    shared_blks_written bigint,
    local_blks_hit bigint,
    local_blks_read bigint,
    local_blks_dirtied bigint,
    local_blks_written bigint,
    temp_blks_read bigint,
    temp_blks_written bigint,
    blk_read_time double precision,
    blk_write_time double precision
);


ALTER TABLE public.pg_stat_statements_invest OWNER TO postgres;

--
-- Name: capacitygridconditionalstyles id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridconditionalstyles ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.capacitygridconditionalstyles_id_seq'::regclass);


--
-- Name: capacitygridcustomformulas capacitygridcustomformulaid; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridcustomformulas ALTER COLUMN capacitygridcustomformulaid SET DEFAULT nextval('pathwaysdos.capacitygridcustomformulas_capacitygridcustomformulaid_seq'::regclass);


--
-- Name: capacitygridcustomformulastyles id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridcustomformulastyles ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.capacitygridcustomformulastyles_id_seq'::regclass);


--
-- Name: capacitygriddata capacitygriddataid; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygriddata ALTER COLUMN capacitygriddataid SET DEFAULT nextval('pathwaysdos.capacitygriddata_capacitygriddataid_seq'::regclass);


--
-- Name: capacitygridheaders capacitygridheaderid; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridheaders ALTER COLUMN capacitygridheaderid SET DEFAULT nextval('pathwaysdos.capacitygridheaders_capacitygridheaderid_seq'::regclass);


--
-- Name: capacitygridparentsheets id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridparentsheets ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.capacitygridparentsheets_id_seq'::regclass);


--
-- Name: capacitygridservicetypes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridservicetypes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.capacitygridservicetypes_id_seq'::regclass);


--
-- Name: capacitygridsheethistories id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridsheethistories ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.capacitygridsheethistories_id_seq'::regclass);


--
-- Name: capacitygridsheets capacitygridsheetid; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridsheets ALTER COLUMN capacitygridsheetid SET DEFAULT nextval('pathwaysdos.capacitygridsheets_capacitygridsheetid_seq'::regclass);


--
-- Name: capacitygridtriggers capacitygridtriggerid; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridtriggers ALTER COLUMN capacitygridtriggerid SET DEFAULT nextval('pathwaysdos.capacitygridtriggers_capacitygridtriggerid_seq'::regclass);


--
-- Name: capacitystatuses capacitystatusid; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitystatuses ALTER COLUMN capacitystatusid SET DEFAULT nextval('pathwaysdos.capacitystatuses_capacitystatusid_seq'::regclass);


--
-- Name: dispositiongroupdispositions id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositiongroupdispositions ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.dispositiongroupdispositions_id_seq'::regclass);


--
-- Name: dispositiongroups id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositiongroups ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.dispositiongroups_id_seq'::regclass);


--
-- Name: dispositiongroupservicetypes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositiongroupservicetypes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.dispositiongroupservicetypes_id_seq'::regclass);


--
-- Name: dispositions id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositions ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.dispositions_id_seq'::regclass);


--
-- Name: dispositionservicetypes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositionservicetypes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.dispositionservicetypes_id_seq'::regclass);


--
-- Name: genders id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.genders ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.genders_id_seq'::regclass);


--
-- Name: jobqueue id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.jobqueue ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.jobqueue_id_seq'::regclass);


--
-- Name: legacycollisions id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.legacycollisions ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.legacycollisions_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.locations ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.locations_id_seq'::regclass);


--
-- Name: news id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.news ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.news_id_seq'::regclass);


--
-- Name: newsacknowledgedbyusers id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.newsacknowledgedbyusers ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.newsacknowledgedbyusers_id_seq'::regclass);


--
-- Name: newsforpermissions id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.newsforpermissions ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.newsforpermissions_id_seq'::regclass);


--
-- Name: odsimports id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.odsimports ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.odsimports_id_seq'::regclass);


--
-- Name: odspostcodes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.odspostcodes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.odspostcodes_id_seq'::regclass);


--
-- Name: openingtimedays id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.openingtimedays ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.openingtimedays_id_seq'::regclass);


--
-- Name: organisationpostcodes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationpostcodes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.organisationpostcodes_id_seq'::regclass);


--
-- Name: organisationrankingstrategies id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationrankingstrategies ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.organisationrankingstrategies_id_seq'::regclass);


--
-- Name: organisations id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisations ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.organisations_id_seq'::regclass);


--
-- Name: organisationtypes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationtypes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.organisationtypes_id_seq'::regclass);


--
-- Name: permissionattributedict id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.permissionattributedict ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.permissionattributedict_id_seq'::regclass);


--
-- Name: permissionattributes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.permissionattributes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.permissionattributes_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.permissions ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.permissions_id_seq'::regclass);


--
-- Name: publicholidays id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.publicholidays ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.publicholidays_id_seq'::regclass);


--
-- Name: savedsearches id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.savedsearches ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.savedsearches_id_seq'::regclass);


--
-- Name: searchdistances id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.searchdistances ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.searchdistances_id_seq'::regclass);


--
-- Name: searchimports id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.searchimports ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.searchimports_id_seq'::regclass);


--
-- Name: serviceagegroups id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceagegroups ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.serviceagegroups_id_seq'::regclass);


--
-- Name: serviceagerange id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceagerange ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.serviceagerange_id_seq'::regclass);


--
-- Name: servicealignments id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicealignments ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicealignments_id_seq'::regclass);


--
-- Name: serviceattributes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceattributes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.serviceattributes_id_seq'::regclass);


--
-- Name: serviceattributetypes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceattributetypes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.serviceattributetypes_id_seq'::regclass);


--
-- Name: serviceattributevalues id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceattributevalues ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.serviceattributevalues_id_seq'::regclass);


--
-- Name: servicecapacities id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicecapacities ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicecapacities_id_seq'::regclass);


--
-- Name: servicecapacitygrids id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicecapacitygrids ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicecapacitygrids_id_seq'::regclass);


--
-- Name: servicedayopenings id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicedayopenings ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicedayopenings_id_seq'::regclass);


--
-- Name: servicedayopeningtimes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicedayopeningtimes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicedayopeningtimes_id_seq'::regclass);


--
-- Name: servicedispositions id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicedispositions ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicedispositions_id_seq'::regclass);


--
-- Name: serviceendpoints id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceendpoints ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.serviceendpoints_id_seq'::regclass);


--
-- Name: servicegenders id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicegenders ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicegenders_id_seq'::regclass);


--
-- Name: servicerankingstrategies id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicerankingstrategies ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicerankingstrategies_id_seq'::regclass);


--
-- Name: servicereferralroles id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicereferralroles ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicereferralroles_id_seq'::regclass);


--
-- Name: servicereferrals id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicereferrals ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicereferrals_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.services ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.services_id_seq'::regclass);


--
-- Name: serviceserviceattributes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceserviceattributes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.serviceserviceattributes_id_seq'::regclass);


--
-- Name: servicesgsds id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicesgsds ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicesgsds_id_seq'::regclass);


--
-- Name: servicespecifiedopeningdates id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicespecifiedopeningdates ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicespecifiedopeningdates_id_seq'::regclass);


--
-- Name: servicespecifiedopeningtimes id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicespecifiedopeningtimes ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicespecifiedopeningtimes_id_seq'::regclass);


--
-- Name: servicestatuses id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicestatuses ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.servicestatuses_id_seq'::regclass);


--
-- Name: symptomdiscriminatorsynonyms id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.symptomdiscriminatorsynonyms ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.symptomdiscriminatorsynonyms_id_seq'::regclass);


--
-- Name: symptomgroupsymptomdiscriminators id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.symptomgroupsymptomdiscriminators ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.symptomgroupsymptomdiscriminators_id_seq'::regclass);


--
-- Name: userpermissions id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userpermissions ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.userpermissions_id_seq'::regclass);


--
-- Name: userreferralroles id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userreferralroles ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.userreferralroles_id_seq'::regclass);


--
-- Name: userregions id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userregions ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.userregions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.users ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.users_id_seq'::regclass);


--
-- Name: usersavedsearches id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.usersavedsearches ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.usersavedsearches_id_seq'::regclass);


--
-- Name: userservices id; Type: DEFAULT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userservices ALTER COLUMN id SET DEFAULT nextval('pathwaysdos.userservices_id_seq'::regclass);


--
-- Name: agegroups agegroups_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.agegroups
    ADD CONSTRAINT agegroups_pkey PRIMARY KEY (id);


--
-- Name: capacitygridconditionalstyles capacitygridconditionalstyles_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridconditionalstyles
    ADD CONSTRAINT capacitygridconditionalstyles_pkey PRIMARY KEY (id);


--
-- Name: capacitygridcustomformulas capacitygridcustomformulas_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridcustomformulas
    ADD CONSTRAINT capacitygridcustomformulas_pkey PRIMARY KEY (capacitygridcustomformulaid);


--
-- Name: capacitygridcustomformulastyles capacitygridcustomformulastyles_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridcustomformulastyles
    ADD CONSTRAINT capacitygridcustomformulastyles_pkey PRIMARY KEY (id);


--
-- Name: capacitygriddata capacitygriddata_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygriddata
    ADD CONSTRAINT capacitygriddata_pkey PRIMARY KEY (capacitygriddataid);


--
-- Name: capacitygridheaders capacitygridheaders_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridheaders
    ADD CONSTRAINT capacitygridheaders_pkey PRIMARY KEY (capacitygridheaderid);


--
-- Name: capacitygridparentsheets capacitygridparentsheets_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridparentsheets
    ADD CONSTRAINT capacitygridparentsheets_pkey PRIMARY KEY (id);


--
-- Name: capacitygridservicetypes capacitygridservicetypes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridservicetypes
    ADD CONSTRAINT capacitygridservicetypes_pkey PRIMARY KEY (id);


--
-- Name: capacitygridsheethistories capacitygridsheethistories_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridsheethistories
    ADD CONSTRAINT capacitygridsheethistories_pkey PRIMARY KEY (id);


--
-- Name: capacitygridsheets capacitygridsheets_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridsheets
    ADD CONSTRAINT capacitygridsheets_pkey PRIMARY KEY (capacitygridsheetid);


--
-- Name: capacitygridtriggers capacitygridtriggers_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridtriggers
    ADD CONSTRAINT capacitygridtriggers_pkey PRIMARY KEY (capacitygridtriggerid);


--
-- Name: capacitystatuses capacitystatuses_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitystatuses
    ADD CONSTRAINT capacitystatuses_pkey PRIMARY KEY (capacitystatusid);


--
-- Name: changes changes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.changes
    ADD CONSTRAINT changes_pkey PRIMARY KEY (id);


--
-- Name: dispositiongroupdispositions dispositiongroupdispositions_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositiongroupdispositions
    ADD CONSTRAINT dispositiongroupdispositions_pkey PRIMARY KEY (id);


--
-- Name: dispositiongroups dispositiongroups_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositiongroups
    ADD CONSTRAINT dispositiongroups_pkey PRIMARY KEY (id);


--
-- Name: dispositiongroupservicetypes dispositiongroupservicetypes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositiongroupservicetypes
    ADD CONSTRAINT dispositiongroupservicetypes_pkey PRIMARY KEY (id);


--
-- Name: dispositions dispositions_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositions
    ADD CONSTRAINT dispositions_pkey PRIMARY KEY (id);


--
-- Name: dispositionservicetypes dispositionservicetypes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositionservicetypes
    ADD CONSTRAINT dispositionservicetypes_pkey PRIMARY KEY (id);


--
-- Name: genders genders_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.genders
    ADD CONSTRAINT genders_pkey PRIMARY KEY (id);


--
-- Name: jobqueue jobqueue_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.jobqueue
    ADD CONSTRAINT jobqueue_pkey PRIMARY KEY (id);


--
-- Name: legacycollisions legacycollisions_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.legacycollisions
    ADD CONSTRAINT legacycollisions_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: news news_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.news
    ADD CONSTRAINT news_pkey PRIMARY KEY (id);


--
-- Name: newsacknowledgedbyusers newsacknowledgedbyusers_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.newsacknowledgedbyusers
    ADD CONSTRAINT newsacknowledgedbyusers_pkey PRIMARY KEY (id);


--
-- Name: newsforpermissions4_16_1 newsforpermissions4_16_1_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.newsforpermissions4_16_1
    ADD CONSTRAINT newsforpermissions4_16_1_pkey PRIMARY KEY (id);


--
-- Name: newsforpermissions newsforpermissions_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.newsforpermissions
    ADD CONSTRAINT newsforpermissions_pkey PRIMARY KEY (id);


--
-- Name: odsimports odsimports_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.odsimports
    ADD CONSTRAINT odsimports_pkey PRIMARY KEY (id);


--
-- Name: odspostcodes odspostcodes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.odspostcodes
    ADD CONSTRAINT odspostcodes_pkey PRIMARY KEY (id);


--
-- Name: organisationpostcodes op_loc_org_unique; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationpostcodes
    ADD CONSTRAINT op_loc_org_unique UNIQUE (locationid, organisationid);


--
-- Name: openingtimedays openingtimedays_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.openingtimedays
    ADD CONSTRAINT openingtimedays_pkey PRIMARY KEY (id);


--
-- Name: organisations org_code_unique; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisations
    ADD CONSTRAINT org_code_unique UNIQUE (code);


--
-- Name: organisationpostcodes organisationpostcode_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationpostcodes
    ADD CONSTRAINT organisationpostcode_pkey PRIMARY KEY (id);


--
-- Name: organisationrankingstrategies organisationrankingstrategies_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationrankingstrategies
    ADD CONSTRAINT organisationrankingstrategies_pkey PRIMARY KEY (id);


--
-- Name: organisations organisations_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


--
-- Name: organisationtypes organisationtypes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationtypes
    ADD CONSTRAINT organisationtypes_pkey PRIMARY KEY (id);


--
-- Name: organisationrankingstrategies ors_st_org_unique; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationrankingstrategies
    ADD CONSTRAINT ors_st_org_unique UNIQUE (organisationid, servicetypeid);


--
-- Name: permissionattributedict permissionattributedict_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.permissionattributedict
    ADD CONSTRAINT permissionattributedict_pkey PRIMARY KEY (id);


--
-- Name: permissionattributes4_16_1 permissionattributes4_16_1_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.permissionattributes4_16_1
    ADD CONSTRAINT permissionattributes4_16_1_pkey PRIMARY KEY (id);


--
-- Name: permissionattributes permissionattributes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.permissionattributes
    ADD CONSTRAINT permissionattributes_pkey PRIMARY KEY (id);


--
-- Name: permissions4_16_1 permissions4_16_1_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.permissions4_16_1
    ADD CONSTRAINT permissions4_16_1_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: publicholidays publicholidays_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.publicholidays
    ADD CONSTRAINT publicholidays_pkey PRIMARY KEY (id);


--
-- Name: publicholidays publicholidays_uk1; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.publicholidays
    ADD CONSTRAINT publicholidays_uk1 UNIQUE (holidaydate);


--
-- Name: purgedusers purgedusers_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.purgedusers
    ADD CONSTRAINT purgedusers_pkey PRIMARY KEY (id);


--
-- Name: referralroles referralroles_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.referralroles
    ADD CONSTRAINT referralroles_pkey PRIMARY KEY (id);


--
-- Name: savedsearches savedsearches_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.savedsearches
    ADD CONSTRAINT savedsearches_pkey PRIMARY KEY (id);


--
-- Name: searchdistances searchdistances_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.searchdistances
    ADD CONSTRAINT searchdistances_pkey PRIMARY KEY (id);


--
-- Name: searchdistances searchdistances_uk1; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.searchdistances
    ADD CONSTRAINT searchdistances_uk1 UNIQUE (code);


--
-- Name: searchimports searchimports_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.searchimports
    ADD CONSTRAINT searchimports_pkey PRIMARY KEY (id);


--
-- Name: serviceagegroups serviceagegroups_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceagegroups
    ADD CONSTRAINT serviceagegroups_pkey PRIMARY KEY (id);


--
-- Name: serviceagerange serviceagerange_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceagerange
    ADD CONSTRAINT serviceagerange_pkey PRIMARY KEY (id);


--
-- Name: servicealignments servicealignments_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicealignments
    ADD CONSTRAINT servicealignments_pkey PRIMARY KEY (id);


--
-- Name: servicealignments servicealignments_uk1; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicealignments
    ADD CONSTRAINT servicealignments_uk1 UNIQUE (serviceid, commissioningorganisationid);


--
-- Name: serviceattributes serviceattributes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceattributes
    ADD CONSTRAINT serviceattributes_pkey PRIMARY KEY (id);


--
-- Name: serviceattributetypes serviceattributetypes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceattributetypes
    ADD CONSTRAINT serviceattributetypes_pkey PRIMARY KEY (id);


--
-- Name: serviceattributevalues serviceattributevalues_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceattributevalues
    ADD CONSTRAINT serviceattributevalues_pkey PRIMARY KEY (id);


--
-- Name: servicecapacities servicecapacities_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicecapacities
    ADD CONSTRAINT servicecapacities_pkey PRIMARY KEY (id);


--
-- Name: servicecapacities servicecapacities_uk1; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicecapacities
    ADD CONSTRAINT servicecapacities_uk1 UNIQUE (serviceid);


--
-- Name: servicecapacitygrids servicecapacitygrids_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicecapacitygrids
    ADD CONSTRAINT servicecapacitygrids_pkey PRIMARY KEY (id);


--
-- Name: servicedayopenings servicedayopenings_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicedayopenings
    ADD CONSTRAINT servicedayopenings_pkey PRIMARY KEY (id);


--
-- Name: servicedayopeningtimes servicedayopeningtimes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicedayopeningtimes
    ADD CONSTRAINT servicedayopeningtimes_pkey PRIMARY KEY (id);


--
-- Name: servicedispositions servicedispositions_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicedispositions
    ADD CONSTRAINT servicedispositions_pkey PRIMARY KEY (id);


--
-- Name: serviceendpoints serviceendpoints_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceendpoints
    ADD CONSTRAINT serviceendpoints_pkey PRIMARY KEY (id);


--
-- Name: servicegenders servicegenders_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicegenders
    ADD CONSTRAINT servicegenders_pkey PRIMARY KEY (id);


--
-- Name: servicehistories servicehistories_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicehistories
    ADD CONSTRAINT servicehistories_pkey PRIMARY KEY (serviceid);


--
-- Name: servicerankingstrategies servicerankingstrategies_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicerankingstrategies
    ADD CONSTRAINT servicerankingstrategies_pkey PRIMARY KEY (id);


--
-- Name: servicereferralroles servicereferralroles_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicereferralroles
    ADD CONSTRAINT servicereferralroles_pkey PRIMARY KEY (id);


--
-- Name: servicereferrals servicereferrals_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicereferrals
    ADD CONSTRAINT servicereferrals_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: serviceserviceattributes serviceserviceattributes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceserviceattributes
    ADD CONSTRAINT serviceserviceattributes_pkey PRIMARY KEY (id);


--
-- Name: servicesgsds servicesgsds_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicesgsds
    ADD CONSTRAINT servicesgsds_pkey PRIMARY KEY (id);


--
-- Name: servicespecifiedopeningdates servicespecifiedopeningdates_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicespecifiedopeningdates
    ADD CONSTRAINT servicespecifiedopeningdates_pkey PRIMARY KEY (id);


--
-- Name: servicespecifiedopeningtimes servicespecifiedopeningtimes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicespecifiedopeningtimes
    ADD CONSTRAINT servicespecifiedopeningtimes_pkey PRIMARY KEY (id);


--
-- Name: servicestatuses servicestatuses_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicestatuses
    ADD CONSTRAINT servicestatuses_pkey PRIMARY KEY (id);


--
-- Name: servicetypes servicetypes_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicetypes
    ADD CONSTRAINT servicetypes_pkey PRIMARY KEY (id);


--
-- Name: symptomdiscriminators symptomdiscriminators_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.symptomdiscriminators
    ADD CONSTRAINT symptomdiscriminators_pkey PRIMARY KEY (id);


--
-- Name: symptomdiscriminatorsynonyms symptomdiscriminatorsynonyms_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.symptomdiscriminatorsynonyms
    ADD CONSTRAINT symptomdiscriminatorsynonyms_pkey PRIMARY KEY (id);


--
-- Name: symptomgroups symptomgroups_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.symptomgroups
    ADD CONSTRAINT symptomgroups_pkey PRIMARY KEY (id);


--
-- Name: symptomgroupsymptomdiscriminators symptomgroupsymptomdiscriminators_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.symptomgroupsymptomdiscriminators
    ADD CONSTRAINT symptomgroupsymptomdiscriminators_pkey PRIMARY KEY (id);


--
-- Name: userpermissions4_16_1 userpermissions4_16_1_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userpermissions4_16_1
    ADD CONSTRAINT userpermissions4_16_1_pkey PRIMARY KEY (id);


--
-- Name: userpermissions userpermissions_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userpermissions
    ADD CONSTRAINT userpermissions_pkey PRIMARY KEY (id);


--
-- Name: userreferralroles userreferralroles_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userreferralroles
    ADD CONSTRAINT userreferralroles_pkey PRIMARY KEY (id);


--
-- Name: userregions userregions_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userregions
    ADD CONSTRAINT userregions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: usersavedsearches usersavedsearches_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.usersavedsearches
    ADD CONSTRAINT usersavedsearches_pkey PRIMARY KEY (id);


--
-- Name: userservices userservices_pkey; Type: CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userservices
    ADD CONSTRAINT userservices_pkey PRIMARY KEY (id);


--
-- Name: idx_13a6b93b5e237e06; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_13a6b93b5e237e06 ON pathwaysdos.servicetypes USING btree (name);


--
-- Name: idx_15fd08b85d98f5af; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_15fd08b85d98f5af ON pathwaysdos.servicereferralroles USING btree (referralroleid);


--
-- Name: idx_15fd08b889697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_15fd08b889697fa8 ON pathwaysdos.servicereferralroles USING btree (serviceid);


--
-- Name: idx_206d130164b64dcc; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_206d130164b64dcc ON pathwaysdos.usersavedsearches USING btree (userid);


--
-- Name: idx_206d1301ddc59acc; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_206d1301ddc59acc ON pathwaysdos.usersavedsearches USING btree (savedsearchid);


--
-- Name: idx_3150feb789697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_3150feb789697fa8 ON pathwaysdos.serviceagerange USING btree (serviceid);


--
-- Name: idx_32508c7f7c74e29f; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_32508c7f7c74e29f ON pathwaysdos.servicesgsds USING btree (sdid);


--
-- Name: idx_32508c7f7e325cc6; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_32508c7f7e325cc6 ON pathwaysdos.servicesgsds USING btree (sgid);


--
-- Name: idx_32508c7f89697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_32508c7f89697fa8 ON pathwaysdos.servicesgsds USING btree (serviceid);


--
-- Name: idx_3a1dd30f19d52895; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_3a1dd30f19d52895 ON pathwaysdos.newsacknowledgedbyusers USING btree (newsid);


--
-- Name: idx_42566457194eb424; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_42566457194eb424 ON pathwaysdos.servicedayopenings USING btree (dayid);


--
-- Name: idx_4256645789697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_4256645789697fa8 ON pathwaysdos.servicedayopenings USING btree (serviceid);


--
-- Name: idx_427a70a661325b4d; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_427a70a661325b4d ON pathwaysdos.capacitygridparentsheets USING btree (capacitygridsheetid);


--
-- Name: idx_427a70a6a628ae7e; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_427a70a6a628ae7e ON pathwaysdos.capacitygridparentsheets USING btree (capacitygridparentid);


--
-- Name: idx_46360b4c89697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_46360b4c89697fa8 ON pathwaysdos.servicegenders USING btree (serviceid);


--
-- Name: idx_49630122bacd168f; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_49630122bacd168f ON pathwaysdos.symptomgroupsymptomdiscriminators USING btree (symptomgroupid);


--
-- Name: idx_49630122d648d605; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_49630122d648d605 ON pathwaysdos.symptomgroupsymptomdiscriminators USING btree (symptomdiscriminatorid);


--
-- Name: idx_576ec73b149eca10; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_576ec73b149eca10 ON pathwaysdos.dispositiongroupdispositions USING btree (dispositionid);


--
-- Name: idx_576ec73b9bb73fe6; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_576ec73b9bb73fe6 ON pathwaysdos.dispositiongroupdispositions USING btree (dispositiongroupid);


--
-- Name: idx_59052f1554022ebc; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_59052f1554022ebc ON pathwaysdos.servicereferrals USING btree (referredserviceid);


--
-- Name: idx_59052f15f70c1dca; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_59052f15f70c1dca ON pathwaysdos.servicereferrals USING btree (referralserviceid);


--
-- Name: idx_59e3a636539b0606; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_59e3a636539b0606 ON pathwaysdos.capacitygridcustomformulas USING btree (uid);


--
-- Name: idx_59e3a63685963223; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_59e3a63685963223 ON pathwaysdos.capacitygridcustomformulas USING btree (capacitygriddataid);


--
-- Name: idx_5dc51fa261325b4d; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_5dc51fa261325b4d ON pathwaysdos.capacitygridservicetypes USING btree (capacitygridsheetid);


--
-- Name: idx_5dc51fa2bf1290dd; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_5dc51fa2bf1290dd ON pathwaysdos.capacitygridservicetypes USING btree (servicetypeid);


--
-- Name: idx_5dc998c15e237e06; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_5dc998c15e237e06 ON pathwaysdos.symptomdiscriminatorsynonyms USING btree (name);


--
-- Name: idx_5dc998c1d648d605; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_5dc998c1d648d605 ON pathwaysdos.symptomdiscriminatorsynonyms USING btree (symptomdiscriminatorid);


--
-- Name: idx_5ea9331b28cf5be6; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_5ea9331b28cf5be6 ON pathwaysdos.purgedusers USING btree (lastlogintime);


--
-- Name: idx_5ea9331b7b00651c; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_5ea9331b7b00651c ON pathwaysdos.purgedusers USING btree (status);


--
-- Name: idx_5ea9331b870c850a; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_5ea9331b870c850a ON pathwaysdos.purgedusers USING btree (approveddate);


--
-- Name: idx_5ea9331b91161a882392a156; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_5ea9331b91161a882392a156 ON pathwaysdos.purgedusers USING btree (lastname, firstname);


--
-- Name: idx_5ea9331b98f62385; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_5ea9331b98f62385 ON pathwaysdos.purgedusers USING btree (createdtime);


--
-- Name: idx_5ea9331bdd2bbc4d; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_5ea9331bdd2bbc4d ON pathwaysdos.purgedusers USING btree (approvedby);


--
-- Name: idx_5ea9331be7927c74; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_5ea9331be7927c74 ON pathwaysdos.purgedusers USING btree (email);


--
-- Name: idx_67076541149eca10; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_67076541149eca10 ON pathwaysdos.dispositionservicetypes USING btree (dispositionid);


--
-- Name: idx_67076541bf1290dd; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_67076541bf1290dd ON pathwaysdos.dispositionservicetypes USING btree (servicetypeid);


--
-- Name: idx_6fd396b6939c32ff; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_6fd396b6939c32ff ON pathwaysdos.legacycollisions USING btree (legacyid);


--
-- Name: idx_6fd396b6f59fa73c; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_6fd396b6f59fa73c ON pathwaysdos.legacycollisions USING btree (serviceagerangeid);


--
-- Name: idx_714894ae539b0606; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_714894ae539b0606 ON pathwaysdos.capacitygridheaders USING btree (uid);


--
-- Name: idx_714894ae61325b4d; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_714894ae61325b4d ON pathwaysdos.capacitygridheaders USING btree (capacitygridsheetid);


--
-- Name: idx_7727330664b64dcc; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_7727330664b64dcc ON pathwaysdos.userregions USING btree (userid);


--
-- Name: idx_772733069962506a; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_772733069962506a ON pathwaysdos.userregions USING btree (regionid);


--
-- Name: idx_7ec263ae5d98f5af; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_7ec263ae5d98f5af ON pathwaysdos.userreferralroles USING btree (referralroleid);


--
-- Name: idx_7ec263ae64b64dcc; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_7ec263ae64b64dcc ON pathwaysdos.userreferralroles USING btree (userid);


--
-- Name: idx_84cebb71539b0606; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_84cebb71539b0606 ON pathwaysdos.capacitygridsheethistories USING btree (uid);


--
-- Name: idx_84cebb7189697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_84cebb7189697fa8 ON pathwaysdos.capacitygridsheethistories USING btree (serviceid);


--
-- Name: idx_8a44833f10ee4cee; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833f10ee4cee ON pathwaysdos.services USING btree (parentid);


--
-- Name: idx_8a44833f3be6749b; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833f3be6749b ON pathwaysdos.services USING btree (odscode);


--
-- Name: idx_8a44833f539b0606; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833f539b0606 ON pathwaysdos.services USING btree (uid);


--
-- Name: idx_8a44833f5e237e06; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833f5e237e06 ON pathwaysdos.services USING btree (name);


--
-- Name: idx_8a44833f62c39f2f; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833f62c39f2f ON pathwaysdos.services USING btree (organisationid);


--
-- Name: idx_8a44833f6b848fb5; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833f6b848fb5 ON pathwaysdos.services USING btree (subregionid);


--
-- Name: idx_8a44833f98f62385; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833f98f62385 ON pathwaysdos.services USING btree (createdtime);


--
-- Name: idx_8a44833f9bf49490; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833f9bf49490 ON pathwaysdos.services USING btree (typeid);


--
-- Name: idx_8a44833fa2156f24; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833fa2156f24 ON pathwaysdos.services USING btree (lasttemplateid);


--
-- Name: idx_8a44833fb2cb8f6a63926b8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833fb2cb8f6a63926b8 ON pathwaysdos.services USING btree (easting, northing);


--
-- Name: idx_8a44833ff112f078; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833ff112f078 ON pathwaysdos.services USING btree (statusid);


--
-- Name: idx_8a44833ff40b5d8b; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_8a44833ff40b5d8b ON pathwaysdos.services USING btree (modifiedtime);


--
-- Name: idx_9e65c2333e0136f0; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_9e65c2333e0136f0 ON pathwaysdos.serviceendpoints USING btree (endpointorder);


--
-- Name: idx_9e65c23389697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_9e65c23389697fa8 ON pathwaysdos.serviceendpoints USING btree (serviceid);


--
-- Name: idx_a03561c643d7929a; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_a03561c643d7929a ON pathwaysdos.servicerankingstrategies USING btree (servicetype);


--
-- Name: idx_a03561c689697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_a03561c689697fa8 ON pathwaysdos.servicerankingstrategies USING btree (serviceid);


--
-- Name: idx_a03561c6b144c54a; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_a03561c6b144c54a ON pathwaysdos.servicerankingstrategies USING btree (localranking);


--
-- Name: idx_a0953149bb73fe6; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_a0953149bb73fe6 ON pathwaysdos.dispositiongroupservicetypes USING btree (dispositiongroupid);


--
-- Name: idx_a095314bf1290dd; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_a095314bf1290dd ON pathwaysdos.dispositiongroupservicetypes USING btree (servicetypeid);


--
-- Name: idx_a2f43bd6539b0606; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_a2f43bd6539b0606 ON pathwaysdos.capacitygridtriggers USING btree (uid);


--
-- Name: idx_a2f43bd661325b4d; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_a2f43bd661325b4d ON pathwaysdos.capacitygridtriggers USING btree (capacitygridsheetid);


--
-- Name: idx_a2f43bd6e652d510; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_a2f43bd6e652d510 ON pathwaysdos.capacitygridtriggers USING btree (cmsgridid);


--
-- Name: idx_aaca31cf89697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_aaca31cf89697fa8 ON pathwaysdos.serviceagegroups USING btree (serviceid);


--
-- Name: idx_aaca31cfc2f62bd8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_aaca31cfc2f62bd8 ON pathwaysdos.serviceagegroups USING btree (agegroupid);


--
-- Name: idx_ab7143b88cde5729; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_ab7143b88cde5729 ON pathwaysdos.permissions USING btree (type);


--
-- Name: idx_b5142da605405b0; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_b5142da605405b0 ON pathwaysdos.permissionattributes USING btree (permissionid);


--
-- Name: idx_b5142da968c3886; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_b5142da968c3886 ON pathwaysdos.permissionattributes USING btree (permissionattributedictid);


--
-- Name: idx_be30a7b064b64dcc; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_be30a7b064b64dcc ON pathwaysdos.userservices USING btree (userid);


--
-- Name: idx_be30a7b089697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_be30a7b089697fa8 ON pathwaysdos.userservices USING btree (serviceid);


--
-- Name: idx_c0db61886de44026; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_c0db61886de44026 ON pathwaysdos.symptomdiscriminators USING btree (description);


--
-- Name: idx_c9566749539b0606; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_c9566749539b0606 ON pathwaysdos.capacitygriddata USING btree (uid);


--
-- Name: idx_c956674961325b4d; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_c956674961325b4d ON pathwaysdos.capacitygriddata USING btree (capacitygridsheetid);


--
-- Name: idx_cd1c55096d95540f; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_cd1c55096d95540f ON pathwaysdos.capacitygridcustomformulastyles USING btree (formulaid);


--
-- Name: idx_cd1c55097015c8dc; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_cd1c55097015c8dc ON pathwaysdos.capacitygridcustomformulastyles USING btree (styleid);


--
-- Name: idx_commissioning_organisation; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_commissioning_organisation ON pathwaysdos.servicealignments USING btree (commissioningorganisationid);


--
-- Name: idx_d5428aed28cf5be6; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_d5428aed28cf5be6 ON pathwaysdos.users USING btree (lastlogintime);


--
-- Name: idx_d5428aed7b00651c; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_d5428aed7b00651c ON pathwaysdos.users USING btree (status);


--
-- Name: idx_d5428aed870c850a; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_d5428aed870c850a ON pathwaysdos.users USING btree (approveddate);


--
-- Name: idx_d5428aed91161a882392a156; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_d5428aed91161a882392a156 ON pathwaysdos.users USING btree (lastname, firstname);


--
-- Name: idx_d5428aed98f62385; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_d5428aed98f62385 ON pathwaysdos.users USING btree (createdtime);


--
-- Name: idx_d5428aeddd2bbc4d; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_d5428aeddd2bbc4d ON pathwaysdos.users USING btree (approvedby);


--
-- Name: idx_d5428aede7927c74; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_d5428aede7927c74 ON pathwaysdos.users USING btree (email);


--
-- Name: idx_d9f6dd7e61325b4d; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_d9f6dd7e61325b4d ON pathwaysdos.servicecapacitygrids USING btree (capacitygridsheetid);


--
-- Name: idx_d9f6dd7e87d85175; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_d9f6dd7e87d85175 ON pathwaysdos.servicecapacitygrids USING btree (servicecapacityid);


--
-- Name: idx_e7984bb2605405b0; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_e7984bb2605405b0 ON pathwaysdos.userpermissions USING btree (permissionid);


--
-- Name: idx_e7984bb264b64dcc; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_e7984bb264b64dcc ON pathwaysdos.userpermissions USING btree (userid);


--
-- Name: idx_ee31b38c19d52895; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_ee31b38c19d52895 ON pathwaysdos.newsforpermissions USING btree (newsid);


--
-- Name: idx_ef9d81a11ced5b0a9c0b752; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_ef9d81a11ced5b0a9c0b752 ON pathwaysdos.changes USING btree (serviceid, approvestatus);


--
-- Name: idx_ef9d81a189697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_ef9d81a189697fa8 ON pathwaysdos.changes USING btree (serviceid);


--
-- Name: idx_ef9d81a1961eaf4a; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_ef9d81a1961eaf4a ON pathwaysdos.changes USING btree (createdtimestamp);


--
-- Name: idx_fa62cf52149eca10; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_fa62cf52149eca10 ON pathwaysdos.servicedispositions USING btree (dispositionid);


--
-- Name: idx_fa62cf5289697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_fa62cf5289697fa8 ON pathwaysdos.servicedispositions USING btree (serviceid);


--
-- Name: idx_fbf2e963101f2b4; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_fbf2e963101f2b4 ON pathwaysdos.servicecapacities USING btree (modifieddate);


--
-- Name: idx_fbf2e96844c57db; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_fbf2e96844c57db ON pathwaysdos.servicecapacities USING btree (capacitystatusid);


--
-- Name: idx_fbf2e96ecf9771d; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_fbf2e96ecf9771d ON pathwaysdos.servicecapacities USING btree (modifiedby);


--
-- Name: idx_locations_postaltown; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_locations_postaltown ON pathwaysdos.locations USING btree (postaltown);


--
-- Name: idx_locations_postcode; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_locations_postcode ON pathwaysdos.locations USING btree (postcode);


--
-- Name: idx_newsacknowledgedbyusers_userid; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_newsacknowledgedbyusers_userid ON pathwaysdos.newsacknowledgedbyusers USING btree (userid);


--
-- Name: idx_newsforpermissions_permissionid; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_newsforpermissions_permissionid ON pathwaysdos.newsforpermissions USING btree (permissionid);


--
-- Name: idx_odsimports_ccg; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_odsimports_ccg ON pathwaysdos.odsimports USING btree (ccg);


--
-- Name: idx_odsimports_pcds; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_odsimports_pcds ON pathwaysdos.odsimports USING btree (pcds);


--
-- Name: idx_odspostcodes_orgcode; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_odspostcodes_orgcode ON pathwaysdos.odspostcodes USING btree (orgcode);


--
-- Name: idx_odspostcodes_postcode; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_odspostcodes_postcode ON pathwaysdos.odspostcodes USING btree (postcode);


--
-- Name: idx_organisation_organisationtypeid; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_organisation_organisationtypeid ON pathwaysdos.organisations USING btree (organisationtypeid);


--
-- Name: idx_ors_organisation; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_ors_organisation ON pathwaysdos.organisationrankingstrategies USING btree (organisationid);


--
-- Name: idx_searchimports_code; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_searchimports_code ON pathwaysdos.searchimports USING btree (code);


--
-- Name: idx_servicedayopeningtimes_servicedayopeningid; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_servicedayopeningtimes_servicedayopeningid ON pathwaysdos.servicedayopeningtimes USING btree (servicedayopeningid);


--
-- Name: idx_servicegenders_genderid; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_servicegenders_genderid ON pathwaysdos.servicegenders USING btree (genderid);


--
-- Name: idx_servicespecifiedopeningdates_serviceid; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_servicespecifiedopeningdates_serviceid ON pathwaysdos.servicespecifiedopeningdates USING btree (serviceid);


--
-- Name: idx_servicespecifiedopeningtimes_servicespecifiedopeningdateid; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_servicespecifiedopeningtimes_servicespecifiedopeningdateid ON pathwaysdos.servicespecifiedopeningtimes USING btree (servicespecifiedopeningdateid);


--
-- Name: idx_users_username_lower; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX idx_users_username_lower ON pathwaysdos.users USING btree (lower((username)::text));


--
-- Name: newsacknowledgedbyusers_newsid_userid; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX newsacknowledgedbyusers_newsid_userid ON pathwaysdos.newsacknowledgedbyusers USING btree (newsid, userid);


--
-- Name: serviceattributes_idx1; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX serviceattributes_idx1 ON pathwaysdos.serviceattributes USING btree (serviceattributetypeid);


--
-- Name: serviceattributes_idx2; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX serviceattributes_idx2 ON pathwaysdos.serviceattributes USING btree (createduserid);


--
-- Name: serviceattributes_idx3; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX serviceattributes_idx3 ON pathwaysdos.serviceattributes USING btree (modifieduserid);


--
-- Name: serviceattributevalues_idx1; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX serviceattributevalues_idx1 ON pathwaysdos.serviceattributevalues USING btree (serviceattributeid);


--
-- Name: serviceserviceattributes_idx1; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX serviceserviceattributes_idx1 ON pathwaysdos.serviceserviceattributes USING btree (serviceattributeid);


--
-- Name: serviceserviceattributes_idx2; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX serviceserviceattributes_idx2 ON pathwaysdos.serviceserviceattributes USING btree (serviceattributevalueid);


--
-- Name: serviceserviceattributes_idx3; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE INDEX serviceserviceattributes_idx3 ON pathwaysdos.serviceserviceattributes USING btree (serviceid);


--
-- Name: un_newsforpermissions_newsid_permissionid; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX un_newsforpermissions_newsid_permissionid ON pathwaysdos.newsforpermissions USING btree (newsid, permissionid);


--
-- Name: un_servicegenders_serviceid_genderid; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX un_servicegenders_serviceid_genderid ON pathwaysdos.servicegenders USING btree (serviceid, genderid);


--
-- Name: un_servicehistories_serviceid; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX un_servicehistories_serviceid ON pathwaysdos.servicehistories USING btree (serviceid);


--
-- Name: uniq_15fd08b889697fa85d98f5af; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_15fd08b889697fa85d98f5af ON pathwaysdos.servicereferralroles USING btree (serviceid, referralroleid);


--
-- Name: uniq_206d130164b64dccddc59acc; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_206d130164b64dccddc59acc ON pathwaysdos.usersavedsearches USING btree (userid, savedsearchid);


--
-- Name: uniq_32508c7f89697fa87c74e29f7e325cc6; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_32508c7f89697fa87c74e29f7e325cc6 ON pathwaysdos.servicesgsds USING btree (serviceid, sdid, sgid);


--
-- Name: uniq_427a70a6a628ae7e61325b4d; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_427a70a6a628ae7e61325b4d ON pathwaysdos.capacitygridparentsheets USING btree (capacitygridparentid, capacitygridsheetid);


--
-- Name: uniq_49630122bacd168fd648d605; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_49630122bacd168fd648d605 ON pathwaysdos.symptomgroupsymptomdiscriminators USING btree (symptomgroupid, symptomdiscriminatorid);


--
-- Name: uniq_576ec73b149eca109bb73fe6; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_576ec73b149eca109bb73fe6 ON pathwaysdos.dispositiongroupdispositions USING btree (dispositionid, dispositiongroupid);


--
-- Name: uniq_59052f15f70c1dca54022ebc; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_59052f15f70c1dca54022ebc ON pathwaysdos.servicereferrals USING btree (referralserviceid, referredserviceid);


--
-- Name: uniq_5dc51fa261325b4dbf1290dd; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_5dc51fa261325b4dbf1290dd ON pathwaysdos.capacitygridservicetypes USING btree (capacitygridsheetid, servicetypeid);


--
-- Name: uniq_5ea9331bf85e0677; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_5ea9331bf85e0677 ON pathwaysdos.purgedusers USING btree (username);


--
-- Name: uniq_67076541149eca10bf1290dd; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_67076541149eca10bf1290dd ON pathwaysdos.dispositionservicetypes USING btree (dispositionid, servicetypeid);


--
-- Name: uniq_673868f15e237e06; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_673868f15e237e06 ON pathwaysdos.symptomgroups USING btree (name);


--
-- Name: uniq_7727330664b64dcc9962506a; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_7727330664b64dcc9962506a ON pathwaysdos.userregions USING btree (userid, regionid);


--
-- Name: uniq_7ec263ae64b64dcc5d98f5af; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_7ec263ae64b64dcc5d98f5af ON pathwaysdos.userreferralroles USING btree (userid, referralroleid);


--
-- Name: uniq_8af64fff5e237e06; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_8af64fff5e237e06 ON pathwaysdos.referralroles USING btree (name);


--
-- Name: uniq_923e98ec5e237e06; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_923e98ec5e237e06 ON pathwaysdos.permissionattributedict USING btree (name);


--
-- Name: uniq_a0953149bb73fe6bf1290dd; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_a0953149bb73fe6bf1290dd ON pathwaysdos.dispositiongroupservicetypes USING btree (dispositiongroupid, servicetypeid);


--
-- Name: uniq_aaca31cf89697fa8c2f62bd8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_aaca31cf89697fa8c2f62bd8 ON pathwaysdos.serviceagegroups USING btree (serviceid, agegroupid);


--
-- Name: uniq_ab7143b85e237e06; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_ab7143b85e237e06 ON pathwaysdos.permissions USING btree (name);


--
-- Name: uniq_b5142da605405b0968c3886; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_b5142da605405b0968c3886 ON pathwaysdos.permissionattributes USING btree (permissionid, permissionattributedictid);


--
-- Name: uniq_be30a7b064b64dcc89697fa8; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_be30a7b064b64dcc89697fa8 ON pathwaysdos.userservices USING btree (userid, serviceid);


--
-- Name: uniq_cd1c55096d95540f7015c8dc; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_cd1c55096d95540f7015c8dc ON pathwaysdos.capacitygridcustomformulastyles USING btree (formulaid, styleid);


--
-- Name: uniq_cd848f1e61325b4d; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_cd848f1e61325b4d ON pathwaysdos.capacitygridsheets USING btree (capacitygridsheetid);


--
-- Name: uniq_d5428aedf85e0677; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_d5428aedf85e0677 ON pathwaysdos.users USING btree (username);


--
-- Name: uniq_d9f6dd7e61325b4d87d85175; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_d9f6dd7e61325b4d87d85175 ON pathwaysdos.servicecapacitygrids USING btree (capacitygridsheetid, servicecapacityid);


--
-- Name: uniq_e7984bb264b64dcc605405b0; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_e7984bb264b64dcc605405b0 ON pathwaysdos.userpermissions USING btree (userid, permissionid);


--
-- Name: uniq_fa62cf5289697fa8149eca10; Type: INDEX; Schema: pathwaysdos; Owner: release_manager
--

CREATE UNIQUE INDEX uniq_fa62cf5289697fa8149eca10 ON pathwaysdos.servicedispositions USING btree (serviceid, dispositionid);


--
-- Name: dispositiongroupdispositions afterrowdeletedispositiongroupdispositions; Type: TRIGGER; Schema: pathwaysdos; Owner: release_manager
--

CREATE TRIGGER afterrowdeletedispositiongroupdispositions AFTER DELETE ON pathwaysdos.dispositiongroupdispositions FOR EACH ROW EXECUTE PROCEDURE pathwaysdos.deletedispositiongroup();


--
-- Name: servicecapacitygrids afterrowdeleteservicecapacitygrids; Type: TRIGGER; Schema: pathwaysdos; Owner: release_manager
--

CREATE TRIGGER afterrowdeleteservicecapacitygrids AFTER DELETE ON pathwaysdos.servicecapacitygrids FOR EACH ROW EXECUTE PROCEDURE pathwaysdos.deletecapacitygrid();


--
-- Name: symptomgroupsymptomdiscriminators afterrowdeletesymptomgroupsymptomdiscriminators; Type: TRIGGER; Schema: pathwaysdos; Owner: release_manager
--

CREATE TRIGGER afterrowdeletesymptomgroupsymptomdiscriminators AFTER DELETE ON pathwaysdos.symptomgroupsymptomdiscriminators FOR EACH ROW EXECUTE PROCEDURE pathwaysdos.deletesymptomgroup();


--
-- Name: services beforerowinsertservices; Type: TRIGGER; Schema: pathwaysdos; Owner: release_manager
--

CREATE TRIGGER beforerowinsertservices BEFORE INSERT ON pathwaysdos.services FOR EACH ROW EXECUTE PROCEDURE pathwaysdos.assignservicesuid();


--
-- Name: servicereferralroles fk_15fd08b85d98f5af; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicereferralroles
    ADD CONSTRAINT fk_15fd08b85d98f5af FOREIGN KEY (referralroleid) REFERENCES pathwaysdos.referralroles(id) ON DELETE CASCADE;


--
-- Name: servicereferralroles fk_15fd08b889697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicereferralroles
    ADD CONSTRAINT fk_15fd08b889697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: usersavedsearches fk_206d130164b64dcc; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.usersavedsearches
    ADD CONSTRAINT fk_206d130164b64dcc FOREIGN KEY (userid) REFERENCES pathwaysdos.users(id) ON DELETE CASCADE;


--
-- Name: usersavedsearches fk_206d1301ddc59acc; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.usersavedsearches
    ADD CONSTRAINT fk_206d1301ddc59acc FOREIGN KEY (savedsearchid) REFERENCES pathwaysdos.savedsearches(id) ON DELETE CASCADE;


--
-- Name: serviceagerange fk_3150feb789697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceagerange
    ADD CONSTRAINT fk_3150feb789697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: servicesgsds fk_32508c7f7c74e29f; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicesgsds
    ADD CONSTRAINT fk_32508c7f7c74e29f FOREIGN KEY (sdid) REFERENCES pathwaysdos.symptomdiscriminators(id) ON DELETE CASCADE;


--
-- Name: servicesgsds fk_32508c7f7e325cc6; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicesgsds
    ADD CONSTRAINT fk_32508c7f7e325cc6 FOREIGN KEY (sgid) REFERENCES pathwaysdos.symptomgroups(id) ON DELETE CASCADE;


--
-- Name: servicesgsds fk_32508c7f89697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicesgsds
    ADD CONSTRAINT fk_32508c7f89697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: newsacknowledgedbyusers fk_3a1dd30f19d52895; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.newsacknowledgedbyusers
    ADD CONSTRAINT fk_3a1dd30f19d52895 FOREIGN KEY (newsid) REFERENCES pathwaysdos.news(id);


--
-- Name: newsacknowledgedbyusers fk_3a1dd30f64b64dcc; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.newsacknowledgedbyusers
    ADD CONSTRAINT fk_3a1dd30f64b64dcc FOREIGN KEY (userid) REFERENCES pathwaysdos.users(id) ON DELETE CASCADE;


--
-- Name: servicedayopenings fk_42566457194eb424; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicedayopenings
    ADD CONSTRAINT fk_42566457194eb424 FOREIGN KEY (dayid) REFERENCES pathwaysdos.openingtimedays(id);


--
-- Name: servicedayopenings fk_4256645789697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicedayopenings
    ADD CONSTRAINT fk_4256645789697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: capacitygridparentsheets fk_427a70a661325b4d; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridparentsheets
    ADD CONSTRAINT fk_427a70a661325b4d FOREIGN KEY (capacitygridsheetid) REFERENCES pathwaysdos.capacitygridsheets(capacitygridsheetid) ON DELETE CASCADE;


--
-- Name: capacitygridparentsheets fk_427a70a6a628ae7e; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridparentsheets
    ADD CONSTRAINT fk_427a70a6a628ae7e FOREIGN KEY (capacitygridparentid) REFERENCES pathwaysdos.capacitygridsheets(capacitygridsheetid) ON DELETE CASCADE;


--
-- Name: servicegenders fk_46360b4c827402c; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicegenders
    ADD CONSTRAINT fk_46360b4c827402c FOREIGN KEY (genderid) REFERENCES pathwaysdos.genders(id);


--
-- Name: servicegenders fk_46360b4c89697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicegenders
    ADD CONSTRAINT fk_46360b4c89697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: symptomgroupsymptomdiscriminators fk_49630122bacd168f; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.symptomgroupsymptomdiscriminators
    ADD CONSTRAINT fk_49630122bacd168f FOREIGN KEY (symptomgroupid) REFERENCES pathwaysdos.symptomgroups(id);


--
-- Name: symptomgroupsymptomdiscriminators fk_49630122d648d605; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.symptomgroupsymptomdiscriminators
    ADD CONSTRAINT fk_49630122d648d605 FOREIGN KEY (symptomdiscriminatorid) REFERENCES pathwaysdos.symptomdiscriminators(id) ON DELETE CASCADE;


--
-- Name: dispositiongroupdispositions fk_576ec73b149eca10; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositiongroupdispositions
    ADD CONSTRAINT fk_576ec73b149eca10 FOREIGN KEY (dispositionid) REFERENCES pathwaysdos.dispositions(id) ON DELETE CASCADE;


--
-- Name: dispositiongroupdispositions fk_576ec73b9bb73fe6; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositiongroupdispositions
    ADD CONSTRAINT fk_576ec73b9bb73fe6 FOREIGN KEY (dispositiongroupid) REFERENCES pathwaysdos.dispositiongroups(id) ON DELETE CASCADE;


--
-- Name: servicereferrals fk_59052f1554022ebc; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicereferrals
    ADD CONSTRAINT fk_59052f1554022ebc FOREIGN KEY (referredserviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: servicereferrals fk_59052f15f70c1dca; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicereferrals
    ADD CONSTRAINT fk_59052f15f70c1dca FOREIGN KEY (referralserviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: capacitygridcustomformulas fk_59e3a63685963223; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridcustomformulas
    ADD CONSTRAINT fk_59e3a63685963223 FOREIGN KEY (capacitygriddataid) REFERENCES pathwaysdos.capacitygriddata(capacitygriddataid) ON DELETE CASCADE;


--
-- Name: capacitygridservicetypes fk_5dc51fa261325b4d; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridservicetypes
    ADD CONSTRAINT fk_5dc51fa261325b4d FOREIGN KEY (capacitygridsheetid) REFERENCES pathwaysdos.capacitygridsheets(capacitygridsheetid) ON DELETE CASCADE;


--
-- Name: capacitygridservicetypes fk_5dc51fa2bf1290dd; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridservicetypes
    ADD CONSTRAINT fk_5dc51fa2bf1290dd FOREIGN KEY (servicetypeid) REFERENCES pathwaysdos.servicetypes(id) ON DELETE CASCADE;


--
-- Name: symptomdiscriminatorsynonyms fk_5dc998c1d648d605; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.symptomdiscriminatorsynonyms
    ADD CONSTRAINT fk_5dc998c1d648d605 FOREIGN KEY (symptomdiscriminatorid) REFERENCES pathwaysdos.symptomdiscriminators(id) ON DELETE CASCADE;


--
-- Name: dispositionservicetypes fk_67076541149eca10; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositionservicetypes
    ADD CONSTRAINT fk_67076541149eca10 FOREIGN KEY (dispositionid) REFERENCES pathwaysdos.dispositions(id) ON DELETE CASCADE;


--
-- Name: dispositionservicetypes fk_67076541bf1290dd; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositionservicetypes
    ADD CONSTRAINT fk_67076541bf1290dd FOREIGN KEY (servicetypeid) REFERENCES pathwaysdos.servicetypes(id) ON DELETE CASCADE;


--
-- Name: legacycollisions fk_6fd396b6f59fa73c; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.legacycollisions
    ADD CONSTRAINT fk_6fd396b6f59fa73c FOREIGN KEY (serviceagerangeid) REFERENCES pathwaysdos.serviceagerange(id) ON DELETE CASCADE;


--
-- Name: capacitygridheaders fk_714894ae61325b4d; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridheaders
    ADD CONSTRAINT fk_714894ae61325b4d FOREIGN KEY (capacitygridsheetid) REFERENCES pathwaysdos.capacitygridsheets(capacitygridsheetid) ON DELETE CASCADE;


--
-- Name: servicespecifiedopeningtimes fk_75adf67a6f27795; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicespecifiedopeningtimes
    ADD CONSTRAINT fk_75adf67a6f27795 FOREIGN KEY (servicespecifiedopeningdateid) REFERENCES pathwaysdos.servicespecifiedopeningdates(id) ON DELETE CASCADE;


--
-- Name: userregions fk_7727330664b64dcc; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userregions
    ADD CONSTRAINT fk_7727330664b64dcc FOREIGN KEY (userid) REFERENCES pathwaysdos.users(id) ON DELETE CASCADE;


--
-- Name: userregions fk_772733069962506a; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userregions
    ADD CONSTRAINT fk_772733069962506a FOREIGN KEY (regionid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: userreferralroles fk_7ec263ae5d98f5af; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userreferralroles
    ADD CONSTRAINT fk_7ec263ae5d98f5af FOREIGN KEY (referralroleid) REFERENCES pathwaysdos.referralroles(id) ON DELETE CASCADE;


--
-- Name: userreferralroles fk_7ec263ae64b64dcc; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userreferralroles
    ADD CONSTRAINT fk_7ec263ae64b64dcc FOREIGN KEY (userid) REFERENCES pathwaysdos.users(id) ON DELETE CASCADE;


--
-- Name: capacitygridsheethistories fk_84cebb7189697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridsheethistories
    ADD CONSTRAINT fk_84cebb7189697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: services fk_8a44833f10ee4cee; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.services
    ADD CONSTRAINT fk_8a44833f10ee4cee FOREIGN KEY (parentid) REFERENCES pathwaysdos.services(id);


--
-- Name: services fk_8a44833f6b848fb5; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.services
    ADD CONSTRAINT fk_8a44833f6b848fb5 FOREIGN KEY (subregionid) REFERENCES pathwaysdos.services(id);


--
-- Name: services fk_8a44833f9bf49490; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.services
    ADD CONSTRAINT fk_8a44833f9bf49490 FOREIGN KEY (typeid) REFERENCES pathwaysdos.servicetypes(id);


--
-- Name: services fk_8a44833ff112f078; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.services
    ADD CONSTRAINT fk_8a44833ff112f078 FOREIGN KEY (statusid) REFERENCES pathwaysdos.servicestatuses(id);


--
-- Name: serviceendpoints fk_9e65c23389697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceendpoints
    ADD CONSTRAINT fk_9e65c23389697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: servicerankingstrategies fk_a03561c689697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicerankingstrategies
    ADD CONSTRAINT fk_a03561c689697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: dispositiongroupservicetypes fk_a0953149bb73fe6; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositiongroupservicetypes
    ADD CONSTRAINT fk_a0953149bb73fe6 FOREIGN KEY (dispositiongroupid) REFERENCES pathwaysdos.dispositiongroups(id) ON DELETE CASCADE;


--
-- Name: dispositiongroupservicetypes fk_a095314bf1290dd; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.dispositiongroupservicetypes
    ADD CONSTRAINT fk_a095314bf1290dd FOREIGN KEY (servicetypeid) REFERENCES pathwaysdos.servicetypes(id) ON DELETE CASCADE;


--
-- Name: capacitygridtriggers fk_a2f43bd661325b4d; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridtriggers
    ADD CONSTRAINT fk_a2f43bd661325b4d FOREIGN KEY (capacitygridsheetid) REFERENCES pathwaysdos.capacitygridsheets(capacitygridsheetid) ON DELETE CASCADE;


--
-- Name: serviceagegroups fk_aaca31cf89697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceagegroups
    ADD CONSTRAINT fk_aaca31cf89697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: serviceagegroups fk_aaca31cfc2f62bd8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceagegroups
    ADD CONSTRAINT fk_aaca31cfc2f62bd8 FOREIGN KEY (agegroupid) REFERENCES pathwaysdos.agegroups(id) ON DELETE CASCADE;


--
-- Name: servicespecifiedopeningdates fk_b1f9f8f589697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicespecifiedopeningdates
    ADD CONSTRAINT fk_b1f9f8f589697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: permissionattributes fk_b5142da605405b0; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.permissionattributes
    ADD CONSTRAINT fk_b5142da605405b0 FOREIGN KEY (permissionid) REFERENCES pathwaysdos.permissions(id);


--
-- Name: permissionattributes fk_b5142da968c3886; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.permissionattributes
    ADD CONSTRAINT fk_b5142da968c3886 FOREIGN KEY (permissionattributedictid) REFERENCES pathwaysdos.permissionattributedict(id);


--
-- Name: userservices fk_be30a7b064b64dcc; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userservices
    ADD CONSTRAINT fk_be30a7b064b64dcc FOREIGN KEY (userid) REFERENCES pathwaysdos.users(id) ON DELETE CASCADE;


--
-- Name: userservices fk_be30a7b089697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userservices
    ADD CONSTRAINT fk_be30a7b089697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: capacitygriddata fk_c956674961325b4d; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygriddata
    ADD CONSTRAINT fk_c956674961325b4d FOREIGN KEY (capacitygridsheetid) REFERENCES pathwaysdos.capacitygridsheets(capacitygridsheetid) ON DELETE CASCADE;


--
-- Name: capacitygridcustomformulastyles fk_cd1c55096d95540f; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridcustomformulastyles
    ADD CONSTRAINT fk_cd1c55096d95540f FOREIGN KEY (formulaid) REFERENCES pathwaysdos.capacitygridcustomformulas(capacitygridcustomformulaid) ON DELETE CASCADE;


--
-- Name: capacitygridcustomformulastyles fk_cd1c55097015c8dc; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.capacitygridcustomformulastyles
    ADD CONSTRAINT fk_cd1c55097015c8dc FOREIGN KEY (styleid) REFERENCES pathwaysdos.capacitygridconditionalstyles(id) ON DELETE CASCADE;


--
-- Name: servicecapacitygrids fk_d9f6dd7e61325b4d; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicecapacitygrids
    ADD CONSTRAINT fk_d9f6dd7e61325b4d FOREIGN KEY (capacitygridsheetid) REFERENCES pathwaysdos.capacitygridsheets(capacitygridsheetid) ON DELETE CASCADE;


--
-- Name: servicecapacitygrids fk_d9f6dd7e87d85175; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicecapacitygrids
    ADD CONSTRAINT fk_d9f6dd7e87d85175 FOREIGN KEY (servicecapacityid) REFERENCES pathwaysdos.servicecapacities(id) ON DELETE CASCADE;


--
-- Name: userpermissions fk_e7984bb2605405b0; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userpermissions
    ADD CONSTRAINT fk_e7984bb2605405b0 FOREIGN KEY (permissionid) REFERENCES pathwaysdos.permissions(id) ON DELETE CASCADE;


--
-- Name: userpermissions fk_e7984bb264b64dcc; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.userpermissions
    ADD CONSTRAINT fk_e7984bb264b64dcc FOREIGN KEY (userid) REFERENCES pathwaysdos.users(id) ON DELETE CASCADE;


--
-- Name: servicedayopeningtimes fk_e835fd1f6ebd7092; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicedayopeningtimes
    ADD CONSTRAINT fk_e835fd1f6ebd7092 FOREIGN KEY (servicedayopeningid) REFERENCES pathwaysdos.servicedayopenings(id) ON DELETE CASCADE;


--
-- Name: newsforpermissions fk_ee31b38c19d52895; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.newsforpermissions
    ADD CONSTRAINT fk_ee31b38c19d52895 FOREIGN KEY (newsid) REFERENCES pathwaysdos.news(id);


--
-- Name: newsforpermissions fk_ee31b38c605405b0; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.newsforpermissions
    ADD CONSTRAINT fk_ee31b38c605405b0 FOREIGN KEY (permissionid) REFERENCES pathwaysdos.permissions(id);


--
-- Name: changes fk_ef9d81a189697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.changes
    ADD CONSTRAINT fk_ef9d81a189697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: servicedispositions fk_fa62cf52149eca10; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicedispositions
    ADD CONSTRAINT fk_fa62cf52149eca10 FOREIGN KEY (dispositionid) REFERENCES pathwaysdos.dispositions(id) ON DELETE CASCADE;


--
-- Name: servicedispositions fk_fa62cf5289697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicedispositions
    ADD CONSTRAINT fk_fa62cf5289697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: servicecapacities fk_fbf2e96844c57db; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicecapacities
    ADD CONSTRAINT fk_fbf2e96844c57db FOREIGN KEY (capacitystatusid) REFERENCES pathwaysdos.capacitystatuses(capacitystatusid) ON DELETE CASCADE;


--
-- Name: servicecapacities fk_fbf2e9689697fa8; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicecapacities
    ADD CONSTRAINT fk_fbf2e9689697fa8 FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id) ON DELETE CASCADE;


--
-- Name: organisationpostcodes fk_op_location_id; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationpostcodes
    ADD CONSTRAINT fk_op_location_id FOREIGN KEY (locationid) REFERENCES pathwaysdos.locations(id) ON DELETE CASCADE;


--
-- Name: organisationpostcodes fk_op_organisation_id; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationpostcodes
    ADD CONSTRAINT fk_op_organisation_id FOREIGN KEY (organisationid) REFERENCES pathwaysdos.organisations(id) ON DELETE CASCADE;


--
-- Name: organisations fk_organisation_organisationtype; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisations
    ADD CONSTRAINT fk_organisation_organisationtype FOREIGN KEY (organisationtypeid) REFERENCES pathwaysdos.organisationtypes(id);


--
-- Name: organisationrankingstrategies fk_ors_organisation_id; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationrankingstrategies
    ADD CONSTRAINT fk_ors_organisation_id FOREIGN KEY (organisationid) REFERENCES pathwaysdos.organisations(id) ON DELETE CASCADE;


--
-- Name: organisationrankingstrategies fk_ors_servicetype_id; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.organisationrankingstrategies
    ADD CONSTRAINT fk_ors_servicetype_id FOREIGN KEY (servicetypeid) REFERENCES pathwaysdos.servicetypes(id) ON DELETE CASCADE;


--
-- Name: services fk_services_organisation_id; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.services
    ADD CONSTRAINT fk_services_organisation_id FOREIGN KEY (organisationid) REFERENCES pathwaysdos.organisations(id);


--
-- Name: servicealignments servicealignments_commissioningorganisationid_fkey; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicealignments
    ADD CONSTRAINT servicealignments_commissioningorganisationid_fkey FOREIGN KEY (commissioningorganisationid) REFERENCES pathwaysdos.services(id);


--
-- Name: servicealignments servicealignments_serviceid_fkey; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicealignments
    ADD CONSTRAINT servicealignments_serviceid_fkey FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id);


--
-- Name: serviceattributes serviceattributes_createduserid_fkey; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceattributes
    ADD CONSTRAINT serviceattributes_createduserid_fkey FOREIGN KEY (createduserid) REFERENCES pathwaysdos.users(id);


--
-- Name: serviceattributes serviceattributes_modifieduserid_fkey; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceattributes
    ADD CONSTRAINT serviceattributes_modifieduserid_fkey FOREIGN KEY (modifieduserid) REFERENCES pathwaysdos.users(id);


--
-- Name: serviceattributes serviceattributes_serviceattributetypeid_fkey; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceattributes
    ADD CONSTRAINT serviceattributes_serviceattributetypeid_fkey FOREIGN KEY (serviceattributetypeid) REFERENCES pathwaysdos.serviceattributetypes(id);


--
-- Name: serviceattributevalues serviceattributevalues_serviceattributeid_fkey; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceattributevalues
    ADD CONSTRAINT serviceattributevalues_serviceattributeid_fkey FOREIGN KEY (serviceattributeid) REFERENCES pathwaysdos.serviceattributes(id);


--
-- Name: serviceserviceattributes serviceserviceattributes_serviceattributeid_fkey; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceserviceattributes
    ADD CONSTRAINT serviceserviceattributes_serviceattributeid_fkey FOREIGN KEY (serviceattributeid) REFERENCES pathwaysdos.serviceattributes(id);


--
-- Name: serviceserviceattributes serviceserviceattributes_serviceattributevalueid_fkey; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceserviceattributes
    ADD CONSTRAINT serviceserviceattributes_serviceattributevalueid_fkey FOREIGN KEY (serviceattributevalueid) REFERENCES pathwaysdos.serviceattributevalues(id);


--
-- Name: serviceserviceattributes serviceserviceattributes_serviceid_fkey; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.serviceserviceattributes
    ADD CONSTRAINT serviceserviceattributes_serviceid_fkey FOREIGN KEY (serviceid) REFERENCES pathwaysdos.services(id);


--
-- Name: SCHEMA extn_pgcrypto; Type: ACL; Schema: -; Owner: release_manager
--

GRANT USAGE ON SCHEMA extn_pgcrypto TO pathwaysdos_read_grp;


--
-- Name: SCHEMA pathwaysdos; Type: ACL; Schema: -; Owner: release_manager
--

GRANT USAGE ON SCHEMA pathwaysdos TO pathwaysdos_read_grp;
GRANT USAGE ON SCHEMA pathwaysdos TO pathwaysdos_write_grp;
GRANT USAGE ON SCHEMA pathwaysdos TO pathwaysdos_auth_grp;


--
-- Name: SCHEMA pgagent; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA pgagent TO release_manager;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.armor(bytea) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.armor(bytea) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.armor(bytea) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.armor(bytea, text[], text[]) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.armor(bytea, text[], text[]) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.armor(bytea, text[], text[]) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.crypt(text, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.crypt(text, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.crypt(text, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.dearmor(text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.dearmor(text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.dearmor(text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.decrypt(bytea, bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.decrypt(bytea, bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.decrypt(bytea, bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.decrypt_iv(bytea, bytea, bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.decrypt_iv(bytea, bytea, bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.decrypt_iv(bytea, bytea, bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.digest(bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.digest(bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.digest(bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.digest(text, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.digest(text, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.digest(text, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.encrypt(bytea, bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.encrypt(bytea, bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.encrypt(bytea, bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.encrypt_iv(bytea, bytea, bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.encrypt_iv(bytea, bytea, bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.encrypt_iv(bytea, bytea, bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.gen_random_bytes(integer) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.gen_random_bytes(integer) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.gen_random_bytes(integer) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.gen_random_uuid() TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.gen_random_uuid() TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.gen_random_uuid() TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.gen_salt(text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.gen_salt(text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.gen_salt(text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.gen_salt(text, integer) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.gen_salt(text, integer) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.gen_salt(text, integer) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.hmac(bytea, bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.hmac(bytea, bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.hmac(bytea, bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.hmac(text, text, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.hmac(text, text, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.hmac(text, text, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_armor_headers(text, OUT key text, OUT value text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_armor_headers(text, OUT key text, OUT value text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_armor_headers(text, OUT key text, OUT value text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_key_id(bytea) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_key_id(bytea) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_key_id(bytea) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt(bytea, bytea) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt(bytea, bytea) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt(bytea, bytea) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt(bytea, bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt(bytea, bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt(bytea, bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt(bytea, bytea, text, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt(bytea, bytea, text, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt(bytea, bytea, text, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt_bytea(bytea, bytea) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt_bytea(bytea, bytea) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt_bytea(bytea, bytea) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt_bytea(bytea, bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt_bytea(bytea, bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt_bytea(bytea, bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt(text, bytea) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt(text, bytea) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt(text, bytea) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt(text, bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt(text, bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt(text, bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt_bytea(bytea, bytea) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt_bytea(bytea, bytea) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt_bytea(bytea, bytea) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt_bytea(bytea, bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt_bytea(bytea, bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_pub_encrypt_bytea(bytea, bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt(bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt(bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt(bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt(bytea, text, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt(bytea, text, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt(bytea, text, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt_bytea(bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt_bytea(bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt_bytea(bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt_bytea(bytea, text, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt_bytea(bytea, text, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_decrypt_bytea(bytea, text, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt(text, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt(text, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt(text, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt(text, text, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt(text, text, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt(text, text, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt_bytea(bytea, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt_bytea(bytea, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt_bytea(bytea, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extn_pgcrypto; Owner: postgres
--

GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt_bytea(bytea, text, text) TO release_manager WITH GRANT OPTION;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt_bytea(bytea, text, text) TO pathwaysdos_read_grp;
SET SESSION AUTHORIZATION release_manager;
GRANT ALL ON FUNCTION extn_pgcrypto.pgp_sym_encrypt_bytea(bytea, text, text) TO pathwaysdos_read_grp;
RESET SESSION AUTHORIZATION;

--
-- Name: TABLE agegroups; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.agegroups TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.agegroups TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.agegroups TO pathwaysdos_write_grp;


--
-- Name: TABLE capacitygridconditionalstyles; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.capacitygridconditionalstyles TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.capacitygridconditionalstyles TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.capacitygridconditionalstyles TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE capacitygridconditionalstyles_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.capacitygridconditionalstyles_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE capacitygridcustomformulas; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.capacitygridcustomformulas TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.capacitygridcustomformulas TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.capacitygridcustomformulas TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE capacitygridcustomformulas_capacitygridcustomformulaid_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.capacitygridcustomformulas_capacitygridcustomformulaid_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE capacitygridcustomformulastyles; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.capacitygridcustomformulastyles TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.capacitygridcustomformulastyles TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.capacitygridcustomformulastyles TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE capacitygridcustomformulastyles_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.capacitygridcustomformulastyles_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE capacitygriddata; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.capacitygriddata TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.capacitygriddata TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.capacitygriddata TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE capacitygriddata_capacitygriddataid_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.capacitygriddata_capacitygriddataid_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE capacitygridheaders; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.capacitygridheaders TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.capacitygridheaders TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.capacitygridheaders TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE capacitygridheaders_capacitygridheaderid_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.capacitygridheaders_capacitygridheaderid_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE capacitygridparentsheets; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.capacitygridparentsheets TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.capacitygridparentsheets TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.capacitygridparentsheets TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE capacitygridparentsheets_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.capacitygridparentsheets_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE capacitygridservicetypes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.capacitygridservicetypes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.capacitygridservicetypes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.capacitygridservicetypes TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE capacitygridservicetypes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.capacitygridservicetypes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE capacitygridsheethistories; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.capacitygridsheethistories TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.capacitygridsheethistories TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.capacitygridsheethistories TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE capacitygridsheethistories_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.capacitygridsheethistories_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE capacitygridsheets; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.capacitygridsheets TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.capacitygridsheets TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.capacitygridsheets TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE capacitygridsheets_capacitygridsheetid_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.capacitygridsheets_capacitygridsheetid_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE capacitygridtriggers; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.capacitygridtriggers TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.capacitygridtriggers TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.capacitygridtriggers TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE capacitygridtriggers_capacitygridtriggerid_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.capacitygridtriggers_capacitygridtriggerid_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE capacitystatuses; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.capacitystatuses TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.capacitystatuses TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.capacitystatuses TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE capacitystatuses_capacitystatusid_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.capacitystatuses_capacitystatusid_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE changes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.changes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.changes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.changes TO pathwaysdos_write_grp;


--
-- Name: TABLE dispositiongroupdispositions; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.dispositiongroupdispositions TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.dispositiongroupdispositions TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.dispositiongroupdispositions TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE dispositiongroupdispositions_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.dispositiongroupdispositions_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE dispositiongroups; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.dispositiongroups TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.dispositiongroups TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.dispositiongroups TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE dispositiongroups_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.dispositiongroups_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE dispositiongroupservicetypes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.dispositiongroupservicetypes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.dispositiongroupservicetypes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.dispositiongroupservicetypes TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE dispositiongroupservicetypes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.dispositiongroupservicetypes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE dispositions; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.dispositions TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.dispositions TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.dispositions TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE dispositions_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.dispositions_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE dispositionservicetypes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.dispositionservicetypes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.dispositionservicetypes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.dispositionservicetypes TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE dispositionservicetypes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.dispositionservicetypes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE genders; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.genders TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.genders TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.genders TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE genders_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.genders_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE jobqueue; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.jobqueue TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.jobqueue TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.jobqueue TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE jobqueue_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.jobqueue_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE json_corrections; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.json_corrections TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.json_corrections TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.json_corrections TO pathwaysdos_write_grp;


--
-- Name: TABLE json_corrections_p2; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.json_corrections_p2 TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.json_corrections_p2 TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.json_corrections_p2 TO pathwaysdos_write_grp;


--
-- Name: TABLE legacycollisions; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.legacycollisions TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.legacycollisions TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.legacycollisions TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE legacycollisions_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.legacycollisions_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE locations; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.locations TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.locations TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.locations TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE locations_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.locations_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE news; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.news TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.news TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.news TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE news_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.news_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE newsacknowledgedbyusers; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.newsacknowledgedbyusers TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.newsacknowledgedbyusers TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.newsacknowledgedbyusers TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE newsacknowledgedbyusers_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.newsacknowledgedbyusers_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE newsforpermissions; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.newsforpermissions TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.newsforpermissions TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.newsforpermissions TO pathwaysdos_write_grp;


--
-- Name: TABLE newsforpermissions4_16_1; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.newsforpermissions4_16_1 TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.newsforpermissions4_16_1 TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.newsforpermissions4_16_1 TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE newsforpermissions_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.newsforpermissions_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE odsimports; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.odsimports TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.odsimports TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.odsimports TO pathwaysdos_write_grp;
GRANT TRUNCATE ON TABLE pathwaysdos.odsimports TO pathwaysdos;


--
-- Name: SEQUENCE odsimports_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.odsimports_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE odspostcodes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.odspostcodes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.odspostcodes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.odspostcodes TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE odspostcodes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.odspostcodes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE openingtimedays; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.openingtimedays TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.openingtimedays TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.openingtimedays TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE openingtimedays_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.openingtimedays_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE organisationpostcodes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.organisationpostcodes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.organisationpostcodes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.organisationpostcodes TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE organisationpostcodes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.organisationpostcodes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE organisationrankingstrategies; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.organisationrankingstrategies TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.organisationrankingstrategies TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.organisationrankingstrategies TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE organisationrankingstrategies_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.organisationrankingstrategies_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE organisations; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.organisations TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.organisations TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.organisations TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE organisations_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.organisations_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE organisationtypes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.organisationtypes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.organisationtypes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.organisationtypes TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE organisationtypes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.organisationtypes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE permissionattributedict; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.permissionattributedict TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.permissionattributedict TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.permissionattributedict TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE permissionattributedict_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.permissionattributedict_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE permissionattributes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.permissionattributes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.permissionattributes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.permissionattributes TO pathwaysdos_write_grp;


--
-- Name: TABLE permissionattributes4_16_1; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.permissionattributes4_16_1 TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.permissionattributes4_16_1 TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.permissionattributes4_16_1 TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE permissionattributes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.permissionattributes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE permissions; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.permissions TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.permissions TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.permissions TO pathwaysdos_write_grp;


--
-- Name: TABLE permissions4_16_1; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.permissions4_16_1 TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.permissions4_16_1 TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.permissions4_16_1 TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE permissions_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.permissions_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE publicholidays; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.publicholidays TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.publicholidays TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.publicholidays TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE publicholidays_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.publicholidays_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE purgedusers; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.purgedusers TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.purgedusers TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.purgedusers TO pathwaysdos_write_grp;


--
-- Name: TABLE referralroles; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.referralroles TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.referralroles TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.referralroles TO pathwaysdos_write_grp;


--
-- Name: TABLE report_nhs_choices; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.report_nhs_choices TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.report_nhs_choices TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.report_nhs_choices TO pathwaysdos_write_grp;


--
-- Name: TABLE savedsearches; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.savedsearches TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.savedsearches TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.savedsearches TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE savedsearches_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.savedsearches_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE searchdistances; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.searchdistances TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.searchdistances TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.searchdistances TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE searchdistances_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.searchdistances_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE searchimports; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.searchimports TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.searchimports TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.searchimports TO pathwaysdos_write_grp;
GRANT TRUNCATE ON TABLE pathwaysdos.searchimports TO pathwaysdos;


--
-- Name: SEQUENCE searchimports_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.searchimports_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE serviceagegroups; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.serviceagegroups TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.serviceagegroups TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.serviceagegroups TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE serviceagegroups_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.serviceagegroups_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE serviceagerange; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.serviceagerange TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.serviceagerange TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.serviceagerange TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE serviceagerange_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.serviceagerange_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicealignments; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicealignments TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicealignments TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicealignments TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicealignments_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicealignments_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE serviceattributes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.serviceattributes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.serviceattributes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.serviceattributes TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE serviceattributes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.serviceattributes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE serviceattributetypes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.serviceattributetypes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.serviceattributetypes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.serviceattributetypes TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE serviceattributetypes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.serviceattributetypes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE serviceattributevalues; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.serviceattributevalues TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.serviceattributevalues TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.serviceattributevalues TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE serviceattributevalues_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.serviceattributevalues_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicecapacities; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicecapacities TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicecapacities TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicecapacities TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicecapacities_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicecapacities_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicecapacitygrids; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicecapacitygrids TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicecapacitygrids TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicecapacitygrids TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicecapacitygrids_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicecapacitygrids_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicedayopenings; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicedayopenings TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicedayopenings TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicedayopenings TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicedayopenings_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicedayopenings_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicedayopeningtimes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicedayopeningtimes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicedayopeningtimes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicedayopeningtimes TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicedayopeningtimes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicedayopeningtimes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicedispositions; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicedispositions TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicedispositions TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicedispositions TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicedispositions_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicedispositions_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE serviceendpoints; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.serviceendpoints TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.serviceendpoints TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.serviceendpoints TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE serviceendpoints_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.serviceendpoints_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicegenders; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicegenders TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicegenders TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicegenders TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicegenders_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicegenders_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicehistories; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicehistories TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicehistories TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicehistories TO pathwaysdos_write_grp;


--
-- Name: TABLE servicerankingstrategies; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicerankingstrategies TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicerankingstrategies TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicerankingstrategies TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicerankingstrategies_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicerankingstrategies_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicereferralroles; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicereferralroles TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicereferralroles TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicereferralroles TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicereferralroles_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicereferralroles_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicereferrals; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicereferrals TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicereferrals TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicereferrals TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicereferrals_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicereferrals_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE services; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.services TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.services TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.services TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE services_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.services_id_seq TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE services_uid_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.services_uid_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE serviceserviceattributes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.serviceserviceattributes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.serviceserviceattributes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.serviceserviceattributes TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE serviceserviceattributes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.serviceserviceattributes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicesgsds; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicesgsds TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicesgsds TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicesgsds TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicesgsds_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicesgsds_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicespecifiedopeningdates; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicespecifiedopeningdates TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicespecifiedopeningdates TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicespecifiedopeningdates TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicespecifiedopeningdates_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicespecifiedopeningdates_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicespecifiedopeningtimes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicespecifiedopeningtimes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicespecifiedopeningtimes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicespecifiedopeningtimes TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicespecifiedopeningtimes_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicespecifiedopeningtimes_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicestatuses; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicestatuses TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicestatuses TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicestatuses TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE servicestatuses_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.servicestatuses_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE servicetypes; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.servicetypes TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.servicetypes TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.servicetypes TO pathwaysdos_write_grp;


--
-- Name: TABLE srsbackup; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.srsbackup TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.srsbackup TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.srsbackup TO pathwaysdos_write_grp;


--
-- Name: TABLE symptomdiscriminators; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.symptomdiscriminators TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.symptomdiscriminators TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.symptomdiscriminators TO pathwaysdos_write_grp;


--
-- Name: TABLE symptomdiscriminatorsynonyms; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.symptomdiscriminatorsynonyms TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.symptomdiscriminatorsynonyms TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.symptomdiscriminatorsynonyms TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE symptomdiscriminatorsynonyms_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.symptomdiscriminatorsynonyms_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE symptomgroups; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.symptomgroups TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.symptomgroups TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.symptomgroups TO pathwaysdos_write_grp;


--
-- Name: TABLE symptomgroupsymptomdiscriminators; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.symptomgroupsymptomdiscriminators TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.symptomgroupsymptomdiscriminators TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.symptomgroupsymptomdiscriminators TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE symptomgroupsymptomdiscriminators_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.symptomgroupsymptomdiscriminators_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE userpermissions; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.userpermissions TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.userpermissions TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.userpermissions TO pathwaysdos_write_grp;


--
-- Name: TABLE userpermissions4_16_1; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.userpermissions4_16_1 TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.userpermissions4_16_1 TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.userpermissions4_16_1 TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE userpermissions_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.userpermissions_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE userreferralroles; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.userreferralroles TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.userreferralroles TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.userreferralroles TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE userreferralroles_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.userreferralroles_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE userregions; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.userregions TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.userregions TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.userregions TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE userregions_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.userregions_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE users; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.users TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.users TO pathwaysdos_read_grp;
GRANT INSERT,DELETE ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.id; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(id) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.username; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(username) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.firstname; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(firstname) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.lastname; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(lastname) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.email; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(email) ON TABLE pathwaysdos.users TO pathwaysdos_auth_grp;
GRANT UPDATE(email) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.password; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(password) ON TABLE pathwaysdos.users TO pathwaysdos_auth_grp;
GRANT UPDATE(password) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.badpasswordcount; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(badpasswordcount) ON TABLE pathwaysdos.users TO pathwaysdos_auth_grp;


--
-- Name: COLUMN users.badpasswordtime; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(badpasswordtime) ON TABLE pathwaysdos.users TO pathwaysdos_auth_grp;


--
-- Name: COLUMN users.phone; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(phone) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.status; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(status) ON TABLE pathwaysdos.users TO pathwaysdos_auth_grp;
GRANT UPDATE(status) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.createdtime; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(createdtime) ON TABLE pathwaysdos.users TO pathwaysdos_auth_grp;
GRANT UPDATE(createdtime) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.lastlogintime; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(lastlogintime) ON TABLE pathwaysdos.users TO pathwaysdos_auth_grp;
GRANT UPDATE(lastlogintime) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.homeorganisation; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(homeorganisation) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.accessreason; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(accessreason) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.approvedby; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(approvedby) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.approveddate; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(approveddate) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: COLUMN users.validationtoken; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT UPDATE(validationtoken) ON TABLE pathwaysdos.users TO pathwaysdos_auth_grp;
GRANT UPDATE(validationtoken) ON TABLE pathwaysdos.users TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.users_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE usersavedsearches; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.usersavedsearches TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.usersavedsearches TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.usersavedsearches TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE usersavedsearches_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.usersavedsearches_id_seq TO pathwaysdos_write_grp;


--
-- Name: TABLE userservices; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT SELECT ON TABLE pathwaysdos.userservices TO pathwaysdos_auth_grp;
GRANT SELECT ON TABLE pathwaysdos.userservices TO pathwaysdos_read_grp;
GRANT INSERT,DELETE,UPDATE ON TABLE pathwaysdos.userservices TO pathwaysdos_write_grp;


--
-- Name: SEQUENCE userservices_id_seq; Type: ACL; Schema: pathwaysdos; Owner: release_manager
--

GRANT USAGE ON SEQUENCE pathwaysdos.userservices_id_seq TO pathwaysdos_write_grp;

--
-- PostgreSQL database dump complete
--

