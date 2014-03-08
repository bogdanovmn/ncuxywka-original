#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use CGI;

use PSY;
use PSY::CREO;
use PSY::NAVIGATION;
use PSY::ERRORS;

use TEMPLATE;

my $cgi = CGI->new;
my $action = $cgi->param('action') || 'read';
my $title = $cgi->param('title');
my $body = $cgi->param('body');
my $alias = $cgi->param('alias');
my $err = $cgi->param('err');
my $faq_flag = $cgi->param('faq');
my $black_copy = $cgi->param('black_copy');

my $psy = PSY->enter;
my $creo_add_info = $psy->can_creo_add;

if ($action eq 'add' and $creo_add_info->{can}) {
	error("Совсем охуели? =)") if $ENV{REQUEST_METHOD} ne 'POST';
	
	unless($faq_flag) {
		print $cgi->redirect(sprintf('http://%s/faq_room/', $ENV{SERVER_NAME}));
		exit;
	}
	if (!$title or !$body or !$alias) {
		print $cgi->redirect(sprintf('http://%s%s', $ENV{SERVER_NAME}, $ENV{SCRIPT_NAME}));
		exit;
	}
	unless($psy->{user_data}->{user_id}) {
		print $cgi->redirect(sprintf('http://%s%s', $ENV{SERVER_NAME}, $ENV{SCRIPT_NAME}));
		exit;
	}
}

my $tpl = TEMPLATE->new('add_creo');
#
# Case action
#
if ($action eq 'add' and ($black_copy or $creo_add_info->{can})) {
	my $creo = PSY::CREO->new(
		title => $title, 
		body => $body,
		user_id => $psy->user_id,
		black_copy => $black_copy
	);
	if ($creo) { 
		$creo->save;
		$psy->update_post_time;
		if ($black_copy) {
			pn_goto("/add_creo/");
		}
		else {
			pn_goto(URL_MAIN);
		}
	}
	else {
		goto_back();
	}

}
#
# Set template params
#
#debug($psy->black_copy_creo_list);
$tpl->params(
	can_add =>  $creo_add_info->{can},
	time_to_post => $creo_add_info->{time_to_post},
	user_black_copy_creo_list => $psy->black_copy_creo_list,
	%{$psy->common_info}

);

$tpl->show;
