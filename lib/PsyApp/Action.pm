package PsyApp::Action;

use strict;
use warnings;
use utf8;


sub psy { 
	my ($self) = @_;

	return $self->params->{psy};
}

sub creos {
	my ($self) = @_;

	return Psy::Creo->constructor;
}

sub schema {
	my ($self) = @_;

	return $self->psy->schema;
}

1;
