package PsyApp::Action::News::Hide;

use strict;
use warnings;
use utf8;


sub main {
	my ($self) = @_;

	my $id   = $self->params->{id};

	unless ($self->psy->is_god) {
		return $self->psy->error("Врачей не наипешь!");
	}

	$self->schema
		->resultset('News')
		->find({ id => $id })
		->update({ visible => 0 });

	return not $self->psy->error;
}

1;
