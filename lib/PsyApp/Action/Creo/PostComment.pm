package PsyApp::Action::Creo::PostComment;

use strict;
use warnings;
use utf8;

use Psy::Creo;

sub main {
	my ($class, $params) = @_;

	my $id     = $params->{id};
	my $msg    = $params->{msg};
	my $alias  = $params->{alias};
	my $psy    = $params->{psy};

	my $creo = Psy::Creo->choose($id);
	
	unless ($psy->bot_detected($msg, $alias)) {
		$creo->post_comment( 
			user_id => $psy->user_id, 
			msg => $msg,
			alias => $alias
		);
		$psy->update_post_time;
	}

	return 1;
}

1;