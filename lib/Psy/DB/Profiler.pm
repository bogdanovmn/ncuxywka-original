package Psy::DB::Profiler;

use strict;
use warnings;
use utf8;

use Time::HiRes qw(time);
use Format::LongNumber;

use base 'DBIx::Class::Storage::Statistics';

my $__EXEC_START_TIME;
my @__SQL_DATA;
my $__STATISTIC = {
	sql_count       => 0,
	sql_time        => 0,
	db_connect_time => 0,
	db_connections  => 0,
};


sub new {
	my ($class, %p) = @_;

	my $self = $class->SUPER::new();
	$self->{dbh} = $p{dbh};

	return $self;
}

sub query_start {
	my ($self, $sql, @params) = @_;

	#$self->print("Executing $sql: ".join(', ', @params)."\n");
	$__EXEC_START_TIME = time;
}

sub query_end {
	my ($self, $sql, @params) = @_;

	my $elapsed = sprintf("%0.4f", time - $__EXEC_START_TIME);
	#$self->print("Execution took $elapsed seconds.\n");

	$self->add_sql({
		sql      => $sql,
		sql_time => $elapsed,
		params   => \@params,
		#$self->explain_query($sql, \@params)
	});

	$__EXEC_START_TIME = undef;
}

sub statistic_inc {
	my ($self, $key, $inc_value) = @_;

	$inc_value ||= 1;
	$__STATISTIC->{$key} += $inc_value;
}

sub add_sql {
	my ($self, $data) = @_;

	if ($data->{sql} =~ /^\s*select/i) {
		$data = { %$data, $self->explain_query($data->{sql}, $data->{params}) }; 
	}
	push @__SQL_DATA, $data;
	
	$self->statistic_inc('sql_time', $data->{sql_time});
	$self->statistic_inc('sql_count');
}

sub explain_query {
	my ($self, $sql, $params) = @_;
#use Utils; debug $sql;	
	my $sth = $self->{dbh}->prepare('EXPLAIN '.$sql);
	$sth->execute(@$params);
	
	my @result;
	my $total_rows = 1;
	my %extra;
	my $type_total = '';

	while (my $line = $sth->fetchrow_hashref) {
		foreach my $e (split /\s*;\s*/, $line->{Extra}) {
			undef $extra{$e};
		}

		$total_rows *= ($line->{rows} || 1);
		push @result, $line;
	}
	
	$sth->finish;

	return (
		caller                  => (caller(2))[3] || (caller(1))[3],
		explain_details         => \@result, 
		explain_nice_total_rows => short_number($total_rows),
		explain_total_rows      => $total_rows,
		extra                   => join('; ', sort keys %extra)
	);
}

sub get_statistic   { $__STATISTIC; }
sub get_sql_details { \@__SQL_DATA; }

sub clear {
	my ($self) = @_;

	$__STATISTIC = {
		sql_count       => 0,
		sql_time        => 0,
		db_connect_time => 0,
		db_connections  => $__STATISTIC->{db_connections},
	};
	@__SQL_DATA = ();
}
1;
