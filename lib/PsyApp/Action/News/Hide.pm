package PsyApp::Action::News::Hide;

use strict;
use warnings;
use utf8;

use Psy::News;


sub main {
	my ($class, $params) = @_;

	my $id  = $params->{id};
	my $psy = $params->{psy};
	
	my $news = Psy::News->constructor;

	unless ($psy->is_god) {
		return $psy->error("Врачей не наипешь!");
	}

	$news->hide($id);

	return not $psy->error;
}

1;
