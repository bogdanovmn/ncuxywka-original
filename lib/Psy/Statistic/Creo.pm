package Psy::Statistic::Creo;

use strict;
use warnings;
use utf8;

use Psy::Errors;


use constant V_VOTES => 'votes';
use constant V_VOTES_RANK => 'votes_rank';
use constant V_COMMENTS => 'comments';
use constant V_VIEWS => 'views';
use constant V_VIEWS_BY_USERS => 'views_by_users';

use base 'Psy::Statistic::Updater';
#
# object constructor
#
sub constructor {
	my ($class, %p) = @_;

	return Psy::Statistic::Updater::constructor($class,
		table_name => 'creo_stats',
		key_name => 'creo_id',
		key_value => $p{creo_id} || 0,
		objects_table_name => 'creo'
	);
}

sub _set_queries {
	my ($self) = @_;

	$self->{queries} = {
		(V_VOTES) => q| 
			SELECT COUNT(v.id) value
			FROM vote v 
			WHERE v.creo_id = %s
		|,
		(V_VOTES_RANK) => q|
			SELECT IF (
				COUNT(v.vote) > 2,
				ROUND(-0.5 + (SUM(v.vote) - MAX(v.vote) - MIN(v.vote)) / (COUNT(v.vote) - 2), 0),
				NULL
			) value
			FROM vote v
			WHERE v.creo_id = %s
		|,
		(V_COMMENTS) => q|
			SELECT COUNT(cm.id) value 
			FROM comments cm
			WHERE cm.creo_id = %s
		|,
		(V_VIEWS) => q|
			SELECT COUNT(v.id) value
			FROM views_log v
			WHERE v.object_id = %s
			AND v.object_type = 'creo'
		|
	};
}


1;
