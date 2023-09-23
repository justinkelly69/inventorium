DROP TABLE IF EXISTS product_parts;
DROP TABLE IF EXISTS parts;
DROP TABLE IF EXISTS "batches";
DROP TABLE IF EXISTS products;
DROP TYPE IF EXISTS PRODUCT_STATUS;
DROP TABLE IF EXISTS categories;
DROP TYPE IF EXISTS CATEGORY_STATUS;
-- categories
CREATE TYPE CATEGORY_STATUS AS ENUM ('in_production', 'discontinued');
CREATE TABLE categories (
    ca_id SERIAL PRIMARY KEY,
    ca_parent_id INTEGER NULL,
    ca_ordering INTEGER NOT NULL DEFAULT 0,
    ca_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ca_us_id INTEGER NOT NULL,
    ca_title VARCHAR(20) NOT NULL,
    ca_blurb VARCHAR(20) NULL,
    ca_description VARCHAR(4000) NULL,
    ca_status CATEGORY_STATUS NOT NULL DEFAULT 'in_production',
    CONSTRAINT fk_user FOREIGN KEY(ca_us_id) REFERENCES users(us_id)
);
-- products
CREATE TYPE PRODUCT_STATUS AS ENUM ('in_production', 'discontinued');
CREATE TABLE products (
    pr_id SERIAL PRIMARY KEY,
    pr_parent_id INTEGER NULL,
    pr_ordering INTEGER NOT NULL DEFAULT 0,
    pr_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    pr_ca_id INTEGER NOT NULL,
    pr_us_id INTEGER NOT NULL,
    pr_abstract BOOLEAN NOT NULL DEFAULT FALSE,
    pr_customisation BOOLEAN NOT NULL DEFAULT FALSE,
    pr_title VARCHAR(20) NOT NULL,
    pr_blurb VARCHAR(100) NULL,
    pr_description VARCHAR(4000) NULL,
    pr_price NUMERIC(8, 2) NOT NULL DEFAULT 0,
    pr_weight FLOAT NOT NULL DEFAULT 0,
    pr_in_stock INTEGER NOT NULL DEFAULT 0,
    pr_on_backorder INTEGER NOT NULL DEFAULT 0,
    pr_can_backorder BOOLEAN NOT NULL DEFAULT FALSE,
    pr_status PRODUCT_STATUS NOT NULL DEFAULT 'in_production',
    CONSTRAINT fk_category FOREIGN KEY(pr_ca_id) REFERENCES categories(ca_id),
    CONSTRAINT fk_user FOREIGN KEY(pr_us_id) REFERENCES users(us_id)
);
-- batches
CREATE TABLE "batches" (
    ba_id SERIAL PRIMARY KEY,
    ba_ordering INTEGER NOT NULL DEFAULT 0,
    ba_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ba_pr_id INTEGER NOT NULL,
    ba_us_id INTEGER NOT NULL,
    ba_initial_size INTEGER NOT NULL DEFAULT 0,
    ba_finished_products INTEGER NOT NULL DEFAULT 0,
    ba_rejected_products INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_user FOREIGN KEY(ba_us_id) REFERENCES users(us_id),
    CONSTRAINT fk_product FOREIGN KEY(ba_pr_id) REFERENCES products(pr_id)
);
-- parts
CREATE TABLE parts (
    pa_id SERIAL PRIMARY KEY,
    pa_ordering INTEGER NOT NULL DEFAULT 0,
    pa_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    pa_title VARCHAR(20) NOT NULL,
    pa_blurb VARCHAR(100) NULL,
    pa_description VARCHAR(4000) NULL,
    pa_price NUMERIC(8, 2) NOT NULL DEFAULT 0,
    pa_weight FLOAT NOT NULL DEFAULT 0,
    pa_in_stock INTEGER NOT NULL DEFAULT 0
);
-- product_parts
CREATE TABLE product_parts (
    pp_id SERIAL PRIMARY KEY,
    pp_ordering INTEGER NOT NULL DEFAULT 0,
    pp_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    pp_pr_id INTEGER NOT NULL,
    pp_pa_id INTEGER NOT NULL,
    pp_quantity INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_product FOREIGN KEY(pp_pr_id) REFERENCES products(pr_id),
    CONSTRAINT fk_part FOREIGN KEY(pp_pa_id) REFERENCES parts(pa_id),
    UNIQUE (pp_pr_id, pp_pa_id)
);
-- categories ca
-- products pr
-- batches ba
-- parts pa
-- product_parts pp