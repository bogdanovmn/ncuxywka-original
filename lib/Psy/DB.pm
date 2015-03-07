package Psy::DB;

use strict;
use warnings;
use utf8;

use PSY_DB_CONF;
use PsyApp::Schema;
use Psy::DB::Profiler;
use Time::HiRes;
use Psy::Errors;
use Utils;
use Format::LongNumber;
use Time::Piece;

my $__SHOW_SQL_DETAILS = 0;
my @__SQL_DETAILS;
my $__SCHEMA;
my $__PROFILER;


sub connect {
	my ($class, %p) = @_;
	
	my $self = { 
		sql_empty_result => 1,
	};

	unless ($__SCHEMA) {
		my $begin_time = Time::HiRes::time;
		$__SCHEMA = PsyApp::Schema->connect(
			sprintf('dbi:mysql:%s:%s', PSY_DB_CONF::NAME, PSY_DB_CONF::HOST), 
			PSY_DB_CONF::USER, 
			PSY_DB_CONF::PASS,
			{ 
				RaiseError => 1,
				mysql_auto_reconnect => 1,
				mysql_enable_utf8    => 1
			}
		) or die $!;

		$__PROFILER = Psy::DB::Profiler->new(dbh => $__SCHEMA->storage->dbh);
		
		$__PROFILER->statistic_inc('db_connect_time', sprintf('%.3f', Time::HiRes::time - $begin_time));
		$__PROFILER->statistic_inc('db_connections');

		$__SCHEMA->storage->debugobj($__PROFILER);
		$__SCHEMA->storage->debug(1);
	}
	
	if ($p{clear_stat}) {
		$__PROFILER->clear;
	}

	$self->{console} = $p{console} || 0;

	return bless $self, $class;
}

sub schema {
	my ($self) = @_;
	return $__SCHEMA;
}

sub schema_select {
	my ($self, $class, $cond, $attrs, $fields, $fields_prefix, $params) = @_;
	
	$fields_prefix ||= '';
	$attrs         ||= {};
	$attrs = {
		%$attrs,
		select       => $fields,
		as           => [ map { $fields_prefix.$_ } @$fields ],
		result_class => 'DBIx::Class::ResultClass::HashRefInflator'
	};

	my $now_date;
	my $yesterday_date;
	if ($params->{nice_date_field}) {
		my $t = localtime;
		$now_date       = $t->ymd;
		$yesterday_date = ($t - 86400)->ymd;
	}

	my @result = $self->schema->resultset($class)->search($cond, $attrs)->all;

	if ($params->{date_field} or $params->{user_id} or $params->{nice_date_field}) {
		@result = map {
			if ($params->{date_field}) {
				$_->{$fields_prefix.$params->{date_field}} =~ s/ .*$//;
			}
			if ($params->{nice_date_field}) {
				my $f = $fields_prefix.$params->{nice_date_field};
				$_->{$f} =~ s/ .*$//;
				if ($_->{$f} eq $now_date) {
					$_->{$f} = 'Сегодня';
				}
				elsif ($_->{$f} eq $yesterday_date) {
					$_->{$f} = 'Вчера';
				}
			}
			if ($params->{user_id}) {
				$_->{$fields_prefix.$params->{user_id}} = $self->get_user_name_by_id($_->{$fields_prefix.'user_id'});
			}
			$_;
		}
		@result;
	}
	return (@result and 1 == keys %{$result[0]})
		? [ map { values $_ } @result ]
		: \@result;
}

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

	# Explain statistic BEGIN
	if ($__SHOW_SQL_DETAILS) {
		$__PROFILER->add_sql({
			sql      => $sql,
			sql_time => sprintf('%.4f', $sql_time),
			params   => $params,
		});
	}
	# Explain statistic END

	if ($return_last_id and $sql =~ /^\s*insert/i) {
		$sth->finish;
		return $__SCHEMA->storage->dbh->last_insert_id(undef, undef, undef, undef);
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
# Execute sql
#
sub _execute_sql {
	my ($self, $sql, $params, $settings) = @_;
	
	my $sth = $__SCHEMA->storage->dbh->prepare($sql);
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
	my ($class) = @_;
	return $__SHOW_SQL_DETAILS 
		? $__PROFILER->get_statistic
		: undef;
}
#
# Enable sql details
#
sub show_sql_details {
	my ($class, $flag) = @_;

	if (defined $flag) {
		$__SHOW_SQL_DETAILS = $flag;
		$__SCHEMA->storage->debug($flag ? 1 : 0);
	}

	return $__SHOW_SQL_DETAILS;
}

sub get_sql_details {
	my ($self) = @_;
	return $__SHOW_SQL_DETAILS
		? $__PROFILER->get_sql_details
		: undef;
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
