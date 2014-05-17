package PsyApp::Action::Register;

use strict;
use warnings;
use utf8;


sub main {
	my ($class, $params) = @_;

	my $has_error = $params->{has_error};

	my $name = $params->{name};
	my $password = $params->{password};
	my $password_check = $params->{password_check};
	my $about = $params->{about};
	my $email = $params->{email};
	my $loves = $params->{loves};
	my $hates = $params->{hates};
	my $city = $params->{city};

	my $psy = $params->{psy};

	return {
		has_error => $has_error,
	};
}

1;
