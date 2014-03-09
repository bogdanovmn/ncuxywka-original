package Psy::Errors;

use strict;
use warnings;

use Data::Dumper;

require Exporter;
our @ISA = qw| Exporter |;
our @EXPORT = (qw|
	debug
	error
	debug_sql_explain
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
