--  Texts and i18n section
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
-- country_languages
CREATE TABLE country_languages (
    cl_id SERIAL PRIMARY KEY,
    cl_code CHAR(5) NOT NULL UNIQUE,
    cl_co_id INTEGER NOT NULL,
    cl_lg_id INTEGER NOT NULL,
    CONSTRAINT fk_country FOREIGN KEY(cl_co_id) REFERENCES countries(co_id),
    CONSTRAINT fk_language FOREIGN KEY(cl_lg_id) REFERENCES languages(lg_id),
    UNIQUE (cl_co_id, cl_lg_id)
);
-- labels
CREATE TABLE labels (
    lb_id SERIAL PRIMARY KEY,
    lb_label VARCHAR(100) UNIQUE
);
-- texts
CREATE TABLE texts (
    tx_id SERIAL PRIMARY KEY,
    tx_country_language_id INTEGER NOT NULL,
    tx_label_id INTEGER NOT NULL,
    tx_text TEXT,
    CONSTRAINT fk_country_language FOREIGN KEY(tx_country_language_id) REFERENCES country_languages(cl_id),
    CONSTRAINT fk_label FOREIGN KEY(tx_label_id) REFERENCES labels(lb_id),
    UNIQUE (tx_country_language_id, tx_label_id)
);
-- Users and roles section
-- roles
CREATE TABLE roles (
    ro_id SERIAL PRIMARY KEY,
    ro_name VARCHAR(20) NOT NULL UNIQUE,
    ro_description VARCHAR(60) NOT NULL,
    ro_ordering INTEGER NOT NULL DEFAULT 0
);
-- users
CREATE TABLE users (
    us_id SERIAL PRIMARY KEY,
    us_email VARCHAR(60) NOT NULL UNIQUE,
    us_password VARCHAR(60) NOT NULL,
    us_salt VARCHAR(60) NOT NULL,
    us_username VARCHAR(20) NOT NULL,
    us_firstname VARCHAR(20) NOT NULL,
    us_middlename VARCHAR(20) NULL,
    us_lastname VARCHAR(20) NOT NULL,
    us_enabled BOOLEAN DEFAULT FALSE
);
-- user_roles
CREATE TABLE user_roles (
    ur_id SERIAL PRIMARY KEY,
    ur_user_id INTEGER NOT NULL,
    ur_role_id INTEGER NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY(ur_user_id) REFERENCES users(us_id),
    CONSTRAINT fk_role FOREIGN KEY(ur_role_id) REFERENCES roles(ro_id),
    UNIQUE (ur_user_id, ur_role_id)
);
-- Products section
-- images
CREATE TYPE MIMETYPE AS ENUM ('jpg', 'png', 'gif', 'mp4');
CREATE TABLE images (
    im_id SERIAL PRIMARY KEY,
    im_url VARCHAR(60) NOT NULL,
    im_name VARCHAR(20) NOT NULL,
    im_ordering INTEGER NOT NULL DEFAULT 0,
    im_mimetype MIMETYPE NOT NULL
);
-- categories
CREATE TYPE CATEGORY_STATUS AS ENUM ('good', 'bad');
CREATE TABLE categories (
    ca_id SERIAL PRIMARY KEY,
    ca_parent_id INTEGER NULL,
    ca_ordering INTEGER NOT NULL DEFAULT 0,
    ca_title VARCHAR(20) NOT NULL,
    ca_blurb VARCHAR(20) NULL,
    ca_description VARCHAR(4000) NULL,
    ca_user_id INTEGER NOT NULL,
    ca_status CATEGORY_STATUS NOT NULL,
    ca_created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY(ca_user_id) REFERENCES users(us_id)
);
-- category_images
CREATE TABLE category_images (
    ci_id SERIAL PRIMARY KEY,
    ci_category_id INTEGER NOT NULL,
    ci_image_id INTEGER NOT NULL,
    ci_ordering INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_category FOREIGN KEY(ci_category_id) REFERENCES categories(ca_id),
    CONSTRAINT fk_image FOREIGN KEY(ci_image_id) REFERENCES images(im_id),
    UNIQUE (ci_product_category_id, ci_image_id)
);
-- products
CREATE TABLE products (
    it_id SERIAL PRIMARY KEY,
    it_category_id INTEGER NOT NULL,
    it_ordering INTEGER NOT NULL DEFAULT 0,
    it_parent INTEGER NULL,
    it_abstract BOOLEAN NOT NULL DEFAULT FALSE,
    it_customisation BOOLEAN NOT NULL DEFAULT FALSE,
    it_title VARCHAR(20) NOT NULL,
    it_blurb VARCHAR(100) NULL,
    it_description VARCHAR(4000) NULL,
    it_price NUMERIC(8, 2) NOT NULL DEFAULT 0,
    it_weight FLOAT NOT NULL DEFAULT 0,
    it_in_stock INTEGER NOT NULL DEFAULT 0,
    it_on_backorder INTEGER NOT NULL DEFAULT 0,
    it_can_backorder BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_category FOREIGN KEY(it_category_id) REFERENCES product_(ca_id),
);
-- product_images
CREATE TABLE product_images (
    ii_id SERIAL PRIMARY KEY,
    ii_product_id INTEGER NOT NULL,
    ii_image_id INTEGER NOT NULL,
    ii_ordering INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_product FOREIGN KEY(ii_product_id) REFERENCES products(it_id),
    CONSTRAINT fk_image FOREIGN KEY(ii_image_id) REFERENCES images(im_id),
    UNIQUE (ii_product_id, ii_image_id)
);
-- parts
CREATE TABLE parts (
    pa_id SERIAL PRIMARY KEY,
    pi_ordering INTEGER NOT NULL DEFAULT 0,
    pa_title VARCHAR(20) NOT NULL,
    pa_blurb VARCHAR(100) NULL,
    pa_description VARCHAR(4000) NULL,
    pa_price NUMERIC(8, 2) NOT NULL DEFAULT 0,
    pa_weight FLOAT NOT NULL DEFAULT 0,
    pa_in_stock INTEGER NOT NULL DEFAULT 0
);
-- part_images
CREATE TABLE part_images (
    pi_id SERIAL PRIMARY KEY,
    pi_part_id INTEGER NOT NULL,
    pi_image_id INTEGER NOT NULL,
    pi_ordering INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_product_part FOREIGN KEY(pi_part_id) REFERENCES parts(pa_id),
    CONSTRAINT fk_image FOREIGN KEY(pi_image_id) REFERENCES images(im_id),
    UNIQUE (pi_part_id, pi_image_id)
);
-- product_parts
CREATE TABLE product_parts (
    ip_id SERIAL PRIMARY KEY,
    ip_product_id INTEGER NOT NULL,
    ip_part_id INTEGER NOT NULL,
    ip_quantity INTEGER NOT NULL DEFAULT 0,
    ip_ordering INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_product FOREIGN KEY(ip_product_id) REFERENCES products(it_id),
    CONSTRAINT fk_part FOREIGN KEY(ip_part_id) REFERENCES parts(pa_id),
    UNIQUE (ip_product_id, ip_part_id)
);
-- batches
CREATE TABLE batches (
    ba_id SERIAL PRIMARY KEY,
    ba_user_id INTEGER NOT NULL,
    ba_product_id INTEGER NOT NULL,
    ba_initial_size INTEGER NOT NULL DEFAULT 0,
    ba_finished_products INTEGER NOT NULL DEFAULT 0,
    ba_rejected_products INTEGER NOT NULL DEFAULT 0,
    ba_ordering INTEGER NOT NULL DEFAULT 0,
    ba_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY(ba_user_id) REFERENCES users(us_id),
    CONSTRAINT fk_product FOREIGN KEY(ba_product_id) REFERENCES products(it_id),
    UNIQUE (ba_user_id, ba_product_id)
);
-- Customers section
-- customers
CREATE TYPE CUSTOMER_STATUS AS ENUM ('good', 'bad');
CREATE TABLE customers (
    cu_id SERIAL PRIMARY KEY,
    cu_email VARCHAR(60) NOT NULL,
    cu_password VARCHAR(60) NOT NULL,
    cu_salt VARCHAR(60) NOT NULL,
    cu_firstname VARCHAR(20) NOT NULL,
    cu_middlename VARCHAR(20) NULL,
    cu_lastname VARCHAR(20) NOT NULL,
    cu_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cu_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cu_status CUSTOMER_STATUS NOT NULL DEFAULT 'good'
);
-- addresses
CREATE TABLE addresses (
    ad_id SERIAL PRIMARY KEY,
    ad_customer INTEGER NOT NULL,
    ad_country_id INTEGER NOT NULL,
    ad_current BOOLEAN NOT NULL DEFAULT FALSE,
    ad_billing BOOLEAN NOT NULL DEFAULT FALSE,
    ad_shipping BOOLEAN NOT NULL DEFAULT FALSE,
    ad_address1 VARCHAR(60) NOT NULL,
    ad_address2 VARCHAR(60) NULL,
    ad_city VARCHAR(20) NOT NULL,
    ad_state VARCHAR(20) NOT NULL,
    ad_zip VARCHAR(20) NOT NULL,
    ad_ordering INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_customer FOREIGN KEY(ad_customer) REFERENCES customers(cu_id),
    CONSTRAINT fk_country FOREIGN KEY(ad_country_id) REFERENCES countries(co_id)
);
-- orders
CREATE TYPE ORDER_STATUS AS ENUM('good', 'bad');
CREATE TABLE orders (
    or_id SERIAL PRIMARY KEY,
    or_customer_id INTEGER NOT NULL,
    or_shipping_address INTEGER NOT NULL,
    or_billing_address INTEGER NOT NULL,
    or_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    or_status ORDER_STATUS NOT NULL DEFAULT 'good',
    CONSTRAINT fk_customer FOREIGN KEY(or_customer_id) REFERENCES customers(cu_id),
    CONSTRAINT fk_shipping FOREIGN KEY(or_shipping_address) REFERENCES addresses(ad_id),
    CONSTRAINT fk_billing FOREIGN KEY(or_billing_address) REFERENCES addresses(ad_id)
);
-- order_products
CREATE TYPE ORDER_PRODUCT_STATUS AS ENUM('good', 'bad');
CREATE TABLE order_products (
    oi_id SERIAL PRIMARY KEY,
    oi_order_id INTEGER NOT NULL,
    oi_product_id INTEGER NOT NULL,
    oi_quantity INTEGER NOT NULL DEFAULT 0,
    oi_ordering INTEGER NOT NULL DEFAULT 0,
    oi_status ORDER_PRODUCT_STATUS NOT NULL DEFAULT 'good',
    CONSTRAINT fk_order FOREIGN KEY(oi_order_id) REFERENCES orders(or_id),
    CONSTRAINT fk_product FOREIGN KEY(oi_product_id) REFERENCES products(it_id),
    UNIQUE (oi_order_id, oi_product_id)
);