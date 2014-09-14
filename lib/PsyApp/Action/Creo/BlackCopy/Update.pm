package PsyApp::Action::Creo::BlackCopy::Update;

use strict;
use warnings;
use utf8;

use Psy::Creo;


sub main {
	my ($self) = @_;

	my $id         = $self->params->{id};
	my $creo_title = $self->params->{title};
	my $creo_body  = $self->params->{body};
	my $psy        = $self->params->{psy};

	my $creo = Psy::Creo->choose($id, black_copy => 1, user_id => $psy->user_id);

	if (not $creo_title or not $creo_body) {
		return $psy->error("Название и текст анализа должны быть заполнены!");
	}

	if ($creo_title =~ /^\W+$/) {
		return $psy->error("Неорректное название");
	}

	$creo->update(
		title => $creo_title,
		body  => $creo_body
	);
	
	return not $psy->error;
}

1;
