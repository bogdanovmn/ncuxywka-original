package PsyApp::Action::AddCreo::Post;

use strict;
use warnings;
use utf8;

use Psy::Creo;


sub main {
	my ($self) = @_;

	my $title      = $self->params->{title};
	my $body       = $self->params->{body};
	my $err        = $self->params->{err};
	my $faq_flag   = $self->params->{faq};
	my $black_copy = $self->params->{black_copy};
	my $psy        = $self->params->{psy};
	
	unless ($psy->success_in) {
		return $psy->error("Вы хакер?");
	}

	my $creo_add_info = $psy->can_creo_add;

	if ($creo_add_info->{can}) {
		unless ($faq_flag) {
			return $psy->error("Необходимо ознакомиться с FAQ'ом");
		}
		
		unless ($title) {
			return $psy->error("Название должно быть заполнено!");
		}
		
		unless ($body) {
			return $psy->error("Текст анализа должен быть заполнен!");
		}
	}

	if ($black_copy or $creo_add_info->{can}) {
		my $creo = Psy::Creo->new(
			title      => $title, 
			body       => $body,
			user_id    => $psy->user_id,
			black_copy => $black_copy
		)->save;
		$psy->update_post_time;
	}
	
	return 1;
}

1;
