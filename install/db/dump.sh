#!/bin/sh

DB=psy_utf8
USER=root

TABLES=`mysql -u$USER -p -B $DB -e "show tables" | grep -v Tables_`

for t in $TABLES; do 
	echo
	echo $t

	mysqldump -u$USER -p --no-create-info $DB $t > data/$t.data.sql 

done
