#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use CGI;

use Psy;
use Psy::Navigation;
use Psy::User;

use TEMPLATE;

my $cgi = CGI->new;
my $action = $cgi->param('action') || 'read';
my $name = $cgi->param('name');
my $password = $cgi->param('password');
my $password_check = $cgi->param('password_check');
my $about = $cgi->param('about');
my $email = $cgi->param('email');
my $loves = $cgi->param('loves');
my $hates = $cgi->param('hates');
my $city = $cgi->param('city');

my $psy = Psy->enter;

if ($action eq 'add') {
	if (!$name or !$password or !$password_check or !$email) {
		print $cgi->redirect(sprintf('http://%s/register/', $ENV{SERVER_NAME}));
		exit;
	}
	if ($password ne $password_check) {
		print $cgi->redirect(sprintf('http://%s/register/', $ENV{SERVER_NAME}));
		exit;
	}
}
#
# Case action
#
if ($action eq 'add') {
	my $user = Psy::User->new(
		name => $name, 
		about => $about,
		email => $email,
		loves => $loves,
		hates => $hates,
		city => $city,
		password => $password
	);
	if ($user) {
		$user->save;
		pn_goto(URL_MAIN);
	}
	else {
		goto_back();
	}
}
#
# Set template params
#
my $tpl = TEMPLATE->new('register');
$tpl->params(
	%{$psy->common_info}
);

$tpl->show;
