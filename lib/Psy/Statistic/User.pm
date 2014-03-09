package Psy::Statistic::User;

use strict;
use warnings;

use Psy::Errors;

use constant V_VOTES_IN => 'votes_in';
use constant V_VOTES_OUT => 'votes_out';
use constant V_VOTES_IN_RANK => 'votes_in_rank';
use constant V_VOTES_OUT_RANK => 'votes_out_rank';
use constant V_COMMENTS_IN => 'comments_in';
use constant V_COMMENTS_OUT => 'comments_out';
use constant V_COMMENTS_IN_BY_SELF => 'comments_in_by_self';
use constant V_SPEC_COMMENTS => 'spec_comments';
use constant V_GB_COMMENTS => 'gb_comments';
use constant V_CREO_POST => 'creo_post';

use base 'Psy::Statistic::Updater';
#
# object constructor
#
sub constructor {
	my ($class, %p) = @_;

	my $self = Psy::Statistic::Updater::constructor($class,
		table_name => 'user_stats',
		key_name => 'user_id',
		key_value => $p{user_id} || 0,
		objects_table_name => 'users'
	);

	if ($p{user_name}) {
		$self->{key_value} = $self->query(
			'SELECT id FROM users WHERE name = ?',
			[$p{user_name}],
			{only_field => 'id'}
		);
	}
	
	return $self;
}

sub _set_queries {
	my ($self) = @_;

	$self->{queries} = {
		(V_VOTES_IN) => q| 
			SELECT COUNT(v.id) value
			FROM creo c
			JOIN vote v ON c.id = v.creo_id
			WHERE c.user_id = %s
		|,
		(V_VOTES_OUT) => q|
			SELECT COUNT(id) value 
			FROM vote
			WHERE user_id = %s
		|,
		(V_VOTES_OUT_RANK) => q|
			SELECT IF (
				COUNT(v.vote > 2),
				ROUND(-0.5 + (SUM(v.vote) - MAX(v.vote) - MIN(v.vote)) / (COUNT(v.vote) - 2), 0),
				NULL
			) value
			FROM vote v
			WHERE v.user_id = %s
		|,
		(V_VOTES_IN_RANK) => q|
			SELECT IF (
				COUNT(v.vote > 2),
				ROUND(-0.5 + (SUM(v.vote) - MAX(v.vote) - MIN(v.vote)) / (COUNT(v.vote) - 2), 0),
				NULL
			) value
			FROM creo c
			JOIN vote v ON v.creo_id =  c.id
			WHERE c.user_id = %s
			|,
		(V_COMMENTS_IN) => q|
			SELECT COUNT(cm.id) value
			FROM creo c
			JOIN comments cm ON cm.creo_id = c.id
			WHERE c.user_id = %s
		|,
		(V_COMMENTS_OUT) => q|
			SELECT COUNT(cm.id) value 
			FROM comments cm
			WHERE cm.user_id = %s
		|,
		(V_COMMENTS_IN_BY_SELF) => q|
			SELECT COUNT(cm.id) value
			FROM creo c
			JOIN comments cm ON cm.creo_id = c.id AND cm.user_id  = c.user_id
			WHERE c.user_id = %s
		|,
		(V_SPEC_COMMENTS) => q|
			SELECT COUNT(sc.id) value
			FROM spec_comments sc
			WHERE sc.user_id = %s
		|,
		(V_GB_COMMENTS) => q|
			SELECT COUNT(gb.id) value
			FROM gb
			WHERE gb.user_id = %s
		|,
		(V_CREO_POST) => q|
			SELECT COUNT(id) value
			FROM creo 
			WHERE user_id = %s
			AND type IN (0, 1)
		|
	};
}

1;
