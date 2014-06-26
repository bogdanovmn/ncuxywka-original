#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin.'/../../lib';
use lib $FindBin::Bin.'/../../conf';

use Psy::DB;
use Data::Dumper;


my $db = Psy::DB->connect;

for my $line (@{$db->query("show tables")}) {
	my @table_name = values %$line;
	my $sql = "show create table `". $table_name[0]. "`";
	print "\n\n\n----- ". $table_name[0]. " -----\n\n";
	my $text = $db->query($sql)->[0]->{"Create Table"};
	$text =~ s/AUTO_INCREMENT=\d+\s//;
	print $text;
}
