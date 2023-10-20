INSERT INTO roles (ro_name, ro_description, ro_system)
VALUES (
        'super_administrator',
        'Can create and delete users',
        TRUE
    ),
    (
        'administrator',
        'Can create and delete users',
        TRUE
    ),
    ('guest', 'Can create and delete users', TRUE),
    ('worker', 'Does plain work', FALSE);