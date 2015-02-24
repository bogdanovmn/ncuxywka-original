package PsyApp::Action;

use strict;
use warnings;
use utf8;

use PsyApp::Schema;
use PSY_DB_CONF;


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

		$__SCHEMA->storage->debug(1);
	}

	return $__SCHEMA;
}

sub schema_select {
	my ($self, $class, $cond, $attrs, $fields, $fields_prefix, $params) = @_;

	$attrs ||= {};
	$attrs = {
		%$attrs,
		select       => $fields,
		as           => [ map { $fields_prefix.$_ } @$fields ],
		result_class => 'DBIx::Class::ResultClass::HashRefInflator'
	};

	my @result = $self->schema->resultset($class)->search($cond, $attrs)->all;

	if ($params->{date_field} or $params->{user_id}) {
		@result = map {
			if ($params->{date_field}) {
				$_->{$fields_prefix.$params->{date_field}} =~ s/ .*$//;
			}
			if ($params->{user_id}) {
				$_->{$fields_prefix.$params->{user_id}} = $self->psy->get_user_name_by_id($_->{$fields_prefix.'user_id'});
			}
			$_;
		}
		@result;
	}

	return \@result;
}

1;
