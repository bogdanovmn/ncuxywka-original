package Psy::VERSION;

use strict;
use warnings;
use utf8;

use constant VER => "1.0";

sub get_svn_revision {
	my $result = "";
	open(F, ".svn/entries") or return "";
	my $prev = "";
	while (my $line = <F>) {
		chop $line;
		if ($prev eq "dir") {
			$result = $line;
			last;
		}
		$prev = $line;
	}		
	close(F);
	return $result;
}

sub get {
	return VER. ".". get_svn_revision();
}

1;
