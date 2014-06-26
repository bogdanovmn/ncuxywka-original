package Psy::Bot::CommentTemplate;

use strict;
use warnings;
use utf8;

use base 'Psy::DB';
#
# Bot object constructor
#
sub constructor {
	my ($class, %p) = @_;

	my $self = Psy::DB::connect($class);
	$self->{character_id} = $p{character_id};
	$self->{category_id}  = $p{category_id};
	
	return $self;
}

sub add {
	my ($self, $template, $author_id) = @_;

	$self->query(qq|
		INSERT INTO bot_comment_template
		SET bot_character_id         = ?,
			bot_comment_category_id  = ?,
			template     = ?,
			author_id    = ?
		|,
		[ $self->{character_id}, $self->{category_id}, $template, $author_id ]
	);
}

sub load {
	my ($self) = @_;

	return $self->query(qq| 
		SELECT * 
		FROM bot_comment_template
		WHERE bot_character_id        = ?
		AND   bot_comment_category_id = ?
		|,
		[ $self->{character_id}, $self->{category_id} ]
	);
}

1;
