package PsyApp::Action::CreoBlackCopy::Publish;

use strict;
use warnings;
use utf8;

use Psy::Creo;
use Psy::User;


sub main {
	my ($class, $params) = @_;

	my $id  = $params->{id};
	my $psy = $params->{psy};

	my $creo         = Psy::Creo->choose($id, black_copy => 1, user_id => $psy->user_id);
	my $can_creo_add = $psy->can_creo_add;
	
	unless ($can_creo_add->{can}) {
		return $psy->error("Нас не наебешь!");
	}

	$creo->update(
		type      => Psy::Creo::CT_CREO,
		post_date => 1
	);
	$psy->update_post_time;

	return not $psy->error;
}

1;
