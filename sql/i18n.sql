-- insert country -- co_id
INSERT INTO countries (co_flag, co_tld, co_dial, co_name)
VALUES ($flag, $tld, $dial, $name);

-- delete country
DELETE FROM countries
WHERE NOT EXISTS (
    SELECT * FROM country_languages
    WHERE cl_co_id = $co_id
)
AND co_id = $co_id;

-- insert language -- lg_id
INSERT INTO languages (lg_code, lg_enabled, lg_ordering, lg_name)
VALUES ($code, $enabled, $ordering, $name);

-- delete language
DELETE FROM languages
WHERE NOT EXISTS (
    SELECT * FROM country_languages
    WHERE cl_lg_id = $lg_id
)
AND lg_id = $lg_id;

-- insert country_language -- cl_id
INSERT INTO country_languages (cl_code, cl_co_id, cl_lg_id)
VALUES ($cl_code, $cl_co_id, $cl_lg_id)
ON CONFLICT DO NOTHING;

-- delete country_language
DELETE FROM country_languages
WHERE NOT EXISTS (
    SELECT * FROM texts
    WHERE tx_country_language_id = $cl_id
)
AND cl_id = $cl_id;

-- insert label -- lb_id
INSERT INTO labels (lb_label)
VALUES ($lb_label);

-- delete label
DELETE FROM labels
WHERE NOT EXISTS (
    SELECT * FROM texts
    WHERE tx_label_id = $lb_id
)
AND lb_id = $lb_id;

-- upsert text -- tx_id
INSERT INTO texts (tx_language_id, tx_label_id, tx_text)
VALUES ($tx_language_id, $tx_label_id, $tx_text)
ON CONFLICT DO 
    UPDATE texts
    SET tx_text = $tx_text
    WHERE tx_language_id = $tx_language_id
    AND tx_label_id = $tx_label_id;

-- delete text
DELETE FROM texts
WHERE tx_id = $tx_id;



