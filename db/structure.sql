--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: beeminder_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE beeminder_tokens (
    user_id character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    access_token character varying(255) NOT NULL
);


--
-- Name: consumer_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE consumer_tokens (
    user_id character varying(255) NOT NULL,
    type character varying(30),
    token character varying(1024) NOT NULL,
    secret character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id character varying(255) NOT NULL
);


--
-- Name: beeminder_tokens_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY beeminder_tokens
    ADD CONSTRAINT beeminder_tokens_pk PRIMARY KEY (user_id);


--
-- Name: consumer_tokens_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY consumer_tokens
    ADD CONSTRAINT consumer_tokens_pk PRIMARY KEY (token);


--
-- Name: users_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pk PRIMARY KEY (id);


--
-- Name: fk__beeminder_tokens_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__beeminder_tokens_user_id ON beeminder_tokens USING btree (user_id);


--
-- Name: fk__consumer_tokens_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__consumer_tokens_user_id ON consumer_tokens USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: beeminder_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY beeminder_tokens
    ADD CONSTRAINT beeminder_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: consumer_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY consumer_tokens
    ADD CONSTRAINT consumer_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('3');