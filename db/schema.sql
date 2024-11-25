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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: guestbook; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guestbook (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(255),
    message text NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: guestbook_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.guestbook_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: guestbook_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.guestbook_id_seq OWNED BY public.guestbook.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id character varying NOT NULL,
    name character varying NOT NULL,
    payload text NOT NULL,
    attempts integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    available_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reserved_at timestamp without time zone,
    reserved_by text
);


--
-- Name: jobs_failed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs_failed (
    id character varying NOT NULL,
    name character varying NOT NULL,
    payload text NOT NULL,
    attempts integer NOT NULL,
    exception character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    available_at timestamp without time zone NOT NULL,
    failed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: jobs_succeeded; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs_succeeded (
    id character varying NOT NULL,
    name character varying NOT NULL,
    payload text NOT NULL,
    attempts integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    available_at timestamp without time zone NOT NULL,
    succeeded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(128) NOT NULL
);


--
-- Name: guestbook id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guestbook ALTER COLUMN id SET DEFAULT nextval('public.guestbook_id_seq'::regclass);


--
-- Name: guestbook guestbook_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guestbook
    ADD CONSTRAINT guestbook_pkey PRIMARY KEY (id);


--
-- Name: jobs_failed jobs_failed_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs_failed
    ADD CONSTRAINT jobs_failed_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: jobs_succeeded jobs_succeeded_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs_succeeded
    ADD CONSTRAINT jobs_succeeded_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- PostgreSQL database dump complete
--


--
-- Dbmate schema migrations
--

INSERT INTO public.schema_migrations (version) VALUES
    ('20241110215357');
