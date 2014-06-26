package PsyApp::Action::Admin::Bot::Comment::Template::Post;

use strict;
use warnings;
use utf8;

use Psy::Bot::CommentTemplate;


sub main {
	my ($class, $params) = @_;

	my $character = $params->{character};
	my $category  = $params->{category};
	my $template  = $params->{template};
	my $psy       = $params->{psy};
	
	unless ($psy->success_in) {
		return $psy->error("Вы хакер?");
	}

	if ($template =~ /^\s*$/) {
		$psy->error("Пустой шаблон!");
	}

	my $comment_templates = Psy::Bot::CommentTemplate->constructor(
		character_id => $character, 
		category_id  => $category,
	)->add($template);
	
	return 1;
}

1;
