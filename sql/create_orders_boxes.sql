DROP TABLE IF EXISTS order_product_boxes;
DROP TABLE IF EXISTS boxes;
DROP TYPE IF EXISTS BOX_STATUS;
DROP TABLE IF EXISTS order_products;
DROP TYPE IF EXISTS ORDER_PRODUCT_STATUS;
DROP TABLE IF EXISTS orders;
DROP TYPE IF EXISTS ORDER_STATUS;

-- orders
CREATE TYPE ORDER_STATUS AS ENUM(
    'new',
    'processing',
    'shipped_partial',
    'shipped',
    'returned',
    'timed_out'
);
CREATE TABLE orders (
    or_id SERIAL PRIMARY KEY,
    or_cu_id INTEGER NOT NULL,
    or_ad_billing INTEGER NOT NULL,
    or_ad_shipping INTEGER NOT NULL,
    or_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    or_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    or_partial BOOLEAN NOT NULL DEFAULT true,
    or_shipping_cost DECIMAL(8, 2),
    or_status ORDER_STATUS NOT NULL DEFAULT 'new',
    CONSTRAINT fk_customer FOREIGN KEY(or_cu_id) REFERENCES customers(cu_id),
    CONSTRAINT fk_billing FOREIGN KEY(or_ad_billing) REFERENCES addresses(ad_id),
    CONSTRAINT fk_shipping FOREIGN KEY(or_ad_shipping) REFERENCES addresses(ad_id)
);

-- order_products
CREATE TYPE ORDER_PRODUCT_STATUS AS ENUM(
    'new',
    'processing',
    'shipped_partial',
    'shipped',
    'returned'
);
CREATE TABLE order_products (
    op_id SERIAL PRIMARY KEY,
    op_or_id INTEGER NOT NULL,
    op_pr_id INTEGER NOT NULL,
    oi_quantity INTEGER NOT NULL DEFAULT 0,
    oi_ordering INTEGER NOT NULL DEFAULT 0,
    oi_status ORDER_PRODUCT_STATUS NOT NULL DEFAULT 'new',
    CONSTRAINT fk_order FOREIGN KEY(op_or_id) REFERENCES orders(or_id),
    CONSTRAINT fk_product FOREIGN KEY(op_pr_id) REFERENCES products(pr_id),
    UNIQUE (op_or_id, op_pr_id)
);

-- boxes
CREATE TYPE BOX_STATUS AS ENUM(
    'new',
    'processing',
    'shipped_partial',
    'shipped',
    'returned'
);
CREATE TABLE boxes (
    bx_id SERIAL PRIMARY KEY,
    bx_shipped_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    bx_weight INTEGER,
    bx_shipping_cost DECIMAL(8, 2),
    bx_status BOX_STATUS NOT NULL DEFAULT 'new'
);

-- order_product_boxes
CREATE TABLE order_product_boxes (
    pb_id SERIAL PRIMARY KEY,
    pb_op_id INTEGER NOT NULL,
    pb_bx_id INTEGER NOT NULL,
    pb_quantity INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_order_products FOREIGN KEY(pb_op_id) REFERENCES order_products(op_id),
    CONSTRAINT fk_box FOREIGN KEY(pb_bx_id) REFERENCES boxes(bx_id),
    UNIQUE (pb_op_id, pb_bx_id)
);

-- orders or
-- order_products op
-- boxes bx
-- order_product_boxes pb
