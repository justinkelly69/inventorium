-- countries
CREATE SEQUENCE countries_seq;
CREATE TABLE countries (
    co_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('countries_seq'),
    co_code CHAR(2) NOT NULL,
    co_name VARCHAR (100)
);
--languages
CREATE SEQUENCE languages_seq;
CREATE TABLE languages (
    lg_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('languages_seq'),
    lg_code CHAR(2) NOT NULL UNIQUE,
    lg_name VARCHAR (20) UNIQUE
);
CREATE SEQUENCE labels_seq;
CREATE TABLE labels (
    lb_id integer NOT NULL PRIMARY KEY DEFAULT NEXTVAL ('labels_seq'),
    lb_label VARCHAR(100) UNIQUE
);
-- texts
CREATE SEQUENCE texts_seq;
CREATE TABLE texts (
    tx_id integer NOT NULL PRIMARY KEY DEFAULT NEXTVAL ('texts_seq'),
    tx_language_id INTEGER NOT NULL,
    tx_label_id INTEGER NOT NULL,
    tx_text TEXT,
    CONSTRAINT fk_language FOREIGN KEY(tx_language_id) REFERENCES languages(lg_id),
    CONSTRAINT fk_label FOREIGN KEY(tx_label_id) REFERENCES labels(lb_id),
    UNIQUE (tx_language_id, tx_label_id)
);
-- roles
CREATE SEQUENCE roles_seq;
CREATE TABLE roles (
    ro_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('roles_seq'),
    ro_name VARCHAR(20) NOT NULL UNIQUE,
    ro_description VARCHAR(60) NOT NULL
);
-- users
CREATE SEQUENCE users_seq;
CREATE TABLE users (
    us_id integer NOT NULL PRIMARY KEY DEFAULT NEXTVAL('users_seq'),
    us_email VARCHAR(60) NOT NULL UNIQUE,
    us_password VARCHAR(60) NOT NULL,
    us_salt VARCHAR(60) NOT NULL,
    us_username VARCHAR(20) NOT NULL,
    us_firstname VARCHAR(20) NOT NULL,
    us_middlename VARCHAR(20) NULL,
    us_lastname VARCHAR(20) NOT NULL,
    us_enabled BOOLEAN DEFAULT FALSE
);
CREATE SEQUENCE user_roles_seq;
CREATE TABLE user_roles (
    ur_id INTEGER PRIMARY KEY DEFAULT NEXTVAL('user_roles_seq'),
    ur_user_id INTEGER NOT NULL,
    ur_role_id INTEGER NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY(ur_user_id) REFERENCES users(us_id),
    CONSTRAINT fk_role FOREIGN KEY(ur_role_id) REFERENCES roles(ro_id),
    UNIQUE (ur_user_id, ur_role_id)
);
-- items
CREATE SEQUENCE items_seq;
CREATE TABLE items (
    it_id INTEGER PRIMARY KEY DEFAULT NEXTVAL('items_seq'),
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
    it_can_backorder BOOLEAN NOT NULL DEFAULT FALSE
);
-- images
CREATE TYPE MIMETYPE AS ENUM ('jpg', 'png', 'gif', 'mp4');
CREATE SEQUENCE images_seq;
CREATE TABLE images (
    im_id INTEGER NOT NULL PRIMARY KEY DEFAULT nextval('images_seq'),
    im_url VARCHAR(60) NOT NULL,
    im_name VARCHAR(20) NOT NULL,
    im_ordering INTEGER NOT NULL DEFAULT 0,
    im_mimetype MIMETYPE NOT NULL
);
-- parts
CREATE SEQUENCE parts_seq;
CREATE TABLE parts (
    pa_id INTEGER PRIMARY KEY DEFAULT NEXTVAL('parts_seq'),
    pa_title VARCHAR(20) NOT NULL,
    pa_blurb VARCHAR(100) NULL,
    pa_description VARCHAR(4000) NULL,
    pa_price NUMERIC(8, 2) NOT NULL DEFAULT 0,
    pa_weight FLOAT NOT NULL DEFAULT 0,
    pa_in_stock INTEGER NOT NULL DEFAULT 0
);
-- batches
CREATE SEQUENCE batches_seq;
CREATE TABLE batches (
    ba_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('batches_seq'),
    ba_user_id INTEGER NOT NULL,
    ba_item_id INTEGER NOT NULL,
    ba_initial_size INTEGER NOT NULL DEFAULT 0,
    ba_finished_items INTEGER NOT NULL DEFAULT 0,
    ba_rejected_items INTEGER NOT NULL DEFAULT 0,
    ba_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY(ba_user_id) REFERENCES users(us_id),
    CONSTRAINT fk_item FOREIGN KEY(ba_item_id) REFERENCES items(it_id),
    UNIQUE (ba_user_id, ba_item_id)
);
-- categories
CREATE TYPE CATEGORY_STATUS AS ENUM ('good', 'bad');
CREATE SEQUENCE categories_seq;
CREATE TABLE categories (
    ca_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('categories_seq'),
    ca_parent INTEGER NULL,
    ca_title VARCHAR(20) NOT NULL,
    ca_blurb VARCHAR(20) NULL,
    ca_description VARCHAR(4000) NULL,
    ca_user_id INTEGER NOT NULL,
    ca_status CATEGORY_STATUS NOT NULL,
    ca_created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY(ca_user_id) REFERENCES users(us_id)
);
-- category_images
CREATE SEQUENCE category_images_seq;
CREATE TABLE category_images (
    ci_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('category_images_seq'),
    ci_category_id INTEGER NOT NULL,
    ci_image_id INTEGER NOT NULL,
    ci_ordering INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_category FOREIGN KEY(ci_category_id) REFERENCES categories(ca_id),
    CONSTRAINT fk_image FOREIGN KEY(ci_image_id) REFERENCES images(im_id),
    UNIQUE (ci_category_id, ci_image_id)
);
-- item_images
CREATE SEQUENCE item_images_seq;
CREATE TABLE item_images (
    ii_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('item_images_seq'),
    ii_item_id INTEGER NOT NULL,
    ii_image_id INTEGER NOT NULL,
    ii_ordering INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_item FOREIGN KEY(ii_item_id) REFERENCES items(it_id),
    CONSTRAINT fk_image FOREIGN KEY(ii_image_id) REFERENCES images(im_id),
    UNIQUE (ii_item_id, ii_image_id)
);
-- item_parts
CREATE SEQUENCE item_parts_seq;
CREATE TABLE item_parts (
    ip_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('item_parts_seq'),
    ip_item_id INTEGER NOT NULL,
    ip_part_id INTEGER NOT NULL,
    ip_quantity INTEGER NOT NULL DEFAULT 0,
    ip_ordering INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_item FOREIGN KEY(ip_item_id) REFERENCES items(it_id),
    CONSTRAINT fk_part FOREIGN KEY(ip_part_id) REFERENCES parts(pa_id),
    UNIQUE (ip_item_id, ip_part_id)
);
-- part_images
CREATE SEQUENCE part_images_seq;
CREATE TABLE part_images (
    pi_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('part_images_seq'),
    pi_part_id INTEGER NOT NULL,
    pi_image_id INTEGER NOT NULL,
    pi_ordering INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_part FOREIGN KEY(pi_part_id) REFERENCES parts(pa_id),
    CONSTRAINT fk_image FOREIGN KEY(pi_image_id) REFERENCES images(im_id),
    UNIQUE (pi_part_id, pi_image_id)
);
-- customers
CREATE TYPE CUSTOMER_STATUS AS ENUM ('good', 'bad');
CREATE SEQUENCE customers_seq;
CREATE TABLE customers (
    cu_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('customers_seq'),
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
CREATE SEQUENCE addresses_seq;
CREATE TABLE addresses (
    ad_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('addresses_seq'),
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
CREATE SEQUENCE orders_seq;
CREATE TABLE orders (
    or_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('orders_seq'),
    or_customer_id INTEGER NOT NULL,
    or_shipping_address INTEGER NOT NULL,
    or_billing_address INTEGER NOT NULL,
    or_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    or_status ORDER_STATUS NOT NULL DEFAULT 'good',
    CONSTRAINT fk_customer FOREIGN KEY(or_customer_id) REFERENCES customers(cu_id),
    CONSTRAINT fk_shipping FOREIGN KEY(or_shipping_address) REFERENCES addresses(ad_id),
    CONSTRAINT fk_billing FOREIGN KEY(or_billing_address) REFERENCES addresses(ad_id)
);
-- order_items
CREATE TYPE ORDER_ITEM_STATUS AS ENUM('good', 'bad');
CREATE SEQUENCE order_items_seq;
CREATE TABLE order_items (
    oi_id INTEGER NOT NULL PRIMARY KEY DEFAULT NEXTVAL('order_items_seq'),
    oi_order_id INTEGER NOT NULL,
    oi_item_id INTEGER NOT NULL,
    oi_quantity INTEGER NOT NULL DEFAULT 0,
    oi_ordering INTEGER NOT NULL DEFAULT 0,
    oi_status ORDER_ITEM_STATUS NOT NULL DEFAULT 'good',
    CONSTRAINT fk_order FOREIGN KEY(oi_order_id) REFERENCES orders(or_id),
    CONSTRAINT fk_item FOREIGN KEY(oi_item_id) REFERENCES items(it_id),
    UNIQUE (oi_order_id, oi_item_id)
);