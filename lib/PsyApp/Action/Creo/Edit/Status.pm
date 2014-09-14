package PsyApp::Action::Creo::Edit::Status;

use strict;
use warnings;
use utf8;

use Psy::Creo;


sub main {
	my ($self) = @_;

	my $action  = $self->params->{action};
	my $creo_id = $self->params->{id};
	my $type    = $self->params->{type};
	my $psy     = $self->params->{psy};

	my $creo = Psy::Creo->choose($creo_id);

	return undef unless $psy->auditor->can_edit_creo;

	if ($action eq 'to_quarantine' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_QUARANTINE)) {
		$creo->update_type(type => Psy::Creo::CT_QUARANTINE);
		$psy->auditor->log(
			event_type => Psy::Auditor::EVENT_TO_QUARANTINE,
			object_id  => $creo_id
		);
	}
	elsif ($action eq 'from_quarantine' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_QUARANTINE)) {
		$creo->update_type(type => Psy::Creo::CT_CREO);
		$psy->auditor->log(
			event_type => Psy::Auditor::EVENT_FROM_QUARANTINE,
			object_id  => $creo_id
		);
	}
	elsif ($action eq 'to_neofuturism' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_NEOFUTURISM)) {
		$creo->add_to_neofuturism;
		$psy->auditor->log(
			event_type => Psy::Auditor::EVENT_TO_NEOFUTURISM,
			object_id  => $creo_id
		);
	}
	elsif ($action eq 'from_neofuturism' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_NEOFUTURISM)) {
		$creo->remove_from_neofuturism;
		$psy->auditor->log(
			event_type => Psy::Auditor::EVENT_FROM_NEOFUTURISM,
			object_id  => $creo_id
		);
	}
	elsif ($action eq 'delete' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_CREO_DELETE)) {
		$creo->update_type(type => Psy::Creo::CT_DELETE);
		$psy->auditor->log(
			event_type => Psy::Auditor::EVENT_CREO_DELETE,
			object_id => $creo_id
		);
	}
	elsif ($action eq 'to_plagiarism' and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_PLAGIARISM)) {
		$creo->update_type(type => Psy::Creo::CT_PLAGIARISM);
		
		my $creo_info = $creo->load_headers;
		my $author = Psy::User->choose($creo_info->{c_user_id});
		$author->set_group(Psy::Group::PLAGIARIST);
		
		$psy->auditor->log(
			event_type => Psy::Auditor::EVENT_TO_PLAGIARISM,
			object_id => $creo_id
		);
	}
	else {
		return $psy->error("Очередь на лоботомию в другой палате!");
	}

	return not $psy->error;
}

1;
