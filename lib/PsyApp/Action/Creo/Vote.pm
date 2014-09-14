package PsyApp::Action::Creo::Vote;

use strict;
use warnings;
use utf8;

sub main {
	my ($self) = @_;

	my $creo_id = $self->params->{creo_id};
	my $vote_id = $self->params->{vote_id};
	my $psy     = $self->params->{psy};

	if (not $creo_id or not $vote_id) {
		return $psy->error("Может вы заблудились?");
	}

	$psy->vote(creo_id => $creo_id, vote_id => $vote_id);

	return 1;
}

1
