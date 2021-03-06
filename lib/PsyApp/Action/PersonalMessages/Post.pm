package PsyApp::Action::PersonalMessages::Post;

use strict;
use warnings;
use utf8;


sub main {
	my ($self) = @_;

	my $to_user_id = $self->params->{user_id};
	my $msg        = $self->params->{msg};
	my $psy        = $self->params->{psy};

	if ($psy->is_annonimus) {
		return $psy->error("Вы хакер?");
	}

	if ($msg =~ /^\s*$/) {
		return $psy->error("Пустое сообщение... Ваш собеседник телепат?");
	}
	
	if ($psy->bot_detected($msg)) {
		return $psy->error("Вы смахиваете на бота...");
	}

	unless ($psy->pm->post(to_user_id => $to_user_id, msg => $msg)) {
		return $psy->error("Что-то пошло не так...");
	}

	$psy->update_post_time;

	return 1;
}

1
