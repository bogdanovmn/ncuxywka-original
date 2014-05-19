package PsyApp::Action::Creo::Edit;

use strict;
use warnings;
use utf8;

use Psy::Creo;


sub main {
	my ($class, $params) = @_;

	my $error_msg = $params->{err};
	my $creo_id   = $params->{id};
	my $psy       = $params->{psy};

	my $creo = Psy::Creo->choose($creo_id);

	if ($psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_CREO_EDIT)) {
		my $creo_data = $creo->load(
			with_comments => 0,
			for_edit      => 1
		);
		return undef unless $creo_data;

		return {
			%$creo_data,
			error_msg => $error_msg
		};
	}
		
	return undef;
}

1;
