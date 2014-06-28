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
	
	print "\n----- ". $table_name[0]. " -----\n\n";
	
	my $text = $db->query($sql)->[0]->{"Create Table"};
	$text =~ s/`//g;
	#
	# InnoDB
	#
	$sql = sprintf "alter table %s engine = InnoDB\n", $table_name[0];
	print $sql."\n";
	$db->query($sql);
	#
	# IP
	#
	while ($text =~ /^\s*ip\s+varchar.*?$/gm) {
		$sql = sprintf "alter table %s modify column ip char(15) not null", $table_name[0];
		print $sql."\n";
		$db->query($sql);
	}
	#
	# int(x) --> int
	#
	while ($text =~ /^\s*((\w+)\s*(?:tiny)?int\(\d+\).*?)$/gm) {
		my $orig_str = $1;
		my $field    = $2;

		my $new_str = $orig_str;
		$new_str =~ s/(int|tinyint)\(\d+\)/$1/;
		$new_str =~ s/,$//;

		if ($field =~ /^(author_id|editor_id|object_id|moderator_id|from_user_id|to_user_id|user_id|creo_id)$/ 
		or ($field eq 'id' and $table_name[0] =~ /^(creo|users|moderator)$/)) 
		{
			unless ($new_str =~ /unsigned/) {
				$new_str =~ s/int/int unsigned/;
			}
			$new_str =~ s/int/smallint/;
		}
		#printf "'%s' --> '%s'\n", $orig_str, $new_str;
		$sql = sprintf "alter table %s modify column %s", $table_name[0], $new_str;
		print $sql."\n";
		$db->query($sql);
	}

}
