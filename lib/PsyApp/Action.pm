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
		#$__DBH->{mysql_enable_utf8} = 1;
		#$__DBH->do("SET NAMES utf8");
		
		#$__STATISTIC->{db_connect_time} += sprintf('%.3f', Time::HiRes::time - $begin_time);
		#$__STATISTIC->{db_connections}++;
	}

	return $__SCHEMA;
}

1;
