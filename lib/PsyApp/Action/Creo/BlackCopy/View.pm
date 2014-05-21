package PsyApp::Action::Creo::BlackCopy::View;

use strict;
use warnings;
use utf8;

use Psy::Creo;


sub main {
	my ($class, $params) = @_;

	my $id   = $params->{id};
	my $edit = $params->{edit};
	my $psy  = $params->{psy};

	my $creo = Psy::Creo->choose($id, black_copy => 1, user_id => $psy->user_id);
	my $can_creo_add = $psy->can_creo_add;

	my $creo_data = $creo->load(
		with_comments => 0,
		for_edit => $edit
	);

	return undef unless $creo_data;
	
	return {
		%$creo_data,
		error_msg       => $psy->last_error,
		creo_id         => $id,
		can_public      => $can_creo_add->{can},
		time_to_public  => $can_creo_add->{time_to_post},
		black_copy_edit => $edit,
		user_black_copy_creo_list => $psy->black_copy_creo_list,
	};
}

1;
