#!/bin/sh

for f in *sql; do 
	echo;
	echo $f;
	
	cat $f | mysql -urednikovp -p rednikovp_psy2 2>&1 | grep -v 'already exists' 
done
