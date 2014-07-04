#!/bin/sh

for f in *sql; do 
	echo;
	echo $f;
	
	cat $f | my 2>&1 | grep -v 'already exists' 
done
