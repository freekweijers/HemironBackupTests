--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

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
-- Name: aka_name; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aka_name (
    id integer NOT NULL,
    person_id integer NOT NULL,
    name character varying,
    imdb_index character varying(3),
    name_pcode_cf character varying(11),
    name_pcode_nf character varying(11),
    surname_pcode character varying(11),
    md5sum character varying(65)
);


ALTER TABLE public.aka_name OWNER TO postgres;

--
-- Name: aka_title; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aka_title (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    title character varying,
    imdb_index character varying(4),
    kind_id integer NOT NULL,
    production_year integer,
    phonetic_code character varying(5),
    episode_of_id integer,
    season_nr integer,
    episode_nr integer,
    note character varying(72),
    md5sum character varying(32)
);


ALTER TABLE public.aka_title OWNER TO postgres;

--
-- Name: cast_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cast_info (
    id integer NOT NULL,
    person_id integer NOT NULL,
    movie_id integer NOT NULL,
    person_role_id integer,
    note character varying,
    nr_order integer,
    role_id integer NOT NULL
);


ALTER TABLE public.cast_info OWNER TO postgres;

--
-- Name: char_name; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.char_name (
    id integer NOT NULL,
    name character varying NOT NULL,
    imdb_index character varying(2),
    imdb_id integer,
    name_pcode_nf character varying(5),
    surname_pcode character varying(5),
    md5sum character varying(32)
);


ALTER TABLE public.char_name OWNER TO postgres;

--
-- Name: comp_cast_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comp_cast_type (
    id integer NOT NULL,
    kind character varying(32) NOT NULL
);


ALTER TABLE public.comp_cast_type OWNER TO postgres;

--
-- Name: company_name; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_name (
    id integer NOT NULL,
    name character varying NOT NULL,
    country_code character varying(6),
    imdb_id integer,
    name_pcode_nf character varying(5),
    name_pcode_sf character varying(5),
    md5sum character varying(32)
);


ALTER TABLE public.company_name OWNER TO postgres;

--
-- Name: company_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_type (
    id integer NOT NULL,
    kind character varying(32)
);


ALTER TABLE public.company_type OWNER TO postgres;

--
-- Name: complete_cast; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.complete_cast (
    id integer NOT NULL,
    movie_id integer,
    subject_id integer NOT NULL,
    status_id integer NOT NULL
);


ALTER TABLE public.complete_cast OWNER TO postgres;

--
-- Name: info_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.info_type (
    id integer NOT NULL,
    info character varying(32) NOT NULL
);


ALTER TABLE public.info_type OWNER TO postgres;

--
-- Name: keyword; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keyword (
    id integer NOT NULL,
    keyword character varying NOT NULL,
    phonetic_code character varying(5)
);


ALTER TABLE public.keyword OWNER TO postgres;

--
-- Name: kind_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kind_type (
    id integer NOT NULL,
    kind character varying(15)
);


ALTER TABLE public.kind_type OWNER TO postgres;

--
-- Name: link_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_type (
    id integer NOT NULL,
    link character varying(32) NOT NULL
);


ALTER TABLE public.link_type OWNER TO postgres;

--
-- Name: movie_companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_companies (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    company_id integer NOT NULL,
    company_type_id integer NOT NULL,
    note character varying
);


ALTER TABLE public.movie_companies OWNER TO postgres;

--
-- Name: movie_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_info (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    info_type_id integer NOT NULL,
    info character varying NOT NULL,
    note character varying
);


ALTER TABLE public.movie_info OWNER TO postgres;

--
-- Name: movie_info_idx; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_info_idx (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    info_type_id integer NOT NULL,
    info character varying NOT NULL,
    note character varying(1)
);


ALTER TABLE public.movie_info_idx OWNER TO postgres;

--
-- Name: movie_keyword; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_keyword (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    keyword_id integer NOT NULL
);


ALTER TABLE public.movie_keyword OWNER TO postgres;

--
-- Name: movie_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_link (
    id integer NOT NULL,
    movie_id integer NOT NULL,
    linked_movie_id integer NOT NULL,
    link_type_id integer NOT NULL
);


ALTER TABLE public.movie_link OWNER TO postgres;

--
-- Name: name; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.name (
    id integer NOT NULL,
    name character varying NOT NULL,
    imdb_index character varying(9),
    imdb_id integer,
    gender character varying(1),
    name_pcode_cf character varying(5),
    name_pcode_nf character varying(5),
    surname_pcode character varying(5),
    md5sum character varying(32)
);


ALTER TABLE public.name OWNER TO postgres;

--
-- Name: person_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_info (
    id integer NOT NULL,
    person_id integer NOT NULL,
    info_type_id integer NOT NULL,
    info character varying NOT NULL,
    note character varying
);


ALTER TABLE public.person_info OWNER TO postgres;

--
-- Name: role_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_type (
    id integer NOT NULL,
    role character varying(32) NOT NULL
);


ALTER TABLE public.role_type OWNER TO postgres;

--
-- Name: title; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.title (
    id integer NOT NULL,
    title character varying NOT NULL,
    imdb_index character varying(5),
    kind_id integer NOT NULL,
    production_year integer,
    imdb_id integer,
    phonetic_code character varying(5),
    episode_of_id integer,
    season_nr integer,
    episode_nr integer,
    series_years character varying(49),
    md5sum character varying(32)
);


ALTER TABLE public.title OWNER TO postgres;

--
-- Name: aka_name aka_name_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aka_name
    ADD CONSTRAINT aka_name_pkey PRIMARY KEY (id);


--
-- Name: aka_title aka_title_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aka_title
    ADD CONSTRAINT aka_title_pkey PRIMARY KEY (id);


--
-- Name: cast_info cast_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cast_info
    ADD CONSTRAINT cast_info_pkey PRIMARY KEY (id);


--
-- Name: char_name char_name_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.char_name
    ADD CONSTRAINT char_name_pkey PRIMARY KEY (id);


--
-- Name: comp_cast_type comp_cast_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comp_cast_type
    ADD CONSTRAINT comp_cast_type_pkey PRIMARY KEY (id);


--
-- Name: company_name company_name_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_name
    ADD CONSTRAINT company_name_pkey PRIMARY KEY (id);


--
-- Name: company_type company_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_type
    ADD CONSTRAINT company_type_pkey PRIMARY KEY (id);


--
-- Name: complete_cast complete_cast_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complete_cast
    ADD CONSTRAINT complete_cast_pkey PRIMARY KEY (id);


--
-- Name: info_type info_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.info_type
    ADD CONSTRAINT info_type_pkey PRIMARY KEY (id);


--
-- Name: keyword keyword_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyword
    ADD CONSTRAINT keyword_pkey PRIMARY KEY (id);


--
-- Name: kind_type kind_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kind_type
    ADD CONSTRAINT kind_type_pkey PRIMARY KEY (id);


--
-- Name: link_type link_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_type
    ADD CONSTRAINT link_type_pkey PRIMARY KEY (id);


--
-- Name: movie_companies movie_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_companies
    ADD CONSTRAINT movie_companies_pkey PRIMARY KEY (id);


--
-- Name: movie_info_idx movie_info_idx_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_info_idx
    ADD CONSTRAINT movie_info_idx_pkey PRIMARY KEY (id);


--
-- Name: movie_info movie_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_info
    ADD CONSTRAINT movie_info_pkey PRIMARY KEY (id);


--
-- Name: movie_keyword movie_keyword_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_keyword
    ADD CONSTRAINT movie_keyword_pkey PRIMARY KEY (id);


--
-- Name: movie_link movie_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_link
    ADD CONSTRAINT movie_link_pkey PRIMARY KEY (id);


--
-- Name: name name_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.name
    ADD CONSTRAINT name_pkey PRIMARY KEY (id);


--
-- Name: person_info person_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_info
    ADD CONSTRAINT person_info_pkey PRIMARY KEY (id);


--
-- Name: role_type role_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_type
    ADD CONSTRAINT role_type_pkey PRIMARY KEY (id);


--
-- Name: title title_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.title
    ADD CONSTRAINT title_pkey PRIMARY KEY (id);


--
-- Name: company_id_movie_companies; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX company_id_movie_companies ON public.movie_companies USING btree (company_id);


--
-- Name: company_type_id_movie_companies; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX company_type_id_movie_companies ON public.movie_companies USING btree (company_type_id);


--
-- Name: info_type_id_movie_info; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX info_type_id_movie_info ON public.movie_info USING btree (info_type_id);


--
-- Name: info_type_id_movie_info_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX info_type_id_movie_info_idx ON public.movie_info_idx USING btree (info_type_id);


--
-- Name: info_type_id_person_info; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX info_type_id_person_info ON public.person_info USING btree (info_type_id);


--
-- Name: keyword_id_movie_keyword; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX keyword_id_movie_keyword ON public.movie_keyword USING btree (keyword_id);


--
-- Name: kind_id_aka_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX kind_id_aka_title ON public.aka_title USING btree (kind_id);


--
-- Name: kind_id_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX kind_id_title ON public.title USING btree (kind_id);


--
-- Name: link_type_id_movie_link; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_type_id_movie_link ON public.movie_link USING btree (link_type_id);


--
-- Name: linked_movie_id_movie_link; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX linked_movie_id_movie_link ON public.movie_link USING btree (linked_movie_id);


--
-- Name: movie_id_aka_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX movie_id_aka_title ON public.aka_title USING btree (movie_id);


--
-- Name: movie_id_cast_info; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX movie_id_cast_info ON public.cast_info USING btree (movie_id);


--
-- Name: movie_id_complete_cast; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX movie_id_complete_cast ON public.complete_cast USING btree (movie_id);


--
-- Name: movie_id_movie_companies; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX movie_id_movie_companies ON public.movie_companies USING btree (movie_id);


--
-- Name: movie_id_movie_info; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX movie_id_movie_info ON public.movie_info USING btree (movie_id);


--
-- Name: movie_id_movie_info_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX movie_id_movie_info_idx ON public.movie_info_idx USING btree (movie_id);


--
-- Name: movie_id_movie_keyword; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX movie_id_movie_keyword ON public.movie_keyword USING btree (movie_id);


--
-- Name: movie_id_movie_link; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX movie_id_movie_link ON public.movie_link USING btree (movie_id);


--
-- Name: person_id_aka_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX person_id_aka_name ON public.aka_name USING btree (person_id);


--
-- Name: person_id_cast_info; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX person_id_cast_info ON public.cast_info USING btree (person_id);


--
-- Name: person_id_person_info; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX person_id_person_info ON public.person_info USING btree (person_id);


--
-- Name: person_role_id_cast_info; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX person_role_id_cast_info ON public.cast_info USING btree (person_role_id);


--
-- Name: role_id_cast_info; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX role_id_cast_info ON public.cast_info USING btree (role_id);


--
-- PostgreSQL database dump complete
--

