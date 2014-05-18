package PsyApp::Action::Register::Post;

use strict;
use warnings;
use utf8;

use Psy::User;


sub main {
	my ($class, $params) = @_;

	my $name           = $params->{name};
	my $password       = $params->{password};
	my $password_check = $params->{password_check};
	my $about          = $params->{about};
	my $email          = $params->{email};
	my $loves          = $params->{loves};
	my $hates          = $params->{hates};
	my $city           = $params->{city};
	my $psy            = $params->{psy};

	unless ($name) {
		return $psy->error("Укажите свое имя");
	}

	unless ($password) {
		return $psy->error("Укажите пароль");
	}
	
	unless ($password_check) {
		return $psy->error("Укажите пароль еще разок");
	}

	unless ($email) {
		return $psy->error("Укажите свой e-mail");
	}

	my $user = Psy::User->new(
		name     => $name, 
		about    => $about,
		email    => $email,
		loves    => $loves,
		hates    => $hates,
		city     => $city,
		password => $password
	);

	if ($user) {
		$user->save;
		return 1;
	}
	else {
		return $psy->error("Что-то пошло не так...");
	}
}

1;
