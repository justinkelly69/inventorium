-- insert-roles -- ro_id
INSERT INTO roles (ro_name, ro_description,)
VALUES ('$ro_name', '$ro_description');

-- delete-roles
DELETE FROM roles
WHERE NOT EXISTS (
    SELECT *
    FROM user_roles
    WHERE ur_role_id = '$ro_id'
)
AND ro_id = '$ro_id';

-- insert-user -- us_id
INSERT INTO users (
    us_email,
    us_password,
    us_salt,
    us_enabled
)
VALUES (
    '$us_email',
    '$us_password',
    '$us_salt',
    FALSE
);

-- update-user -- us_id
UPDATE USER SET
    us_username   = '$us_username',
    us_firstname  = '$us_firstname',
    us_middlename = '$us_middlename',
    us_lastname   = '$us_lastname'
WHERE us_id = '$us_id';

-- reset-user-password
UPDATE USER SET
    us_password = '$new_password',
    us_salt     = '$us_salt',
WHERE us_id     = '$us_id'
AND us_password = '$old_password';

-- enable user
UPDATE USER SET
    us_enabled = '$us_enabled',
WHERE us_id = '$us_id';

-- delete user
DELETE FROM users
WHERE NOT EXISTS (
    SELECT * FROM user_roles
    WHERE ur_id = '$us_id'
)
AND us_enabled = FALSE
AND us_id = '$us_id';

-- insert user_roles -- ur_id
INSERT INTO user_roles (ur_user_id, ur_role_id)
VALUES ('$ur_user_id', '$ur_role_id') 
ON CONFLICT DO NOTHING;

-- delete user_roles
DELETE FROM user_roles
WHERE ur_id = '$ur_id';