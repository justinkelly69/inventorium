tac create.sql | grep CREATE | awk '{print "DROP "  $2 " IF EXISTS " $3 ";"}' > drop.sql