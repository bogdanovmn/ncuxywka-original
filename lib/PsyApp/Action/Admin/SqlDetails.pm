package PsyApp::Action::Admin::SqlDetails;

use strict;
use warnings;
use utf8;

use Utils;

sub main {
	my ($self) = @_;

	my $psy = $self->params->{psy};

	unless ($psy->is_god) {
		return $psy->error("Вы хакер?");
	}

	my $sql_details = $psy->cache->try_get('sql_details', sub { [] }, 1);

	return {
		sql_details => $sql_details
	};
}

1;
