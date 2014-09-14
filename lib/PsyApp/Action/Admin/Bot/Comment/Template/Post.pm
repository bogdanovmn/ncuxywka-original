package PsyApp::Action::Admin::Bot::Comment::Template::Post;

use strict;
use warnings;
use utf8;

use Psy::Bot::CommentTemplate;


sub main {
	my ($self) = @_;

	my $character = $self->params->{character};
	my $category  = $self->params->{category};
	my $template  = $self->params->{template};
	my $psy       = $self->params->{psy};
	
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
