package Psy::VIEWS_LOG::CREO;

use strict;
use warnings;

use Psy::Errors;
use Psy::Statistic::Creo;

use base 'Psy::VIEWS_LOG';
#
# object constructor
#
sub constructor {
	my ($class, %p) = @_;

	$p{type} = Psy::VIEWS_LOG::OBJECT_TYPE_CREO;
	return Psy::VIEWS_LOG::constructor($class, %p);
}

sub _increment_statistic {
	my ($self) = @_;
	Psy::Statistic::Creo->constructor(creo_id => $self->{id})->increment(Psy::Statistic::Creo::V_VIEWS);
}

sub total {
    my ($self, %p) = @_;

    return $self->query(qq|
        SELECT views
		FROM creo_stats
		WHERE creo_id = ?
		|,
		[$self->{id}],
		{only_field => 'views'}
	);
}

1;
