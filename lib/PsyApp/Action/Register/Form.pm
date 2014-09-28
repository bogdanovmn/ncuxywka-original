package PsyApp::Action::Register::Form;

use strict;
use warnings;
use utf8;


sub main {
	my ($self) = @_;

	my $has_error = $self->params->{has_error};

	my $name = $self->params->{name};
	my $password = $self->params->{password};
	my $password_check = $self->params->{password_check};
	my $about = $self->params->{about};
	my $email = $self->params->{email};
	my $loves = $self->params->{loves};
	my $hates = $self->params->{hates};
	my $city = $self->params->{city};

	my $psy = $self->params->{psy};

	return {
		error_msg => $psy->last_error,
	};
}

1;
