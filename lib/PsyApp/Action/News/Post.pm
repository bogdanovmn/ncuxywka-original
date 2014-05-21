package PsyApp::Action::News::Post;

use strict;
use warnings;
use utf8;

use Psy::News;


sub main {
	my ($class, $params) = @_;

	my $msg = $params->{msg};
	my $psy = $params->{psy};
	
	my $news = Psy::News->constructor;

	unless ($psy->is_god) {
		return $psy->error("Врачей не наипешь!");
	}

	$news->add(
		user_id => $psy->user_id,
		msg     => $msg
	);

	return not $psy->error;
}

1;
