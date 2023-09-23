DROP TABLE IF EXISTS temp_user_roles;
DROP TABLE IF EXISTS temp_users;
DROP TYPE IF EXISTS TEMP_USER_STATUS;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS users;
DROP TYPE IF EXISTS USER_STATUS;
DROP TABLE IF EXISTS roles;

-- roles
CREATE TABLE roles (
    ro_id SERIAL PRIMARY KEY,
    ro_ordering INTEGER NOT NULL DEFAULT 0,
    ro_created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ro_name VARCHAR(20) NOT NULL UNIQUE,
    ro_description VARCHAR(60) NOT NULL
);

-- users
CREATE TYPE USER_STATUS AS ENUM ('enabled', 'disabled');
CREATE TABLE users (
    us_id SERIAL PRIMARY KEY,
    us_ordering INTEGER NOT NULL DEFAULT 0,
    us_created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    us_email VARCHAR(60) NOT NULL UNIQUE,
    us_username VARCHAR(20) NOT NULL,
    us_password VARCHAR(60) NOT NULL,
    us_salt VARCHAR(60) NOT NULL,
    us_status USER_STATUS NOT NULL DEFAULT 'disabled',
    us_num_password_tries INTEGER NOT NULL DEFAULT 0,
    us_password_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    us_firstname VARCHAR(20) NOT NULL,
    us_middlename VARCHAR(20) NULL,
    us_lastname VARCHAR(20) NOT NULL,
    us_mobile_phone VARCHAR(20) NOT NULL
);
-- user_roles
CREATE TABLE user_roles (
    ur_id SERIAL PRIMARY KEY,
    ur_ordering INTEGER NOT NULL DEFAULT 0,
    ur_created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ur_user_id INTEGER NOT NULL,
    ur_role_id INTEGER NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY(ur_user_id) REFERENCES users(us_id),
    CONSTRAINT fk_role FOREIGN KEY(ur_role_id) REFERENCES roles(ro_id),
    UNIQUE (ur_user_id, ur_role_id)
);

-- temp_users
CREATE TYPE TEMP_USER_STATUS AS ENUM ('waiting', 'denied', 'need_info');
CREATE TABLE temp_users (
    tu_id SERIAL PRIMARY KEY,
    tu_ordering INTEGER NOT NULL DEFAULT 0,
    tu_created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tu_email VARCHAR(60) NOT NULL UNIQUE,
    tu_username VARCHAR(20) NOT NULL,
    tu_password VARCHAR(60) NOT NULL,
    tu_salt VARCHAR(60) NOT NULL,
    tu_status TEMP_USER_STATUS NOT NULL DEFAULT 'waiting',
    tu_num_password_tries INTEGER NOT NULL DEFAULT 0,
    tu_password_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tu_firstname VARCHAR(20) NOT NULL,
    tu_middlename VARCHAR(20) NULL,
    tu_lastname VARCHAR(20) NOT NULL,
    tu_mobile_phone VARCHAR(20) NOT NULL
);

-- temp_user_roles
CREATE TABLE temp_user_roles (
    tr_id SERIAL PRIMARY KEY,
    tr_ordering INTEGER NOT NULL DEFAULT 0,
    tr_created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tr_temp_user_id INTEGER NOT NULL,
    tr_role_id INTEGER NOT NULL,
    CONSTRAINT fk_temp_user FOREIGN KEY(tr_temp_user_id) REFERENCES temp_users(tu_id),
    CONSTRAINT fk_role FOREIGN KEY(tr_role_id) REFERENCES roles(ro_id),
    UNIQUE (tr_temp_user_id, tr_role_id)
);

-- roles ro
-- users us
-- user_roles ur
-- temp_users tu
-- temp_user_roles tr


