DROP TABLE IF EXISTS part_images;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS category_images;
DROP TYPE IF EXISTS IMAGE_STATUS;
DROP TABLE IF EXISTS images;
DROP TYPE IF EXISTS MIMETYPE;
-- images
CREATE TYPE MIMETYPE AS ENUM ('jpg', 'png', 'gif', 'mp4');
CREATE TYPE IMAGE_STATUS AS ENUM ('enabled', 'disabled');
CREATE TABLE images (
    im_id SERIAL PRIMARY KEY,
    im_url VARCHAR(60) NOT NULL,
    im_name VARCHAR(20) NOT NULL,
    im_ordering INTEGER NOT NULL DEFAULT 0,
    im_mimetype MIMETYPE NOT NULL
);
-- category_images
CREATE TABLE category_images (
    ci_id SERIAL PRIMARY KEY,
    ci_ca_id INTEGER NOT NULL,
    ci_im_id INTEGER NOT NULL,
    ci_ordering INTEGER NOT NULL DEFAULT 0,
    ci_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ci_status IMAGE_STATUS NOT NULL DEFAULT 'disabled',
    CONSTRAINT fk_category FOREIGN KEY(ci_ca_id) REFERENCES categories(ca_id),
    CONSTRAINT fk_image FOREIGN KEY(ci_im_id) REFERENCES images(im_id),
    UNIQUE (ci_im_id, ci_ca_id)
);
-- product_images
CREATE TABLE product_images (
    pi_id SERIAL PRIMARY KEY,
    pi_pr_id INTEGER NOT NULL,
    pi_im_id INTEGER NOT NULL,
    pi_ordering INTEGER NOT NULL DEFAULT 0,
    pi_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    pi_status IMAGE_STATUS NOT NULL DEFAULT 'disabled',
    CONSTRAINT fk_product FOREIGN KEY(pi_pr_id) REFERENCES products(pr_id),
    CONSTRAINT fk_image FOREIGN KEY(pi_im_id) REFERENCES images(im_id),
    UNIQUE (pi_im_id, pi_pr_id)
);
-- part_images
CREATE TABLE part_images (
    pm_id SERIAL PRIMARY KEY,
    pm_pa_id INTEGER NOT NULL,
    pm_im_id INTEGER NOT NULL,
    pm_ordering INTEGER NOT NULL DEFAULT 0,
    pm_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    pm_status IMAGE_STATUS NOT NULL DEFAULT 'disabled',
    CONSTRAINT fk_parts FOREIGN KEY(pm_pa_id) REFERENCES parts(pa_id),
    CONSTRAINT fk_image FOREIGN KEY(pm_im_id) REFERENCES images(im_id),
    UNIQUE (pm_im_id, pm_pa_id)
);
-- images im
-- category_images ci
-- product_images pi
-- part_images pm