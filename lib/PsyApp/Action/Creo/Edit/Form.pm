package PsyApp::Action::Creo::Edit::Form;

use strict;
use warnings;
use utf8;

use Psy::Creo;


sub main {
	my ($self) = @_;

	my $error_msg = $self->params->{err};
	my $creo_id   = $self->params->{id};
	my $psy       = $self->params->{psy};

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
