package PsyApp::Action::Admin::Bot::Comment::Template::Post;

use strict;
use warnings;
use utf8;

use Psy::Bot::CommentTemplate;


sub main {
	my ($self) = @_;

	my $character = $self->params->{character_id};
	my $category  = $self->params->{category_id};
	my $template  = $self->params->{template};
	my $psy       = $self->params->{psy};
	
	unless ($psy->success_in) {
		return $psy->error("Вы хакер?");
	}

	if ($template =~ /^\s*$/) {
		return $psy->error("Пустой шаблон!");
	}

	Psy::Bot::CommentTemplate->constructor(
		character_id => $character, 
		category_id  => $category,
	)->add($template, $psy->user_id);
	
	return 1;
}

1;
