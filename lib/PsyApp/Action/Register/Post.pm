package PsyApp::Action::Register::Post;

use strict;
use warnings;
use utf8;

use Psy::User;


sub main {
	my ($self) = @_;

	my $name           = $self->params->{name};
	my $password       = $self->params->{password};
	my $password_check = $self->params->{password_check};
	my $about          = $self->params->{about};
	my $email          = $self->params->{email};
	my $loves          = $self->params->{loves};
	my $hates          = $self->params->{hates};
	my $city           = $self->params->{city};
	my $zombi_check    = $self->params->{zombi_check} || '';
	my $psy            = $self->params->{psy};

	unless ($zombi_check eq 2) {
		return $psy->error("Zombie detected");
	}

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
		password => $password,
		ip       => $psy->{ip},
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
