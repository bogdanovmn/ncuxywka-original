#!/bin/sh

DB=$1
USER=$2
PASS=

TABLES=`mysql -u$USER -p$PASS -B $DB -e "show tables" | grep -v Tables_`

for t in $TABLES; do 
	echo
	echo $t

	mysqldump -u$USER -p$PASS --no-create-info $DB $t > data/$t.data.sql 

done
