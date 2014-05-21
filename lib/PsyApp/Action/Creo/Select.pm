package PsyApp::Action::Creo::Select;

use strict;
use warnings;
use utf8;

use Psy::Creo;


sub main {
	my ($class, $params) = @_;

	my $action  = $params->{action} || 'bot';
	my $creo_id = $params->{creo_id};
	my $psy     = $params->{psy};

	my $creo = Psy::Creo->choose($creo_id);

	if ($psy->is_annonimus) {
		return $psy->error("Забыли пароль? Клизьмочка думаю вам поможет...");
	}

	unless ($creo_id) {
		return $psy->error("Может вы заблудились?");
	}

	if ($action eq 'add') {
		return $psy->error("Что за ахинею вы несете?") unless $creo->select_by_user(user_id => $psy->user_id);
	}
	
	if ($action eq 'del') {
		return $psy->error("Что за ахинею вы несете?") unless $creo->deselect_by_user(user_id => $psy->user_id);
	}

	return 1;
}

1;
