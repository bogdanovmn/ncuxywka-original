use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin.'/../lib';
use lib $FindBin::Bin.'/../conf';

use Test::More 'no_plan';

use PsyApp;
use Dancer::Test;


my @urls = qw|
	/
	/main/
	/faq_room/
	/register/
	/add_creo/
	/gb/
	/users/
	/creos/
	/quarantine/
	/talks/
	/user_edit/
	/pm/in/

	/talks/from/16
	/talks/for/16
	/talks/for/5/from/16
	
	/wish_room/
	/petr_room/
	/frenizm_room/
	/mainshit_room/
	/proc_room/
	/neofuturism/
	/neo_faq_room/

	/users/16.html
	/creos/954.html
	/print/954.html
|;

foreach my $url (@urls) {
	response_status_is [GET => $url], 200, "GET $url status is 200";
}
