package Psy::Bot::CommentCategory;

use strict;
use warnings;
use utf8;

use base 'Psy::DB';
#
# Bot object constructor
#
sub constructor {
	my ($class, %p) = @_;

	my $self = $class->SUPER::connect;
	
	return $self;
}

sub load {
	my ($self) = @_;
	
	return $self->query(qq| 
		SELECT * 
		FROM   bot_comment_category
		ORDER  BY name
		|,
	);
}

1;
