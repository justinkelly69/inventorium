-- images
CREATE TYPE MIMETYPE AS ENUM ('jpg', 'png', 'gif', 'mp4');
CREATE TABLE images (
    im_id SERIAL PRIMARY KEY,
    im_url VARCHAR(60) NOT NULL,
    im_name VARCHAR(20) NOT NULL,
    im_ordering INTEGER NOT NULL DEFAULT 0,
    im_mimetype MIMETYPE NOT NULL
);

INSERT INTO images (
    im_url,
    im_name,
    im_mimetype
)
VALUES (
    '$im_url',
    '$im_name',
    '$im_mimetype'
);

UPDATE images SET
    im_url = '$im_url',
    im_name = '$im_name',
    im_mimetype = '$im_mimetype'
WHERE im_id = '$im_id';

DELETE FROM images
WHERE NOT EXISTS (
    SELECT * FROM category_images WHERE ci_image_id = '$im_id'
)
AND NOT EXISTS (
    SELECT * FROM product_images WHERE ii_image_id = '$im_id'
)
AND NOT EXISTS (
    SELECT * FROM part_images WHERE pi_image_id = '$im_id'
)
AND im_id = '$im_id';

