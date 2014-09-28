package PsyApp::Action::Admin::Bot::Comment::Template;

use strict;
use warnings;
use utf8;

use Psy::Bot::CommentTemplate;


sub main {
	my ($self) = @_;

	my $character = $self->params->{character};
	my $category  = $self->params->{category};
	my $psy       = $self->params->{psy};
	
	unless ($psy->success_in) {
		return $psy->error("Вы хакер?");
	}

	my $comment_templates = Psy::Bot::CommentTemplate->constructor(
		character_id => $character, 
		category_id  => $category,
	)->load;
	
	return {
		character_id => $character,
		category_id  => $category,
		templates    => $comment_templates
	};
}

1;
