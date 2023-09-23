tail -r create_images.sql | grep CREATE | awk '{print "DROP "  $2 " IF EXISTS " $3 ";"}' > drop_images.sql
tail -r create_orders_boxes.sql | grep CREATE | awk '{print "DROP "  $2 " IF EXISTS " $3 ";"}' > drop_orders_boxes.sql
tail -r create_categories_products.sql | grep CREATE | awk '{print "DROP "  $2 " IF EXISTS " $3 ";"}' > drop_categories_products.sql
tail -r create_customers_addresses.sql | grep CREATE | awk '{print "DROP "  $2 " IF EXISTS " $3 ";"}' > drop_customers_addresses.sql
tail -r create_i18n.sql | grep CREATE | awk '{print "DROP "  $2 " IF EXISTS " $3 ";"}' > drop_i18n.sql
tail -r create_user_roles.sql | grep CREATE | awk '{print "DROP "  $2 " IF EXISTS " $3 ";"}' > drop_user_roles.sql
