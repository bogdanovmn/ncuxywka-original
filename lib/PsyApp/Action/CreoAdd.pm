package PsyApp::Action::CreoAdd;

use strict;
use warnings;
use utf8;

use Psy::Creo;


sub main {
	my ($class, $params) = @_;

	my $black_copy = $params->{black_copy};
	my $psy        = $params->{psy};

	my $creo_add_info = $psy->can_creo_add;

	return {
		can_add =>  $creo_add_info->{can},
		time_to_post => $creo_add_info->{time_to_post},
		user_black_copy_creo_list => $psy->black_copy_creo_list,
	}
}

1;
