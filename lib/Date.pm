package Date;

use strict;
use warnings;
use utf8;

use POSIX qw| strftime |;
use Time::Local;


sub unix_time_to_ymdhms {
	my $ut = shift || time;

	my $format = shift || "%Y-%m-%d %H:%M:%S";
	
	return strftime($format, localtime($ut));
}

sub ymdhms_to_unix_time {
	my $str = shift;
	
	if ($str =~ /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/) {
		return timelocal($6, $5, $4, $3, $2 - 1, $1);
	}
	if ($str =~ /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})$/) {
		return timelocal(0, $5, $4, $3, $2 - 1, $1);
	}
	if ($str =~ /^(\d{4})-(\d{2})-(\d{2})$/) {
		return timelocal(0, 0, 0, $3, $2 - 1, $1);
	}
	else {
		return undef;
	}
}

#
1; # eof
#
