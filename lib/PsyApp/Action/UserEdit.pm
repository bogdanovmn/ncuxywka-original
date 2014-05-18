package PsyApp::Action::UserEdit;

use strict;
use warnings;
use utf8;

use Psy::User;


sub main {
	my ($class, $params) = @_;

	my $psy = $params->{psy};

	return undef if $psy->is_annonimus;

	my $user      = Psy::User->choose($psy->user_id);
	my $user_info = $user->info;

	return {
		city      => $user_info->{u_city},
		loves     => $user_info->{u_loves},
		hates     => $user_info->{u_hates},
		email     => $user_info->{u_email},
		about     => $user_info->{u_about},
		avatar    => $user->avatar_file_name,
		error_msg => $psy->last_error
	};
}

1;
