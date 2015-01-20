package Psy::DB;

use DBI;
use strict;
use warnings;
use utf8;

use PSY_DB_CONF;
use Time::HiRes;
use Psy::Errors;
use Utils;
use Format::LongNumber;

my $__STATISTIC = {
	sql_count       => 0,
	sql_time        => 0,
	db_connect_time => 0,
	db_connections  => 0,
};

my $__SHOW_SQL_DETAILS = 0;
my @__SQL_DETAILS;

my $__DBH = undef;

sub connect {
	my ($class, %p) = @_;
	
	unless ($__DBH) {
		my $begin_time = Time::HiRes::time;
		$__DBH = DBI->connect(
			sprintf('dbi:mysql:%s:%s', PSY_DB_CONF::NAME, PSY_DB_CONF::HOST), 
			PSY_DB_CONF::USER, 
			PSY_DB_CONF::PASS,
			{ 
				RaiseError => 1,
				mysql_auto_reconnect => 1,
				mysql_enable_utf8    => 1
			}
		) or die $!;
		#$__DBH->{mysql_enable_utf8} = 1;
		#$__DBH->do("SET NAMES utf8");
		
		#$__DBH->do("SET SQL_BIG_SELECTS=1");
		
		$__STATISTIC->{db_connect_time} += sprintf('%.3f', Time::HiRes::time - $begin_time);
		$__STATISTIC->{db_connections}++;
	}
	my $self = { 
		dbh              => $__DBH, 
		sql_empty_result => 1,
	};
	
	$self->{console} = $p{console} || 0;

	return bless $self, $class;
}
#
#
#
sub query {
	my ($self, $sql, $params, $settings) = @_;

	$settings ||= {};
	my @caller = caller(1);
	
	my $sql_error_msg = 
		$settings->{error_msg} 
		|| 
		sprintf("Ошибка sql-запроса [%s]",
			scalar @caller ? $caller[3] : '???'
		);
	
	my $sql_debug      = $settings->{debug} || 0;
	my $only_field     = $settings->{only_field} || 0;
	my $list_field     = $settings->{list_field} || 0;
	my $only_first_row = $settings->{only_first_row} || 0;
	my $return_last_id = $settings->{return_last_id} || 0;
	
	if ($sql_debug) {
		debug({ params => $params, sql => $sql }); 
	}
	
	my $begin_time = Time::HiRes::time;
	my $sth = $self->_execute_sql($sql, $params, $settings);
	my $sql_time = Time::HiRes::time - $begin_time;
	$__STATISTIC->{sql_time} += $sql_time;
	$__STATISTIC->{sql_count}++;

	# Explain statistic BEGIN
	if ($__SHOW_SQL_DETAILS) {
		push @__SQL_DETAILS, {
			sql      => $sql,
			sql_time => $sql_time,
			#params  => $params,
			($sql =~ /^\s*select/i) 
				? (%{$self->explain_query($sql, $params, $settings)}) 
				: ()
		};
	}
	# Explain statistic END

	if ($return_last_id and $sql =~ /^\s*insert/i) {
		$sth->finish;
		return $self->{dbh}->last_insert_id(undef, undef, undef, undef);
	}
	if ($sql =~ /^\s*(select|show)/i) {	
		my @result;
		while (my $row = $sth->fetchrow_hashref) {
			return $row->{$only_field} if $only_field;
			return $row                if $only_first_row;
			push @result, $list_field ? $row->{$list_field} : $row;
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

	my @result;
	my $total_rows = 1;
	my $extra_total = '';
	my $type_total = '';

	while (my $line = $sth->fetchrow_hashref) {
		$total_rows *= ($line->{rows} || 1);
		#$extra_total .= $line->{Extra};
		#$type_total .= $line->{type};
		push @result, $line;
	}
	
	$sth->finish;

	return {
		caller          => (caller(2))[3],
		explain_details         => \@result, 
		explain_nice_total_rows => short_number($total_rows),
		explain_total_rows      => $total_rows 
	};
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
sub db_statistic {
	return $__STATISTIC;
}
#
# Crear statistic
#
sub clear_db_statistic {
	$__STATISTIC = {
		sql_count       => 0,
		sql_time        => 0,
		db_connect_time => 0,
		db_connections  => $__STATISTIC->{db_connections},
	};
	@__SQL_DETAILS = ();
}
#
# Enable sql details
#
sub show_sql_details {
	my ($class, $flag) = @_;

	if (defined $flag) {
		$__SHOW_SQL_DETAILS = $flag;
	}

	return $__SHOW_SQL_DETAILS;
}

sub get_sql_details {
	return \@__SQL_DETAILS;
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
