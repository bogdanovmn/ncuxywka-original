package PsyApp::Action::Error;

use strict;
use warnings;
use utf8;


sub main {
	my ($self) = @_;

	return { 
		error_msg => $self->params->{psy}->last_error
	};
}

1;
