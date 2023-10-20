DROP TABLE IF EXISTS country_currencies;
DROP TABLE IF EXISTS currencies;
DROP TABLE IF EXISTS country_language_labels;
DROP TABLE IF EXISTS labels;
DROP TABLE IF EXISTS country_languages;
DROP TABLE IF EXISTS languages;
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS continents;
-- continents
CREATE TABLE continents (
    -- ct_id, ct_name
    ct_id CHAR(2) NOT NULL PRIMARY KEY,
    ct_name VARCHAR(20) NOT NULL 
);
-- countries
CREATE TABLE countries (
    -- co_id, co_continent_id, co_common_name, co_flag, co_tld, co_calling_codes, co_eu_member
    co_id CHAR(2) PRIMARY KEY,
    co_continent_id CHAR(2) NOT NULL,
    co_common_name VARCHAR (100) NOT NULL,
    co_flag CHAR(2) NOT NULL,
    co_tld CHAR(2) NOT NULL,
    co_calling_codes VARCHAR(100) NOT NULL,
    co_eu_member BOOLEAN NOT NULL DEFAULT FALSE,
    co_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_continent FOREIGN KEY(co_continent_id) REFERENCES continents(ct_id)
);
--languages
CREATE TABLE languages (
    -- lg_id, lg_name
    lg_id CHAR(3) PRIMARY KEY,
    lg_name VARCHAR (100) UNIQUE,
    lg_enabled BOOLEAN NOT NULL DEFAULT FALSE
);

-- country_languages
CREATE TABLE country_languages (
    -- cl_country_id, cl_language_id
    cl_id SERIAL PRIMARY KEY,
    cl_country_id CHAR(2) NOT NULL,
    cl_language_id CHAR(3) NOT NULL,
    cl_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_country FOREIGN KEY(cl_country_id) REFERENCES countries(co_id),
    CONSTRAINT fk_language FOREIGN KEY(cl_language_id) REFERENCES languages(lg_id),
    UNIQUE (cl_country_id, cl_language_id)
);
-- labels
CREATE TABLE labels (
    lb_id VARCHAR(100) NOT NULL PRIMARY KEY
);
-- country_language_labels
CREATE TABLE country_language_labels (
    ll_id SERIAL PRIMARY KEY,
    ll_country_language_id INTEGER NOT NULL,
    ll_label_id VARCHAR(100) NOT NULL,
    ll_label TEXT,
    CONSTRAINT fk_country_language FOREIGN KEY(ll_country_language_id) REFERENCES country_languages(cl_id),
    CONSTRAINT fk_label FOREIGN KEY(ll_label_id) REFERENCES labels(lb_id),
    UNIQUE (ll_country_language_id, ll_label_id)
);
-- currencies
CREATE TABLE currencies (
    -- cu_id, cu_name
    cu_id CHAR(3) NOT NULL PRIMARY KEY,
    cu_name VARCHAR(100) NOT NULL
);
-- country_currencies
CREATE TABLE country_currencies (
    -- cc_country_id, cc_currency_id
    cc_id SERIAL PRIMARY KEY,
    cc_country_id CHAR(2),
    cc_currency_id CHAR(3),
    cc_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_country FOREIGN KEY(cc_country_id) REFERENCES countries(co_id),
    CONSTRAINT fk_currency FOREIGN KEY(cc_currency_id) REFERENCES currencies(cu_id),
    UNIQUE (cc_country_id, cc_currency_id)
);

-- country_currencies cc
-- currencies cu
-- countries co
-- languages lg
-- labels lb
-- country_languages cl
-- country_language_labels ll