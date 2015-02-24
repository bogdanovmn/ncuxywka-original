package Psy::News;

use strict;
use warnings;
use utf8;

use base 'Psy::DB';
#
# User object constructor
#
sub constructor {
	my ($class, %p) = @_;

	my $self = Psy::DB::connect($class);
	
	return $self;
}


sub add {
    my ($self, %p) = @_;

    $self->query(
		q| INSERT INTO news SET user_id = ?, msg = ? |,
		[$p{user_id}, $p{msg}]
	);
}

sub hide {
    my ($self, $id) = @_;

    $self->query(
		q| UPDATE news SET visible = 0 WHERE id = ? |,
		[$id]
	);
}

sub can_add {
	my ($self, $user_id) = @_;

	my $last_post_date = $self->query(q|
		SELECT MAX(post_date) last_post_date 
		FROM news
		WHERE user_id = ?
		|,
		[$user_id],
		{only_field => 'last_post_date'}
	);

	return (
		not defined $last_post_date or 
		(time - $last_post_date) > 60*60*24
	);
}	

1;
