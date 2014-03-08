package PSY::CHART::MULTI_AXES;

use strict;
use warnings;

use base "PSY::CHART";

sub constructor {
	my ($class, %p) = @_;

	my $self = PSY::CHART::constructor($class, %p);
	
	return $self;
}

sub add_axis {
	my ($self, $data) = @_;
}

sub _set_data {
	my ($self) = @_;
}

1;
