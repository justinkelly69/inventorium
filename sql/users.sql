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