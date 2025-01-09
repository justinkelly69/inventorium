DROP TABLE IF EXISTS addresses;
DROP TYPE IF EXISTS ADDRESS_TYPE;
DROP TABLE IF EXISTS customers;
DROP TYPE IF EXISTS CUSTOMER_STATUS;
-- customers
CREATE TYPE CUSTOMER_STATUS AS ENUM ('enabled', 'blocked');
CREATE TABLE customers (
    cu_id SERIAL PRIMARY KEY,
    cu_email VARCHAR(60) NOT NULL,
    cu_password VARCHAR(60) NOT NULL,
    cu_salt VARCHAR(60) NOT NULL,
    cu_firstname VARCHAR(20) NOT NULL,
    cu_middlename VARCHAR(20) NULL,
    cu_lastname VARCHAR(20) NOT NULL,
    cu_cl_id INTEGER NOT NULL,
    cu_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cu_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cu_status CUSTOMER_STATUS NOT NULL DEFAULT 'enabled',
    CONSTRAINT fk_country_language FOREIGN KEY(cu_cl_id) REFERENCES country_languages(cl_id)
);
-- addresses
CREATE TYPE ADDRESS_TYPE AS ENUM ('billing', 'shipping', 'billing_shipping');
CREATE TABLE addresses (
    ad_id SERIAL PRIMARY KEY,
    ad_cu_id INTEGER NOT NULL,
    ad_co_id CHAR(2) NOT NULL,
    ad_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ad_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ad_current BOOLEAN NOT NULL DEFAULT FALSE,
    ad_type ADDRESS_TYPE NOT NULL DEFAULT 'billing',
    ad_line1 VARCHAR(60) NOT NULL,
    ad_line2 VARCHAR(60) NULL,
    ad_city VARCHAR(20) NOT NULL,
    ad_state VARCHAR(20) NOT NULL,
    ad_zip VARCHAR(20) NOT NULL,
    CONSTRAINT fk_customer FOREIGN KEY(ad_cu_id) REFERENCES customers(cu_id),
    CONSTRAINT fk_country FOREIGN KEY(ad_co_id) REFERENCES countries(co_id)
);
-- customers cu
-- addresses ad