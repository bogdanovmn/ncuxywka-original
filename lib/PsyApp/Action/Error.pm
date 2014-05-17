package PsyApp::Action::Error;

use strict;
use warnings;
use utf8;


sub main {
	my ($class, $params) = @_;

	return { 
		error_msg => $params->{error_msg}
	};
}

1;
