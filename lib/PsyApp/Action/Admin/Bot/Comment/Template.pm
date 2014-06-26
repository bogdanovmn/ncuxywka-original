package PsyApp::Action::Admin::Bot::Comment::Template;

use strict;
use warnings;
use utf8;

use Psy::Bot::CommentTemplate;


sub main {
	my ($class, $params) = @_;

	my $character = $params->{character};
	my $category  = $params->{category};
	my $psy       = $params->{psy};
	
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
