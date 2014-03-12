#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use Psy;
use Psy::Errors;

use CGI;

my $cgi = CGI->new;
my $action = $cgi->param('action') || 'bot';
my $name = $cgi->param('name');
my $password = $cgi->param('password');

my $psy = Psy->enter;

if ($action eq 'in' and $psy->is_annonimus) {
	$psy->login(user_name => $name, password => $password);
}
elsif ($action eq 'out' and not $psy->is_annonimus) {
	$psy->logout;
}
else {
	error("Может вы заблудились?");
}

my $redirect_to = $ENV{HTTP_REFERER};
$redirect_to = "http://ncuxywka.com/" if ($ENV{HTTP_REFERER} =~ /user_edit/ or not defined $ENV{HTTP_REFERER}); 
$redirect_to = "http://ncuxywka.com/" if ($ENV{HTTP_REFERER} =~ /\/pm\// or not defined $ENV{HTTP_REFERER}); 

my @cookie_header = split(/\n/, $psy->{session}->header);

#ERRORS::html_debug($psy->{session}->header);

#print "Content-Type: text/html\n\n";
print $cookie_header[0];
print $cookie_header[1];
print $cgi->redirect(-url => $redirect_to);

exit;
