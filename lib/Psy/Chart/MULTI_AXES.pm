package Psy::Chart::MULTI_AXES;

use strict;
use warnings;
use utf8;

use base "Psy::Chart";

sub constructor {
	my ($class, %p) = @_;

	my $self = Psy::Chart::constructor($class, %p);
	
	return $self;
}

sub add_axis {
	my ($self, $data) = @_;
}

sub _set_data {
	my ($self) = @_;
}

1;
