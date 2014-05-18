package PsyApp::Action::VoteCreo;

use strict;
use warnings;
use utf8;

sub main {
	my ($class, $params) = @_;

	my $creo_id = $params->{creo_id};
	my $vote_id = $params->{vote_id};
	my $psy     = $params->{psy};

	if (not $creo_id or not $vote_id) {
		return $psy->error("Может вы заблудились?");
	}

	$psy->vote(creo_id => $creo_id, vote_id => $vote_id);

	return 1;
}

1
