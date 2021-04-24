-- DROP
-- order_items
DROP TABLE IF EXISTS order_items;
DROP SEQUENCE IF EXISTS order_items_seq;
DROP TYPE IF EXISTS ORDER_ITEM_STATUS;
-- orders
DROP TABLE IF EXISTS orders;
DROP SEQUENCE IF EXISTS orders_seq;
DROP TYPE IF EXISTS ORDER_STATUS;
-- addresses
DROP TABLE IF EXISTS addresses;
DROP SEQUENCE IF EXISTS addresses_seq;
-- customers
DROP TABLE IF EXISTS customers;
DROP SEQUENCE IF EXISTS customers_seq;
DROP TYPE IF EXISTS CUSTOMER_STATUS;
-- countries
DROP TABLE IF EXISTS countries;
-- part_images
DROP TABLE IF EXISTS part_images;
DROP SEQUENCE IF EXISTS part_images_seq;
-- item_parts
DROP TABLE IF EXISTS item_parts;
DROP SEQUENCE IF EXISTS item_parts_seq;
-- item_images
DROP TABLE IF EXISTS item_images;
DROP SEQUENCE IF EXISTS item_images_seq;
-- category_images
DROP TABLE IF EXISTS category_images;
DROP SEQUENCE IF EXISTS category_images_seq;
-- categories
DROP TABLE IF EXISTS categories;
DROP SEQUENCE IF EXISTS categories_seq;
DROP TYPE IF EXISTS CATEGORY_STATUS;
-- batches
DROP TABLE IF EXISTS batches;
DROP SEQUENCE IF EXISTS batches_seq;
-- parts
DROP TABLE IF EXISTS parts;
DROP SEQUENCE IF EXISTS parts_seq;
-- images
DROP TABLE IF EXISTS images;
DROP SEQUENCE IF EXISTS images_seq;
DROP TYPE IF EXISTS MIMETYPE;
-- items
DROP TABLE IF EXISTS items;
DROP SEQUENCE IF EXISTS items_seq;
-- users
DROP TABLE IF EXISTS users;
DROP SEQUENCE IF EXISTS users_seq;
-- roles
DROP TABLE IF EXISTS roles;
DROP SEQUENCE IF EXISTS roles_seq;
-- texts
DROP TABLE IF EXISTS texts;
DROP SEQUENCE IF EXISTS texts_seq;