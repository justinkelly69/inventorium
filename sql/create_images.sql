images
im_id
im_url
im_us_id
im_name
im_ordering
im_mimetype

-- images
CREATE TYPE MIMETYPE AS ENUM ('jpg', 'png', 'gif', 'mp4');
CREATE TABLE images (
    im_id SERIAL PRIMARY KEY,
    im_url VARCHAR(60) NOT NULL,
    im_name VARCHAR(20) NOT NULL,
    im_ordering INTEGER NOT NULL DEFAULT 0,
    im_mimetype MIMETYPE NOT NULL
);