package PsyApp::Action;

use strict;
use warnings;
use utf8;

use PsyApp::Schema;
use PSY_DB_CONF;
use Time::Piece;
use Utils;


my $__SCHEMA;


sub psy { 
	my ($self) = @_;

	return $self->params->{psy};
}

sub creos {
	my ($self) = @_;

	return Psy::Creo->constructor;
}

sub schema {
	my ($self) = @_;

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
		
		#$__STATISTIC->{db_connect_time} += sprintf('%.3f', Time::HiRes::time - $begin_time);
		#$__STATISTIC->{db_connections}++;

			#$__SCHEMA->storage->debug(1);
	}

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
				$_->{$fields_prefix.$params->{user_id}} = $self->psy->get_user_name_by_id($_->{$fields_prefix.'user_id'});
			}
			$_;
		}
		@result;
	}
	return (@result and 1 == keys %{$result[0]})
		? [ map { values $_ } @result ]
		: \@result;
}

1;
