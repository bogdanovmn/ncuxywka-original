package Psy::Navigation;

use strict;
use warnings;

use CGI;
use Psy::Errors;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(
	URL_MAIN
	URL_BANNED
	URL_404
	web_root
	pn_goto
	goto_back
	goto_room
);

#
# URLs
#
use constant URL_MAIN => "/main/";
use constant URL_BANNED => "/proc_room/";
use constant URL_404 => "/404.html";
#
# Static methods
#
sub web_root {
	my $port = defined $ENV{SERVER_PORT} ? ":".$ENV{SERVER_PORT} : "";
	return "";#.$port;
	#return $ENV{SERVER_NAME} =~ /rednikov|forest/ ?
	#	"http://". $ENV{SERVER_NAME}. "/ltasker/" :
	#	"http://ltasker/";
}

sub pn_goto {
	my ($url, %params) = @_;
	my $goto_url = web_root(). $url;

	my $params_string = "";
	while (my ($name, $value) = each %params) {
		$params_string .= $name. "=". $value. "&";
	}
	if ($params_string) {
		chop $params_string;
		$params_string = "?". $params_string;
	}
	print CGI::redirect(-url => $goto_url. $params_string);
	exit;
}

sub goto_back {
	my $goto_url = $ENV{HTTP_REFERER};
	print CGI::redirect(-url => $goto_url);
	exit;
}

sub goto_room  {
	my $room = shift;
	print CGI::redirect(sprintf('/%s_room/', $room));
	exit;
}
1;
