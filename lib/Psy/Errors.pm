package Psy::Errors;

use strict;
use warnings;
use utf8;

use Data::Dumper;

require Exporter;
our @ISA = qw| Exporter |;
our @EXPORT = (qw|
	debug1
	error1
	debug_sql_explain1
|);

sub error {
	my ($msg) = @_;

	return { __error_msg => $msg };
}

sub debug {
	return { __debug_msg => Dumper(\@_) };
}

sub debug_sql_explain {
	my ($data) = @_;
		
	return {
		__debug_explains => [sort { $b->{total_rows} <=> $a->{total_rows} } @$data]
	}
}

1;
