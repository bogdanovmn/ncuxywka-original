package Psy::DB;

use DBI;
use strict;
use warnings;
use utf8;

use PSY_DB_CONF;
use Time::HiRes;
use Psy::Errors;
use Utils;

my $__STATISTIC = {
	sql_count => 0,
	sql_time => 0,
	db_connect_time => 0,
	db_connections => 0,
	queries_details => []
};

my $__DBH = undef;

sub connect {
	my ($class, %p) = @_;
	
	unless ($__DBH) {
		my $begin_time = Time::HiRes::time;
		$__DBH = DBI->connect(
			sprintf('dbi:mysql:%s:%s', PSY_DB_CONF::NAME, PSY_DB_CONF::HOST), 
			PSY_DB_CONF::USER, 
			PSY_DB_CONF::PASS
		) or die $!;
		$__DBH->{mysql_enable_utf8} = 1;
		$__DBH->do("SET NAMES utf8");
		
		#$__DBH->do("SET SQL_BIG_SELECTS=1");
		
		$__STATISTIC->{db_connect_time} += Time::HiRes::time - $begin_time;
		$__STATISTIC->{db_connections}++;
	}

	my $self = { 
		dbh => $__DBH, 
		ip => $ENV{REMOTE_ADDR},
		sql_empty_result => 1
	};
	
	$self->{console} = $p{console} || 0;

	return bless $self, $class;
}
#
#
#
sub query {
	my ($self, $sql, $params, $settings) = @_;

	my @caller = caller(1);
	
	my $sql_error_msg = 
		$settings->{error_msg} 
		|| 
		sprintf("Ошибка sql-запроса [%s]",
			scalar @caller ? $caller[3] : '???'
		);

	my $sql_debug = $settings->{debug} || 0;
	my $only_field = $settings->{only_field} || 0;
	my $only_first_row = $settings->{only_first_row} || 0;
	my $return_last_id = $settings->{return_last_id} || 0;

	if ($sql_debug) { 
		webug($params, $sql); 
	}
	
	my $begin_time = Time::HiRes::time;
	my $sth = $self->_execute_sql($sql, $params, $settings);
	$__STATISTIC->{sql_time} += Time::HiRes::time - $begin_time;
	$__STATISTIC->{sql_count}++;

	# Explain statistic BEGIN
	#$settings->{explain_statistic} = 1;
	#$self->explain_query($sql, $params, $settings);
	# Explain statistic END

	if ($return_last_id and $sql =~ /^\s*insert/i) {
		$sth->finish;
		return $self->{dbh}->last_insert_id(undef, undef, undef, undef);
	}

	if ($sql =~ /^\s*(select|show)/i) {	
		my @result = ();
		while (my $row = $sth->fetchrow_hashref) {
			return $row->{$only_field} if $only_field;
			return $row if $only_first_row;
			push(@result, $row);
		}
		$sth->finish;
		
		$self->{sql_empty_result} = scalar @result eq 0; 

		return $only_first_row ? undef : \@result;
	}
		
	return 1;
}
#
# Explain command
#
sub explain_query {
	my ($self, $sql, $params, $settings) = @_;

	my $sth = $self->_execute_sql('EXPLAIN '. $sql, $params, $settings);

	my @result = ();
	my $total_rows = 1;
	my $extra_total = '';
	my $type_total = '';
	while (my $line = $sth->fetchrow_hashref) {
		$total_rows *= $line->{rows};
		$extra_total .= $line->{Extra};
		$type_total .= $line->{type};
		push(@result, $line);
	}
	
	$sth->finish;

	use NICE_VALUES;
	my $explain_data = {
		caller => (caller(2))[3],
		details => \@result, 
		nice_total_rows => short_number($total_rows),
		total_rows => $total_rows 
	};
	if ($settings->{explain_statistic}) {
		if ($total_rows > 100 or $type_total =~ /ALL/ or $extra_total =~ /temporary|filesort/) {
			push(@{$__STATISTIC->{queries_details}}, $explain_data);
		}
	}
	else {
		debug_sql_explain([$explain_data]);
	}
}
#
# Execute sql
#
sub _execute_sql {
	my ($self, $sql, $params, $settings) = @_;
	
	my $sth = $self->{dbh}->prepare($sql);
	$sth->execute(@$params);
	
	if ($sth->err) {
        if (not $self->{console} and not $settings->{console}) {
			$self->error($settings->{error_msg});
		}
    }

	return $sth;
}
#
# Check last resultset length
#
sub empty_result_set {
	my ($self) = @_;
	return $self->{sql_empty_result};
}
#
# Return statistic data
#
sub statistic {
	return $__STATISTIC;
}
#
# Set error msg and return 0
# or return boolean on last error
#
sub error {
	my ($self, $msg) = @_;

	if ($msg) {
		$self->{last_error_msg} = $msg;
		return 0;
	}
	else {
		return $self->last_error;
	}
}
#
# Return last error msg
#
sub last_error {
	my ($self) = @_;

	return $self->{last_error_msg} || '';
}

1;
