package PsyApp::Action::Auth;

use strict;
use warnings;
use utf8;


sub main {
	my ($self) = @_;
	
	my $action   = $self->params->{action} || 'bot';
	my $name     = $self->params->{name};
	my $password = $self->params->{password};
	my $psy      = $self->params->{psy};

	if ($action eq 'in' and $psy->is_annonimus) {
		return $psy->login(
			user_name => $name, 
			password  => $password
		);
	}
	elsif ($action eq 'out' and not $psy->is_annonimus) {
		return $psy->logout;
	}
	else {
		return $psy->error("Вы заблудились?");
	}
}

1;
