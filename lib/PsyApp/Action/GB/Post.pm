package PsyApp::Action::GB::Post;

use strict;
use warnings;
use utf8;

use Psy::GB;


sub main {
	my ($class, $params) = @_;

	my $msg   = $params->{msg};
	my $alias = $params->{alias}; 
	my $psy   = $params->{psy};

	my $gb = Psy::GB->enter;

	unless ($psy->bot_detected($msg, $alias)) {
		$gb->post_comment(msg => $msg, alias => $alias);
		$psy->update_post_time;
	}

	return 1;
}

1;
