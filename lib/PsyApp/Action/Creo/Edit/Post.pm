package PsyApp::Action::Creo::Edit::Post;

use strict;
use warnings;
use utf8;

use Psy::Creo;


sub main {
	my ($self) = @_;

	my $title   = $self->params->{title};
	my $body    = $self->params->{body};
	my $creo_id = $self->params->{id};
	my $psy     = $self->params->{psy};

	my $creo = Psy::Creo->choose($creo_id);

	if ($psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_CREO_EDIT)) {
		if (not $title or not $body) {
			return $psy->error("Название и текст анализа должны быть заполнены");
		}
		$creo->update(
			title => $title,
			body  => $body
		);
		$psy->auditor->log(
			event_type => Psy::Auditor::EVENT_CREO_EDIT,
			object_id  => $creo_id
		);
	}
	else {
		return $psy->error("Вам не положено!");
	}

	return not $psy->error;
}

1;
