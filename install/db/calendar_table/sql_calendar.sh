#!/bin/bash

for i in {1..87600} 
do
	echo "insert into calendar set value = date_add('2009-01-01 00:00:00', interval $i hour);"
done
