#!/usr/bin/perl

use strict;
use warnings;

open(F, '< ncuxywka.com_access.log') or die($!);
print 'INSERT INTO views_log (user_id, ip, view_date, object_id, object_type) VALUES ';
my $s = '';
while (my $line = <F>) {
	# 66.249.78.188 - - [15/Aug/2013:03:30:10 +0400] "GET /creos/365.html HTTP/1.0" 200 6081
	if ($line =~ m/^([0-9.]+) - - \[(\S+).*GET \/creos\/(\d+)\.html.*$/) {
		print "$s(0, '$1', STR_TO_DATE('$2', '%d/%M/%Y:%h:%i:%s'), $3, 'creo')";
		$s = ',';
	}
	else {
		next;
	}
}
close F;
