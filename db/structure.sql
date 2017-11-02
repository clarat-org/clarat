SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: absences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE absences (
    id integer NOT NULL,
    starts_at date NOT NULL,
    ends_at date NOT NULL,
    user_id integer NOT NULL,
    sync boolean DEFAULT true
);


--
-- Name: absences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE absences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: absences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE absences_id_seq OWNED BY absences.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE areas (
    id integer NOT NULL,
    name character varying NOT NULL,
    minlat double precision NOT NULL,
    maxlat double precision NOT NULL,
    minlong double precision NOT NULL,
    maxlong double precision NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE areas_id_seq OWNED BY areas.id;


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE assignments (
    id integer NOT NULL,
    assignable_id integer NOT NULL,
    assignable_type character varying(32) NOT NULL,
    assignable_field_type character varying(64) DEFAULT ''::character varying NOT NULL,
    creator_id integer,
    creator_team_id integer,
    receiver_id integer,
    receiver_team_id integer,
    message character varying(1000),
    parent_id integer,
    aasm_state character varying(32) DEFAULT 'open'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    topic character varying,
    created_by_system boolean DEFAULT false
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignments_id_seq OWNED BY assignments.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    id integer NOT NULL,
    name_de character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    icon character varying(12),
    parent_id integer,
    sort_order integer,
    visible boolean DEFAULT true,
    name_en character varying,
    name_ar character varying,
    name_fr character varying,
    name_pl character varying,
    name_tr character varying,
    name_ru character varying,
    name_fa character varying,
    keywords_de text,
    keywords_en text,
    keywords_ar text,
    keywords_fa text,
    explanations_de text,
    explanations_en text,
    explanations_ar text,
    explanations_fa text
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: categories_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories_offers (
    offer_id integer NOT NULL,
    category_id integer NOT NULL
);


--
-- Name: categories_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories_sections (
    id integer NOT NULL,
    category_id integer,
    section_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: categories_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_sections_id_seq OWNED BY categories_sections.id;


--
-- Name: category_hierarchies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE category_hierarchies (
    ancestor_id integer NOT NULL,
    descendant_id integer NOT NULL,
    generations integer NOT NULL
);


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cities (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cities_id_seq OWNED BY cities.id;


--
-- Name: contact_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contact_people (
    id integer NOT NULL,
    organization_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    area_code_1 character varying(6),
    local_number_1 character varying(32),
    area_code_2 character varying(6),
    local_number_2 character varying(32),
    fax_area_code character varying(6),
    fax_number character varying(32),
    first_name character varying,
    last_name character varying,
    operational_name character varying,
    academic_title character varying,
    gender character varying,
    responsibility character varying,
    email_id integer,
    spoc boolean DEFAULT false NOT NULL,
    "position" character varying,
    street character varying(255),
    zip_and_city character varying(255)
);


--
-- Name: contact_people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contact_people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contact_people_id_seq OWNED BY contact_people.id;


--
-- Name: contact_person_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contact_person_offers (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    contact_person_id integer NOT NULL
);


--
-- Name: contact_person_offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contact_person_offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_person_offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contact_person_offers_id_seq OWNED BY contact_person_offers.id;


--
-- Name: contact_person_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contact_person_translations (
    id integer NOT NULL,
    contact_person_id integer NOT NULL,
    locale character varying NOT NULL,
    source character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    responsibility text
);


--
-- Name: contact_person_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contact_person_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_person_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contact_person_translations_id_seq OWNED BY contact_person_translations.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contacts (
    id integer NOT NULL,
    name character varying,
    email character varying,
    message text,
    url character varying(1000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    internal_mail boolean DEFAULT false,
    city character varying
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE definitions (
    id integer NOT NULL,
    key text NOT NULL,
    explanation text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE definitions_id_seq OWNED BY definitions.id;


--
-- Name: definitions_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE definitions_offers (
    id integer NOT NULL,
    definition_id integer NOT NULL,
    offer_id integer NOT NULL
);


--
-- Name: definitions_offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE definitions_offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: definitions_offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE definitions_offers_id_seq OWNED BY definitions_offers.id;


--
-- Name: definitions_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE definitions_organizations (
    id integer NOT NULL,
    definition_id integer NOT NULL,
    organization_id integer NOT NULL
);


--
-- Name: definitions_organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE definitions_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: definitions_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE definitions_organizations_id_seq OWNED BY definitions_organizations.id;


--
-- Name: divisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE divisions (
    id integer NOT NULL,
    addition character varying,
    organization_id integer,
    section_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comment text,
    done boolean DEFAULT false,
    size character varying DEFAULT 'medium'::character varying NOT NULL,
    city_id integer,
    area_id integer
);


--
-- Name: divisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE divisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: divisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE divisions_id_seq OWNED BY divisions.id;


--
-- Name: divisions_presumed_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE divisions_presumed_categories (
    division_id integer NOT NULL,
    category_id integer NOT NULL
);


--
-- Name: divisions_presumed_solution_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE divisions_presumed_solution_categories (
    division_id integer NOT NULL,
    solution_category_id integer NOT NULL
);


--
-- Name: emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE emails (
    id integer NOT NULL,
    address character varying(64) NOT NULL,
    aasm_state character varying(32) DEFAULT 'uninformed'::character varying NOT NULL,
    security_code character varying(36),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE emails_id_seq OWNED BY emails.id;


--
-- Name: federal_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE federal_states (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: federal_states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE federal_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: federal_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE federal_states_id_seq OWNED BY federal_states.id;


--
-- Name: filters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE filters (
    id integer NOT NULL,
    name character varying NOT NULL,
    identifier character varying(35) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying NOT NULL,
    section_id integer
);


--
-- Name: filters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE filters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: filters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE filters_id_seq OWNED BY filters.id;


--
-- Name: filters_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE filters_offers (
    filter_id integer NOT NULL,
    offer_id integer NOT NULL
);


--
-- Name: filters_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE filters_organizations (
    filter_id integer NOT NULL,
    organization_id integer NOT NULL
);


--
-- Name: gengo_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gengo_orders (
    id integer NOT NULL,
    order_id integer,
    expected_slug character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: gengo_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gengo_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gengo_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gengo_orders_id_seq OWNED BY gengo_orders.id;


--
-- Name: hyperlinks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hyperlinks (
    id integer NOT NULL,
    linkable_id integer NOT NULL,
    linkable_type character varying(40) NOT NULL,
    website_id integer NOT NULL
);


--
-- Name: hyperlinks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hyperlinks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hyperlinks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hyperlinks_id_seq OWNED BY hyperlinks.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE locations (
    id integer NOT NULL,
    street character varying NOT NULL,
    addition text,
    zip character varying NOT NULL,
    hq boolean,
    latitude double precision,
    longitude double precision,
    organization_id integer,
    federal_state_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying,
    display_name character varying NOT NULL,
    visible boolean DEFAULT true,
    in_germany boolean DEFAULT true,
    city_id integer
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: logic_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE logic_versions (
    id integer NOT NULL,
    version integer,
    name character varying,
    description text
);


--
-- Name: logic_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE logic_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: logic_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE logic_versions_id_seq OWNED BY logic_versions.id;


--
-- Name: next_steps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE next_steps (
    id integer NOT NULL,
    text_de character varying NOT NULL,
    text_en character varying,
    text_ar character varying,
    text_fr character varying,
    text_pl character varying,
    text_tr character varying,
    text_ru character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    text_fa character varying
);


--
-- Name: next_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE next_steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: next_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE next_steps_id_seq OWNED BY next_steps.id;


--
-- Name: next_steps_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE next_steps_offers (
    id integer NOT NULL,
    next_step_id integer NOT NULL,
    offer_id integer NOT NULL,
    sort_value integer DEFAULT 0
);


--
-- Name: next_steps_offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE next_steps_offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: next_steps_offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE next_steps_offers_id_seq OWNED BY next_steps_offers.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notes (
    id integer NOT NULL,
    text text NOT NULL,
    topic character varying(32),
    user_id integer NOT NULL,
    notable_id integer NOT NULL,
    notable_type character varying(64) NOT NULL,
    referencable_id integer,
    referencable_type character varying(64),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


--
-- Name: offer_mailings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE offer_mailings (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    email_id integer NOT NULL,
    mailing_type character varying(16) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: offer_mailings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offer_mailings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offer_mailings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offer_mailings_id_seq OWNED BY offer_mailings.id;


--
-- Name: offer_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE offer_translations (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    locale character varying NOT NULL,
    source character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    old_next_steps text,
    opening_specification text,
    possibly_outdated boolean DEFAULT false
);


--
-- Name: offer_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offer_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offer_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offer_translations_id_seq OWNED BY offer_translations.id;


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE offers (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    description text NOT NULL,
    old_next_steps text,
    encounter character varying,
    slug character varying,
    location_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    opening_specification text,
    approved_at timestamp without time zone,
    created_by integer,
    approved_by integer,
    expires_at date NOT NULL,
    area_id integer,
    description_html text,
    next_steps_html text,
    opening_specification_html text,
    target_audience character varying,
    aasm_state character varying(32),
    hide_contact_people boolean DEFAULT false,
    code_word character varying(140),
    solution_category_id integer,
    logic_version_id integer,
    split_base_id integer,
    all_inclusive boolean DEFAULT false,
    starts_at date,
    completed_at timestamp without time zone,
    completed_by integer,
    section_id integer
);


--
-- Name: offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offers_id_seq OWNED BY offers.id;


--
-- Name: offers_openings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE offers_openings (
    offer_id integer NOT NULL,
    opening_id integer NOT NULL
);


--
-- Name: openings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE openings (
    id integer NOT NULL,
    day character varying(3) NOT NULL,
    open time without time zone,
    close time without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    sort_value integer,
    name character varying NOT NULL
);


--
-- Name: openings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE openings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: openings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE openings_id_seq OWNED BY openings.id;


--
-- Name: organization_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE organization_offers (
    id integer NOT NULL,
    offer_id integer NOT NULL,
    organization_id integer NOT NULL
);


--
-- Name: organization_offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organization_offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organization_offers_id_seq OWNED BY organization_offers.id;


--
-- Name: organization_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE organization_translations (
    id integer NOT NULL,
    organization_id integer NOT NULL,
    locale character varying NOT NULL,
    source character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description text DEFAULT ''::text NOT NULL,
    possibly_outdated boolean DEFAULT false
);


--
-- Name: organization_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organization_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organization_translations_id_seq OWNED BY organization_translations.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE organizations (
    id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    legal_form text,
    charitable boolean DEFAULT false,
    founded integer,
    slug character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    approved_at timestamp without time zone,
    offers_count integer DEFAULT 0,
    locations_count integer DEFAULT 0,
    created_by integer,
    approved_by integer,
    accredited_institution boolean DEFAULT false,
    description_html text,
    aasm_state character varying(32),
    mailings character varying(255) DEFAULT 'disabled'::character varying NOT NULL,
    priority boolean DEFAULT false NOT NULL,
    comment text,
    website_id integer,
    pending_reason character varying
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: search_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE search_locations (
    id integer NOT NULL,
    query character varying NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    geoloc character varying(35) NOT NULL
);


--
-- Name: search_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE search_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: search_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE search_locations_id_seq OWNED BY search_locations.id;


--
-- Name: sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sections (
    id integer NOT NULL,
    name character varying,
    identifier character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sections_id_seq OWNED BY sections.id;


--
-- Name: sitemaps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sitemaps (
    id integer NOT NULL,
    path character varying NOT NULL,
    content text
);


--
-- Name: sitemaps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sitemaps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sitemaps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sitemaps_id_seq OWNED BY sitemaps.id;


--
-- Name: solution_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE solution_categories (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    parent_id integer
);


--
-- Name: solution_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE solution_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solution_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE solution_categories_id_seq OWNED BY solution_categories.id;


--
-- Name: solution_category_hierarchies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE solution_category_hierarchies (
    ancestor_id integer NOT NULL,
    descendant_id integer NOT NULL,
    generations integer NOT NULL
);


--
-- Name: split_base_divisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE split_base_divisions (
    id integer NOT NULL,
    split_base_id integer NOT NULL,
    division_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: split_base_divisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE split_base_divisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: split_base_divisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE split_base_divisions_id_seq OWNED BY split_base_divisions.id;


--
-- Name: split_bases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE split_bases (
    id integer NOT NULL,
    title character varying NOT NULL,
    clarat_addition character varying,
    comments text,
    organization_id integer,
    solution_category_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: split_bases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE split_bases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: split_bases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE split_bases_id_seq OWNED BY split_bases.id;


--
-- Name: statistic_chart_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE statistic_chart_goals (
    statistic_chart_id integer NOT NULL,
    statistic_goal_id integer NOT NULL
);


--
-- Name: statistic_chart_transitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE statistic_chart_transitions (
    statistic_chart_id integer NOT NULL,
    statistic_transition_id integer NOT NULL
);


--
-- Name: statistic_charts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE statistic_charts (
    id integer NOT NULL,
    title character varying NOT NULL,
    starts_at date NOT NULL,
    ends_at date NOT NULL,
    user_id integer
);


--
-- Name: statistic_charts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statistic_charts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistic_charts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE statistic_charts_id_seq OWNED BY statistic_charts.id;


--
-- Name: statistic_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE statistic_goals (
    id integer NOT NULL,
    amount integer NOT NULL,
    starts_at date NOT NULL
);


--
-- Name: statistic_goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statistic_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistic_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE statistic_goals_id_seq OWNED BY statistic_goals.id;


--
-- Name: statistic_transitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE statistic_transitions (
    id integer NOT NULL,
    klass_name character varying NOT NULL,
    field_name character varying NOT NULL,
    start_value character varying NOT NULL,
    end_value character varying NOT NULL
);


--
-- Name: statistic_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statistic_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistic_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE statistic_transitions_id_seq OWNED BY statistic_transitions.id;


--
-- Name: statistics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE statistics (
    id integer NOT NULL,
    topic character varying,
    date date NOT NULL,
    count double precision DEFAULT 0.0 NOT NULL,
    model character varying,
    field_name character varying,
    field_start_value character varying,
    field_end_value character varying,
    time_frame character varying DEFAULT 'daily'::character varying,
    trackable_type character varying,
    trackable_id integer
);


--
-- Name: statistics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statistics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE statistics_id_seq OWNED BY statistics.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE subscriptions (
    id integer NOT NULL,
    email character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id integer NOT NULL,
    name_de character varying,
    keywords_de text,
    keywords_en text,
    keywords_ar text,
    keywords_fa text,
    name_en character varying,
    name_fr character varying,
    name_pl character varying,
    name_ru character varying,
    name_ar character varying,
    name_fa character varying,
    name_tr character varying,
    explanations_de text,
    explanations_en text,
    explanations_ar text,
    explanations_fa text
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: tags_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags_offers (
    tag_id integer NOT NULL,
    offer_id integer NOT NULL
);


--
-- Name: target_audience_filters_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE target_audience_filters_offers (
    id integer NOT NULL,
    target_audience_filter_id integer NOT NULL,
    offer_id integer NOT NULL,
    residency_status character varying,
    gender_first_part_of_stamp character varying,
    gender_second_part_of_stamp character varying,
    age_from integer DEFAULT 0 NOT NULL,
    age_to integer DEFAULT 99 NOT NULL,
    age_visible boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    stamp_de character varying,
    stamp_en character varying,
    stamp_ar character varying,
    stamp_fa character varying,
    stamp_fr character varying,
    stamp_tr character varying,
    stamp_ru character varying,
    stamp_pl character varying
);


--
-- Name: target_audience_filters_offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE target_audience_filters_offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: target_audience_filters_offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE target_audience_filters_offers_id_seq OWNED BY target_audience_filters_offers.id;


--
-- Name: time_allocations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE time_allocations (
    id integer NOT NULL,
    user_id integer NOT NULL,
    year integer NOT NULL,
    week_number smallint NOT NULL,
    desired_wa_hours integer NOT NULL,
    actual_wa_hours integer,
    actual_wa_comment character varying
);


--
-- Name: time_allocations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE time_allocations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: time_allocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE time_allocations_id_seq OWNED BY time_allocations.id;


--
-- Name: update_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE update_requests (
    id integer NOT NULL,
    search_location character varying NOT NULL,
    email character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: update_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE update_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: update_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE update_requests_id_seq OWNED BY update_requests.id;


--
-- Name: user_team_observing_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_team_observing_users (
    id integer NOT NULL,
    user_id integer NOT NULL,
    user_team_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: user_team_observing_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_team_observing_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_team_observing_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_team_observing_users_id_seq OWNED BY user_team_observing_users.id;


--
-- Name: user_team_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_team_users (
    id integer NOT NULL,
    user_team_id integer,
    user_id integer
);


--
-- Name: user_team_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_team_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_team_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_team_users_id_seq OWNED BY user_team_users.id;


--
-- Name: user_teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_teams (
    id integer NOT NULL,
    name character varying NOT NULL,
    classification character varying DEFAULT 'researcher'::character varying,
    lead_id integer,
    parent_id integer
);


--
-- Name: user_teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_teams_id_seq OWNED BY user_teams.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    role character varying DEFAULT 'standard'::character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    locked_at timestamp without time zone,
    provider character varying,
    uid character varying,
    name character varying,
    active boolean DEFAULT true
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone,
    object_changes text
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: websites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE websites (
    id integer NOT NULL,
    host character varying NOT NULL,
    url character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    unreachable_count integer DEFAULT 0 NOT NULL,
    ignored_by_crawler boolean DEFAULT false
);


--
-- Name: websites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE websites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: websites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE websites_id_seq OWNED BY websites.id;


--
-- Name: absences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY absences ALTER COLUMN id SET DEFAULT nextval('absences_id_seq'::regclass);


--
-- Name: areas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY areas ALTER COLUMN id SET DEFAULT nextval('areas_id_seq'::regclass);


--
-- Name: assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: categories_sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories_sections ALTER COLUMN id SET DEFAULT nextval('categories_sections_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities ALTER COLUMN id SET DEFAULT nextval('cities_id_seq'::regclass);


--
-- Name: contact_people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact_people ALTER COLUMN id SET DEFAULT nextval('contact_people_id_seq'::regclass);


--
-- Name: contact_person_offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact_person_offers ALTER COLUMN id SET DEFAULT nextval('contact_person_offers_id_seq'::regclass);


--
-- Name: contact_person_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact_person_translations ALTER COLUMN id SET DEFAULT nextval('contact_person_translations_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY definitions ALTER COLUMN id SET DEFAULT nextval('definitions_id_seq'::regclass);


--
-- Name: definitions_offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY definitions_offers ALTER COLUMN id SET DEFAULT nextval('definitions_offers_id_seq'::regclass);


--
-- Name: definitions_organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY definitions_organizations ALTER COLUMN id SET DEFAULT nextval('definitions_organizations_id_seq'::regclass);


--
-- Name: divisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY divisions ALTER COLUMN id SET DEFAULT nextval('divisions_id_seq'::regclass);


--
-- Name: emails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY emails ALTER COLUMN id SET DEFAULT nextval('emails_id_seq'::regclass);


--
-- Name: federal_states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY federal_states ALTER COLUMN id SET DEFAULT nextval('federal_states_id_seq'::regclass);


--
-- Name: filters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY filters ALTER COLUMN id SET DEFAULT nextval('filters_id_seq'::regclass);


--
-- Name: gengo_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gengo_orders ALTER COLUMN id SET DEFAULT nextval('gengo_orders_id_seq'::regclass);


--
-- Name: hyperlinks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hyperlinks ALTER COLUMN id SET DEFAULT nextval('hyperlinks_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: logic_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY logic_versions ALTER COLUMN id SET DEFAULT nextval('logic_versions_id_seq'::regclass);


--
-- Name: next_steps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY next_steps ALTER COLUMN id SET DEFAULT nextval('next_steps_id_seq'::regclass);


--
-- Name: next_steps_offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY next_steps_offers ALTER COLUMN id SET DEFAULT nextval('next_steps_offers_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


--
-- Name: offer_mailings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_mailings ALTER COLUMN id SET DEFAULT nextval('offer_mailings_id_seq'::regclass);


--
-- Name: offer_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_translations ALTER COLUMN id SET DEFAULT nextval('offer_translations_id_seq'::regclass);


--
-- Name: offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offers ALTER COLUMN id SET DEFAULT nextval('offers_id_seq'::regclass);


--
-- Name: openings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY openings ALTER COLUMN id SET DEFAULT nextval('openings_id_seq'::regclass);


--
-- Name: organization_offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organization_offers ALTER COLUMN id SET DEFAULT nextval('organization_offers_id_seq'::regclass);


--
-- Name: organization_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organization_translations ALTER COLUMN id SET DEFAULT nextval('organization_translations_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: search_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_locations ALTER COLUMN id SET DEFAULT nextval('search_locations_id_seq'::regclass);


--
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sections ALTER COLUMN id SET DEFAULT nextval('sections_id_seq'::regclass);


--
-- Name: sitemaps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sitemaps ALTER COLUMN id SET DEFAULT nextval('sitemaps_id_seq'::regclass);


--
-- Name: solution_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY solution_categories ALTER COLUMN id SET DEFAULT nextval('solution_categories_id_seq'::regclass);


--
-- Name: split_base_divisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY split_base_divisions ALTER COLUMN id SET DEFAULT nextval('split_base_divisions_id_seq'::regclass);


--
-- Name: split_bases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY split_bases ALTER COLUMN id SET DEFAULT nextval('split_bases_id_seq'::regclass);


--
-- Name: statistic_charts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistic_charts ALTER COLUMN id SET DEFAULT nextval('statistic_charts_id_seq'::regclass);


--
-- Name: statistic_goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistic_goals ALTER COLUMN id SET DEFAULT nextval('statistic_goals_id_seq'::regclass);


--
-- Name: statistic_transitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistic_transitions ALTER COLUMN id SET DEFAULT nextval('statistic_transitions_id_seq'::regclass);


--
-- Name: statistics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistics ALTER COLUMN id SET DEFAULT nextval('statistics_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: target_audience_filters_offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY target_audience_filters_offers ALTER COLUMN id SET DEFAULT nextval('target_audience_filters_offers_id_seq'::regclass);


--
-- Name: time_allocations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY time_allocations ALTER COLUMN id SET DEFAULT nextval('time_allocations_id_seq'::regclass);


--
-- Name: update_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY update_requests ALTER COLUMN id SET DEFAULT nextval('update_requests_id_seq'::regclass);


--
-- Name: user_team_observing_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_team_observing_users ALTER COLUMN id SET DEFAULT nextval('user_team_observing_users_id_seq'::regclass);


--
-- Name: user_team_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_team_users ALTER COLUMN id SET DEFAULT nextval('user_team_users_id_seq'::regclass);


--
-- Name: user_teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_teams ALTER COLUMN id SET DEFAULT nextval('user_teams_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: websites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY websites ALTER COLUMN id SET DEFAULT nextval('websites_id_seq'::regclass);


--
-- Name: absences absences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY absences
    ADD CONSTRAINT absences_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: assignments assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories_sections categories_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories_sections
    ADD CONSTRAINT categories_sections_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: contact_people contact_people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact_people
    ADD CONSTRAINT contact_people_pkey PRIMARY KEY (id);


--
-- Name: contact_person_offers contact_person_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact_person_offers
    ADD CONSTRAINT contact_person_offers_pkey PRIMARY KEY (id);


--
-- Name: contact_person_translations contact_person_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact_person_translations
    ADD CONSTRAINT contact_person_translations_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: definitions_offers definitions_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY definitions_offers
    ADD CONSTRAINT definitions_offers_pkey PRIMARY KEY (id);


--
-- Name: definitions_organizations definitions_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY definitions_organizations
    ADD CONSTRAINT definitions_organizations_pkey PRIMARY KEY (id);


--
-- Name: definitions definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY definitions
    ADD CONSTRAINT definitions_pkey PRIMARY KEY (id);


--
-- Name: divisions divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY divisions
    ADD CONSTRAINT divisions_pkey PRIMARY KEY (id);


--
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- Name: federal_states federal_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY federal_states
    ADD CONSTRAINT federal_states_pkey PRIMARY KEY (id);


--
-- Name: filters filters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY filters
    ADD CONSTRAINT filters_pkey PRIMARY KEY (id);


--
-- Name: gengo_orders gengo_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gengo_orders
    ADD CONSTRAINT gengo_orders_pkey PRIMARY KEY (id);


--
-- Name: hyperlinks hyperlinks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hyperlinks
    ADD CONSTRAINT hyperlinks_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: logic_versions logic_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY logic_versions
    ADD CONSTRAINT logic_versions_pkey PRIMARY KEY (id);


--
-- Name: next_steps_offers next_steps_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY next_steps_offers
    ADD CONSTRAINT next_steps_offers_pkey PRIMARY KEY (id);


--
-- Name: next_steps next_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY next_steps
    ADD CONSTRAINT next_steps_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: offer_mailings offer_mailings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_mailings
    ADD CONSTRAINT offer_mailings_pkey PRIMARY KEY (id);


--
-- Name: offer_translations offer_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offer_translations
    ADD CONSTRAINT offer_translations_pkey PRIMARY KEY (id);


--
-- Name: offers offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: openings openings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY openings
    ADD CONSTRAINT openings_pkey PRIMARY KEY (id);


--
-- Name: organization_offers organization_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organization_offers
    ADD CONSTRAINT organization_offers_pkey PRIMARY KEY (id);


--
-- Name: organization_translations organization_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organization_translations
    ADD CONSTRAINT organization_translations_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: search_locations search_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_locations
    ADD CONSTRAINT search_locations_pkey PRIMARY KEY (id);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: sitemaps sitemaps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sitemaps
    ADD CONSTRAINT sitemaps_pkey PRIMARY KEY (id);


--
-- Name: solution_categories solution_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY solution_categories
    ADD CONSTRAINT solution_categories_pkey PRIMARY KEY (id);


--
-- Name: split_base_divisions split_base_divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY split_base_divisions
    ADD CONSTRAINT split_base_divisions_pkey PRIMARY KEY (id);


--
-- Name: split_bases split_bases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY split_bases
    ADD CONSTRAINT split_bases_pkey PRIMARY KEY (id);


--
-- Name: statistic_charts statistic_charts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistic_charts
    ADD CONSTRAINT statistic_charts_pkey PRIMARY KEY (id);


--
-- Name: statistic_goals statistic_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistic_goals
    ADD CONSTRAINT statistic_goals_pkey PRIMARY KEY (id);


--
-- Name: statistic_transitions statistic_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistic_transitions
    ADD CONSTRAINT statistic_transitions_pkey PRIMARY KEY (id);


--
-- Name: statistics statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statistics
    ADD CONSTRAINT statistics_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: target_audience_filters_offers target_audience_filters_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY target_audience_filters_offers
    ADD CONSTRAINT target_audience_filters_offers_pkey PRIMARY KEY (id);


--
-- Name: time_allocations time_allocations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY time_allocations
    ADD CONSTRAINT time_allocations_pkey PRIMARY KEY (id);


--
-- Name: update_requests update_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY update_requests
    ADD CONSTRAINT update_requests_pkey PRIMARY KEY (id);


--
-- Name: user_team_observing_users user_team_observing_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_team_observing_users
    ADD CONSTRAINT user_team_observing_users_pkey PRIMARY KEY (id);


--
-- Name: user_team_users user_team_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_team_users
    ADD CONSTRAINT user_team_users_pkey PRIMARY KEY (id);


--
-- Name: user_teams user_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_teams
    ADD CONSTRAINT user_teams_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: websites websites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY websites
    ADD CONSTRAINT websites_pkey PRIMARY KEY (id);


--
-- Name: category_anc_desc_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX category_anc_desc_idx ON category_hierarchies USING btree (ancestor_id, descendant_id, generations);


--
-- Name: category_desc_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX category_desc_idx ON category_hierarchies USING btree (descendant_id);


--
-- Name: index_absences_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_absences_on_user_id ON absences USING btree (user_id);


--
-- Name: index_assignments_on_aasm_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_aasm_state ON assignments USING btree (aasm_state);


--
-- Name: index_assignments_on_assignable_id_and_assignable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_assignable_id_and_assignable_type ON assignments USING btree (assignable_id, assignable_type);


--
-- Name: index_assignments_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_creator_id ON assignments USING btree (creator_id);


--
-- Name: index_assignments_on_creator_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_creator_team_id ON assignments USING btree (creator_team_id);


--
-- Name: index_assignments_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_parent_id ON assignments USING btree (parent_id);


--
-- Name: index_assignments_on_receiver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_receiver_id ON assignments USING btree (receiver_id);


--
-- Name: index_assignments_on_receiver_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_receiver_team_id ON assignments USING btree (receiver_team_id);


--
-- Name: index_categories_offers_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_offers_on_category_id ON categories_offers USING btree (category_id);


--
-- Name: index_categories_offers_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_offers_on_offer_id ON categories_offers USING btree (offer_id);


--
-- Name: index_categories_on_name_de; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_name_de ON categories USING btree (name_de);


--
-- Name: index_categories_sections_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_sections_on_category_id ON categories_sections USING btree (category_id);


--
-- Name: index_categories_sections_on_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_sections_on_section_id ON categories_sections USING btree (section_id);


--
-- Name: index_contact_people_on_email_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contact_people_on_email_id ON contact_people USING btree (email_id);


--
-- Name: index_contact_people_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contact_people_on_organization_id ON contact_people USING btree (organization_id);


--
-- Name: index_contact_person_offers_on_contact_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contact_person_offers_on_contact_person_id ON contact_person_offers USING btree (contact_person_id);


--
-- Name: index_contact_person_offers_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contact_person_offers_on_offer_id ON contact_person_offers USING btree (offer_id);


--
-- Name: index_contact_person_translations_on_contact_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contact_person_translations_on_contact_person_id ON contact_person_translations USING btree (contact_person_id);


--
-- Name: index_contact_person_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contact_person_translations_on_locale ON contact_person_translations USING btree (locale);


--
-- Name: index_definitions_offers_on_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_definitions_offers_on_definition_id ON definitions_offers USING btree (definition_id);


--
-- Name: index_definitions_offers_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_definitions_offers_on_offer_id ON definitions_offers USING btree (offer_id);


--
-- Name: index_definitions_organizations_on_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_definitions_organizations_on_definition_id ON definitions_organizations USING btree (definition_id);


--
-- Name: index_definitions_organizations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_definitions_organizations_on_organization_id ON definitions_organizations USING btree (organization_id);


--
-- Name: index_divisions_on_area_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_divisions_on_area_id ON divisions USING btree (area_id);


--
-- Name: index_divisions_on_city_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_divisions_on_city_id ON divisions USING btree (city_id);


--
-- Name: index_divisions_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_divisions_on_organization_id ON divisions USING btree (organization_id);


--
-- Name: index_divisions_on_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_divisions_on_section_id ON divisions USING btree (section_id);


--
-- Name: index_divisions_presumed_categories_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_divisions_presumed_categories_on_category_id ON divisions_presumed_categories USING btree (category_id);


--
-- Name: index_divisions_presumed_categories_on_division_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_divisions_presumed_categories_on_division_id ON divisions_presumed_categories USING btree (division_id);


--
-- Name: index_divisions_presumed_solution_categories_on_division_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_divisions_presumed_solution_categories_on_division_id ON divisions_presumed_solution_categories USING btree (division_id);


--
-- Name: index_filters_offers_on_filter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_filters_offers_on_filter_id ON filters_offers USING btree (filter_id);


--
-- Name: index_filters_offers_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_filters_offers_on_offer_id ON filters_offers USING btree (offer_id);


--
-- Name: index_filters_on_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_filters_on_section_id ON filters USING btree (section_id);


--
-- Name: index_filters_organizations_on_filter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_filters_organizations_on_filter_id ON filters_organizations USING btree (filter_id);


--
-- Name: index_filters_organizations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_filters_organizations_on_organization_id ON filters_organizations USING btree (organization_id);


--
-- Name: index_hyperlinks_on_linkable_id_and_linkable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hyperlinks_on_linkable_id_and_linkable_type ON hyperlinks USING btree (linkable_id, linkable_type);


--
-- Name: index_hyperlinks_on_website_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hyperlinks_on_website_id ON hyperlinks USING btree (website_id);


--
-- Name: index_locations_on_city_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_city_id ON locations USING btree (city_id);


--
-- Name: index_locations_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_created_at ON locations USING btree (created_at);


--
-- Name: index_locations_on_federal_state_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_federal_state_id ON locations USING btree (federal_state_id);


--
-- Name: index_locations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_organization_id ON locations USING btree (organization_id);


--
-- Name: index_next_steps_offers_on_next_step_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_next_steps_offers_on_next_step_id ON next_steps_offers USING btree (next_step_id);


--
-- Name: index_next_steps_on_text_de; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_next_steps_on_text_de ON next_steps USING btree (text_de);


--
-- Name: index_notes_on_notable_id_and_notable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_notable_id_and_notable_type ON notes USING btree (notable_id, notable_type);


--
-- Name: index_notes_on_referencable_id_and_referencable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_referencable_id_and_referencable_type ON notes USING btree (referencable_id, referencable_type);


--
-- Name: index_notes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_user_id ON notes USING btree (user_id);


--
-- Name: index_offer_mailings_on_email_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offer_mailings_on_email_id ON offer_mailings USING btree (email_id);


--
-- Name: index_offer_mailings_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offer_mailings_on_offer_id ON offer_mailings USING btree (offer_id);


--
-- Name: index_offer_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offer_translations_on_locale ON offer_translations USING btree (locale);


--
-- Name: index_offer_translations_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offer_translations_on_offer_id ON offer_translations USING btree (offer_id);


--
-- Name: index_offers_on_aasm_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_aasm_state ON offers USING btree (aasm_state);


--
-- Name: index_offers_on_approved_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_approved_at ON offers USING btree (approved_at);


--
-- Name: index_offers_on_area_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_area_id ON offers USING btree (area_id);


--
-- Name: index_offers_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_created_at ON offers USING btree (created_at);


--
-- Name: index_offers_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_location_id ON offers USING btree (location_id);


--
-- Name: index_offers_on_logic_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_logic_version_id ON offers USING btree (logic_version_id);


--
-- Name: index_offers_on_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_section_id ON offers USING btree (section_id);


--
-- Name: index_offers_on_solution_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_solution_category_id ON offers USING btree (solution_category_id);


--
-- Name: index_offers_on_split_base_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_on_split_base_id ON offers USING btree (split_base_id);


--
-- Name: index_offers_openings_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_openings_on_offer_id ON offers_openings USING btree (offer_id);


--
-- Name: index_offers_openings_on_opening_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offers_openings_on_opening_id ON offers_openings USING btree (opening_id);


--
-- Name: index_openings_on_day; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_openings_on_day ON openings USING btree (day);


--
-- Name: index_openings_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_openings_on_name ON openings USING btree (name);


--
-- Name: index_organization_offers_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_offers_on_offer_id ON organization_offers USING btree (offer_id);


--
-- Name: index_organization_offers_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_offers_on_organization_id ON organization_offers USING btree (organization_id);


--
-- Name: index_organization_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_translations_on_locale ON organization_translations USING btree (locale);


--
-- Name: index_organization_translations_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_translations_on_offer_id ON next_steps_offers USING btree (offer_id);


--
-- Name: index_organization_translations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_translations_on_organization_id ON organization_translations USING btree (organization_id);


--
-- Name: index_organizations_on_aasm_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_aasm_state ON organizations USING btree (aasm_state);


--
-- Name: index_organizations_on_approved_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_approved_at ON organizations USING btree (approved_at);


--
-- Name: index_organizations_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_created_at ON organizations USING btree (created_at);


--
-- Name: index_organizations_on_website_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_website_id ON organizations USING btree (website_id);


--
-- Name: index_presumed_s_categories_on_s_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_presumed_s_categories_on_s_category ON divisions_presumed_solution_categories USING btree (solution_category_id);


--
-- Name: index_search_locations_on_geoloc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_search_locations_on_geoloc ON search_locations USING btree (geoloc);


--
-- Name: index_search_locations_on_query; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_search_locations_on_query ON search_locations USING btree (query);


--
-- Name: index_sitemaps_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sitemaps_on_path ON sitemaps USING btree (path);


--
-- Name: index_split_base_divisions_on_division_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_split_base_divisions_on_division_id ON split_base_divisions USING btree (division_id);


--
-- Name: index_split_base_divisions_on_split_base_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_split_base_divisions_on_split_base_id ON split_base_divisions USING btree (split_base_id);


--
-- Name: index_split_bases_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_split_bases_on_organization_id ON split_bases USING btree (organization_id);


--
-- Name: index_split_bases_on_solution_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_split_bases_on_solution_category_id ON split_bases USING btree (solution_category_id);


--
-- Name: index_statistic_chart_goals_on_statistic_chart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statistic_chart_goals_on_statistic_chart_id ON statistic_chart_goals USING btree (statistic_chart_id);


--
-- Name: index_statistic_chart_goals_on_statistic_goal_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statistic_chart_goals_on_statistic_goal_id ON statistic_chart_goals USING btree (statistic_goal_id);


--
-- Name: index_statistic_chart_transitions_on_statistic_chart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statistic_chart_transitions_on_statistic_chart_id ON statistic_chart_transitions USING btree (statistic_chart_id);


--
-- Name: index_statistic_chart_transitions_on_statistic_transition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statistic_chart_transitions_on_statistic_transition_id ON statistic_chart_transitions USING btree (statistic_transition_id);


--
-- Name: index_statistic_charts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statistic_charts_on_user_id ON statistic_charts USING btree (user_id);


--
-- Name: index_statistics_on_trackable_id_and_trackable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statistics_on_trackable_id_and_trackable_type ON statistics USING btree (trackable_id, trackable_type);


--
-- Name: index_ta_filters_offers_on_target_audience_filter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ta_filters_offers_on_target_audience_filter_id ON target_audience_filters_offers USING btree (target_audience_filter_id);


--
-- Name: index_tags_offers_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_offers_on_offer_id ON tags_offers USING btree (offer_id);


--
-- Name: index_tags_offers_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_offers_on_tag_id ON tags_offers USING btree (tag_id);


--
-- Name: index_target_audience_filters_offers_on_offer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_target_audience_filters_offers_on_offer_id ON target_audience_filters_offers USING btree (offer_id);


--
-- Name: index_time_allocations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_time_allocations_on_user_id ON time_allocations USING btree (user_id);


--
-- Name: index_user_team_observing_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_team_observing_users_on_user_id ON user_team_observing_users USING btree (user_id);


--
-- Name: index_user_team_observing_users_on_user_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_team_observing_users_on_user_team_id ON user_team_observing_users USING btree (user_team_id);


--
-- Name: index_user_team_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_team_users_on_user_id ON user_team_users USING btree (user_id);


--
-- Name: index_user_team_users_on_user_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_team_users_on_user_team_id ON user_team_users USING btree (user_team_id);


--
-- Name: index_user_teams_on_lead_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_teams_on_lead_id ON user_teams USING btree (lead_id);


--
-- Name: index_user_teams_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_teams_on_parent_id ON user_teams USING btree (parent_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: index_websites_on_host; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_websites_on_host ON websites USING btree (host);


--
-- Name: index_websites_on_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_websites_on_url ON websites USING btree (url);


--
-- Name: solution_category_anc_desc_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX solution_category_anc_desc_idx ON solution_category_hierarchies USING btree (ancestor_id, descendant_id, generations);


--
-- Name: solution_category_desc_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX solution_category_desc_idx ON solution_category_hierarchies USING btree (descendant_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20150916113637'),
('20150917112608'),
('20150928091911'),
('20151001155524'),
('20151005073023'),
('20151028112851'),
('20151029134904'),
('20151105141356'),
('20151112133939'),
('20151124141547'),
('20151130091854'),
('20151210113954'),
('20151216110618'),
('20151217093957'),
('20160104142514'),
('20160107112024'),
('20160113135307'),
('20160115110729'),
('20160121111044'),
('20160121134028'),
('20160121150540'),
('20160125135014'),
('20160125143058'),
('20160125150829'),
('20160125163228'),
('20160126082343'),
('20160126101327'),
('20160126141919'),
('20160127110021'),
('20160216124358'),
('20160219130751'),
('20160229134035'),
('20160229141529'),
('20160310123539'),
('20160321120917'),
('20160411093510'),
('20160429073101'),
('20160504093054'),
('20160513120619'),
('20160527125113'),
('20160530090912'),
('20160620144408'),
('20160629112324'),
('20160629120655'),
('20160701163604'),
('20160708141922'),
('20160711090744'),
('20160715072445'),
('20160719112804'),
('20160725143013'),
('20160805081635'),
('20160812130528'),
('20160819081453'),
('20160819135238'),
('20160826130459'),
('20161007082606'),
('20161031110918'),
('20161208132350'),
('20161219154157'),
('20170102151803'),
('20170112094322'),
('20170112151713'),
('20170120120937'),
('20170220153038'),
('20170222135228'),
('20170308130003'),
('20170326080706'),
('20170404093247'),
('20170404145931'),
('20170405115051'),
('20170407081405'),
('20170407093344'),
('20170407110105'),
('20170419100056'),
('20170420121450'),
('20170420125134'),
('20170424081649'),
('20170427161550'),
('20170428085131'),
('20170502132754'),
('20170502133942'),
('20170521063647'),
('20170601084538'),
('20170601152603'),
('20170602133758'),
('20170607090741'),
('20170619152449'),
('20170622100956'),
('20170626122106'),
('20170627081215'),
('20170627152610'),
('20170628153424'),
('20170721123055'),
('20170727080909'),
('20170802094621'),
('20170809115013');


