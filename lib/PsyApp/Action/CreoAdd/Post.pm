package PsyApp::Action::CreoAdd::Post;

use strict;
use warnings;
use utf8;

use Psy::Creo;


sub main {
	my ($class, $params) = @_;

	my $title      = $params->{title};
	my $body       = $params->{body};
	my $err        = $params->{err};
	my $faq_flag   = $params->{faq};
	my $black_copy = $params->{black_copy};
	my $psy        = $params->{psy};
	
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
