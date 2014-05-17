package PsyApp::Action::Auth;

use strict;
use warnings;
use utf8;


sub main {
	my ($class, $params) = @_;
	
	my $action   = $params->{action} || 'bot';
	my $name     = $params->{name};
	my $password = $params->{password};
	my $psy      = $params->{psy};

	if ($action eq 'in' and $psy->is_annonimus) {
		$psy->login(
			user_name => $name, 
			password  => $password
		);
	}
	elsif ($action eq 'out' and not $psy->is_annonimus) {
		$psy->logout;
	}
	else {
		$self->{login_error_msg} = "Вы заблудились?";
		return 0;
	}

	return 1;
}

1;
