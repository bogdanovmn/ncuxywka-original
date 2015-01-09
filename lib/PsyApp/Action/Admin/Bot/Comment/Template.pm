package PsyApp::Action::Admin::Bot::Comment::Template;

use strict;
use warnings;
use utf8;

use Psy::Bot::CommentTemplate;
use Psy::Bot::CommentCategory;
use Psy::Bot::Character;
use Utils;

sub main {
	my ($self) = @_;

	my $psy          = $self->params->{psy};
	my $character_id = $self->params->{character_id} || 1;
	my $category_id  = $self->params->{category_id}  || 1;

	my $characters  = Utils::set_selected_flag(Psy::Bot::Character->constructor->load, $character_id);
	my $categories  = Utils::set_selected_flag(Psy::Bot::CommentCategory->constructor->load, $category_id);
	
	unless ($psy->success_in) {
		return $psy->error("Вы хакер?");
	}

	my $comment_templates = Psy::Bot::CommentTemplate->constructor(
		character_id => $character_id, 
		category_id  => $category_id,
	)->load;
	
	return {
		characters => $characters,
		categories => $categories,
		templates  => $comment_templates
	};
}

1;
