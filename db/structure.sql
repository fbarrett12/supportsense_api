\restrict IkMf9hZ6300Fmq1gouVJbb6fzGa0KVO2xLPhcmFgelnuf26Rs9VpQk4nPvleY7I

-- Dumped from database version 17.11 (Homebrew)
-- Dumped by pg_dump version 17.11 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: vector; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;


--
-- Name: EXTENSION vector; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION vector IS 'vector data type and ivfflat and hnsw access methods';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: glossary_terms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.glossary_terms (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    term character varying,
    meaning text,
    internal_notes text,
    tags jsonb DEFAULT '[]'::jsonb NOT NULL,
    example_snippets jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: glossary_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.glossary_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: glossary_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.glossary_terms_id_seq OWNED BY public.glossary_terms.id;


--
-- Name: jira_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jira_tasks (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    known_issue_id bigint NOT NULL,
    issue_key character varying,
    summary character varying,
    description text,
    status character varying,
    ticket_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: jira_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jira_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jira_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jira_tasks_id_seq OWNED BY public.jira_tasks.id;


--
-- Name: known_issues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.known_issues (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    title character varying,
    description text,
    root_cause text,
    workaround text,
    permanent_fix text,
    severity_level character varying,
    status character varying,
    tags jsonb DEFAULT '[]'::jsonb,
    occurrence_count integer DEFAULT 0 NOT NULL,
    first_seen_at timestamp(6) without time zone,
    last_seen_at timestamp(6) without time zone,
    embedding public.vector(1536),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: known_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.known_issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: known_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.known_issues_id_seq OWNED BY public.known_issues.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tickets (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    external_id character varying,
    source_system character varying,
    subject character varying,
    body text,
    summary text,
    status character varying,
    severity character varying,
    customer_identifier character varying,
    known_issue_id bigint,
    tags jsonb DEFAULT '[]'::jsonb,
    first_seen_at timestamp(6) without time zone,
    last_updated_at timestamp(6) without time zone,
    embedding public.vector(1536),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    match_confidence integer
);


--
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tickets_id_seq OWNED BY public.tickets.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    email character varying NOT NULL,
    encrypted_password character varying NOT NULL,
    role character varying DEFAULT 'agent'::character varying NOT NULL,
    name character varying,
    time_zone character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: glossary_terms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.glossary_terms ALTER COLUMN id SET DEFAULT nextval('public.glossary_terms_id_seq'::regclass);


--
-- Name: jira_tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_tasks ALTER COLUMN id SET DEFAULT nextval('public.jira_tasks_id_seq'::regclass);


--
-- Name: known_issues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.known_issues ALTER COLUMN id SET DEFAULT nextval('public.known_issues_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets ALTER COLUMN id SET DEFAULT nextval('public.tickets_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: glossary_terms glossary_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.glossary_terms
    ADD CONSTRAINT glossary_terms_pkey PRIMARY KEY (id);


--
-- Name: jira_tasks jira_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_tasks
    ADD CONSTRAINT jira_tasks_pkey PRIMARY KEY (id);


--
-- Name: known_issues known_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.known_issues
    ADD CONSTRAINT known_issues_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_glossary_terms_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_glossary_terms_on_organization_id ON public.glossary_terms USING btree (organization_id);


--
-- Name: index_glossary_terms_on_organization_id_and_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_glossary_terms_on_organization_id_and_term ON public.glossary_terms USING btree (organization_id, term);


--
-- Name: index_glossary_terms_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_glossary_terms_on_tags ON public.glossary_terms USING gin (tags);


--
-- Name: index_jira_tasks_on_issue_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jira_tasks_on_issue_key ON public.jira_tasks USING btree (issue_key);


--
-- Name: index_jira_tasks_on_known_issue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jira_tasks_on_known_issue_id ON public.jira_tasks USING btree (known_issue_id);


--
-- Name: index_jira_tasks_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jira_tasks_on_organization_id ON public.jira_tasks USING btree (organization_id);


--
-- Name: index_known_issues_on_embedding_ivfflat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_known_issues_on_embedding_ivfflat ON public.known_issues USING ivfflat (embedding public.vector_cosine_ops) WITH (lists='100');


--
-- Name: index_known_issues_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_known_issues_on_organization_id ON public.known_issues USING btree (organization_id);


--
-- Name: index_known_issues_on_organization_id_and_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_known_issues_on_organization_id_and_title ON public.known_issues USING btree (organization_id, title);


--
-- Name: index_known_issues_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_known_issues_on_tags ON public.known_issues USING gin (tags);


--
-- Name: index_organizations_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_slug ON public.organizations USING btree (slug);


--
-- Name: index_tickets_on_embedding_ivfflat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tickets_on_embedding_ivfflat ON public.tickets USING ivfflat (embedding public.vector_cosine_ops) WITH (lists='100');


--
-- Name: index_tickets_on_known_issue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tickets_on_known_issue_id ON public.tickets USING btree (known_issue_id);


--
-- Name: index_tickets_on_org_external_and_source; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tickets_on_org_external_and_source ON public.tickets USING btree (organization_id, external_id, source_system);


--
-- Name: index_tickets_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tickets_on_organization_id ON public.tickets USING btree (organization_id);


--
-- Name: index_tickets_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tickets_on_tags ON public.tickets USING gin (tags);


--
-- Name: index_users_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_organization_id ON public.users USING btree (organization_id);


--
-- Name: index_users_on_organization_id_and_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_organization_id_and_email ON public.users USING btree (organization_id, email);


--
-- Name: jira_tasks fk_rails_140d0a2c21; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_tasks
    ADD CONSTRAINT fk_rails_140d0a2c21 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: glossary_terms fk_rails_40c3ab18de; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.glossary_terms
    ADD CONSTRAINT fk_rails_40c3ab18de FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: tickets fk_rails_b62b455ecb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT fk_rails_b62b455ecb FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: tickets fk_rails_d5185183c5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT fk_rails_d5185183c5 FOREIGN KEY (known_issue_id) REFERENCES public.known_issues(id);


--
-- Name: users fk_rails_d7b9ff90af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_d7b9ff90af FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: jira_tasks fk_rails_f650ed2a64; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_tasks
    ADD CONSTRAINT fk_rails_f650ed2a64 FOREIGN KEY (known_issue_id) REFERENCES public.known_issues(id);


--
-- Name: known_issues fk_rails_fe5683562d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.known_issues
    ADD CONSTRAINT fk_rails_fe5683562d FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- PostgreSQL database dump complete
--

\unrestrict IkMf9hZ6300Fmq1gouVJbb6fzGa0KVO2xLPhcmFgelnuf26Rs9VpQk4nPvleY7I

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20260908000000'),
('20251204005244'),
('20251204005122'),
('20251204004754'),
('20251204004701'),
('20251204004530'),
('20251204004402'),
('20251203000000');

