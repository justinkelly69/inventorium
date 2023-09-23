DROP TABLE IF EXISTS country_language_labels;
DROP TABLE IF EXISTS country_languages;
DROP TABLE IF EXISTS labels;
DROP TABLE IF EXISTS languages;
DROP TABLE IF EXISTS countries;
-- countries
CREATE TABLE countries (
    co_id SERIAL PRIMARY KEY,
    co_flag CHAR(1) NOT NULL,
    co_tld CHAR(2) NOT NULL,
    co_dial VARCHAR(10) NOT NULL,
    co_name VARCHAR (100)
);
--languages
CREATE TABLE languages (
    lg_id SERIAL PRIMARY KEY,
    lg_code CHAR(2) NOT NULL UNIQUE,
    lg_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    lg_ordering INTEGER NOT NULL DEFAULT 0,
    lg_name VARCHAR (20) UNIQUE
);
-- labels
CREATE TABLE labels (
    lb_id SERIAL PRIMARY KEY,
    lb_label VARCHAR(100) UNIQUE
);
-- country_languages
CREATE TABLE country_languages (
    cl_id SERIAL PRIMARY KEY,
    cl_code CHAR(5) NOT NULL UNIQUE,
    cl_co_id INTEGER NOT NULL,
    cl_lg_id INTEGER NOT NULL,
    cl_enabled BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT fk_country FOREIGN KEY(cl_co_id) REFERENCES countries(co_id),
    CONSTRAINT fk_language FOREIGN KEY(cl_lg_id) REFERENCES languages(lg_id),
    UNIQUE (cl_co_id, cl_lg_id)
);
-- country_language_labels
CREATE TABLE country_language_labels (
    ll_id SERIAL PRIMARY KEY,
    ll_cl_id INTEGER NOT NULL,
    ll_lb_id INTEGER NOT NULL,
    ll_label TEXT,
    CONSTRAINT fk_country_language FOREIGN KEY(ll_cl_id) REFERENCES country_languages(cl_id),
    CONSTRAINT fk_label FOREIGN KEY(ll_lb_id) REFERENCES labels(lb_id),
    UNIQUE (ll_cl_id, ll_lb_id)
);
-- countries co
-- languages lg
-- labels lb
-- country_languages cl
-- country_language_labels ll