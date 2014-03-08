package PSY::VIEWS_LOG::CREO;

use strict;
use warnings;

use PSY::ERRORS;
use PSY::STATISTIC::CREO;

use base 'PSY::VIEWS_LOG';
#
# object constructor
#
sub constructor {
	my ($class, %p) = @_;

	$p{type} = PSY::VIEWS_LOG::OBJECT_TYPE_CREO;
	return PSY::VIEWS_LOG::constructor($class, %p);
}

sub _increment_statistic {
	my ($self) = @_;
	PSY::STATISTIC::CREO->constructor(creo_id => $self->{id})->increment(PSY::STATISTIC::CREO::V_VIEWS);
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
