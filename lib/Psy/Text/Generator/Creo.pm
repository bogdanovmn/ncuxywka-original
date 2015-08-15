package Psy::Text::Generator::Creo;

use strict;
use warnings;
use utf8;

use base 'Psy::DB';

use TextGenerator::Source;
use List::Util;

sub new {
	my ($class, %p) = @_;

	my $self = $class->SUPER::connect;
	
	$self->{user_id} = $p{user_id};

	die unless defined $self->{user_id};

	return $self;
}

sub _load_text {
	my ($self) = @_;

	return if exists $self->{source};
	$self->{source} = TextGenerator::Source->new;

	my $creos = $self->schema_select(
		'Creo',
		{ user_id => $self->{user_id} },
		undef,
		[qw/ body /],
	);

	foreach my $c (List::Util::shuffle @$creos) {
		$self->{source}->add($c);
	}
}

sub create {
	my ($self) = @_;

	$self->_load_text;
	return $self->{source}->create;
}

1;
