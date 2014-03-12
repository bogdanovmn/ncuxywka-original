#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use CGI;

use Psy;
use Psy::Creo;
use Psy::User;
use Psy::Errors;
use Psy::Navigation;
use TEMPLATE;

my $cgi = CGI->new;
my $id = $cgi->param('id');

my $update = $cgi->param('update');
my $action = $update ? "update" : $cgi->param('action') || 'preview';
#debug($cgi, $action);

my $creo_title = $cgi->param('title');
my $creo_body = $cgi->param('body');

#debug($cgi);
my $psy = Psy->enter;
my $creo = Psy::Creo->choose($id, black_copy => 1, user_id => $psy->user_id);
my $can_creo_add = $psy->can_creo_add;
my $tpl = TEMPLATE->new('creo_black_copy');

my $common_info = $psy->common_info;
#
# Case action
#
if ($action eq 'public') {
	error("Нас не наебешь!") unless $can_creo_add->{can};

	$creo->update(
		type => $psy->user_id eq Psy::Auth::KRAB_ID ? Psy::Creo::CT_ALEX_JILE : Psy::Creo::CT_CREO,
		post_date => 1
	);
	$psy->update_post_time;
	pn_goto(URL_MAIN);
}
elsif ($action eq 'update') {
	if (!$creo_title or !$creo_body) {
		goto_back();
	}
	$creo->update(
		title => $creo_title,
		body => $creo_body
	);
	pn_goto(sprintf("/black_copy/preview/%d.html", $id));
}

my $creo_data = $creo->load(
	with_comments => 0,
	for_edit => $action eq "edit"
);
unless ($creo_data) {
	pn_goto(URL_404);
}
#
# Set template params
#
$tpl->params(
	%$creo_data,
	creo_id => $id,
	can_public => $can_creo_add->{can},
	time_to_public => $can_creo_add->{time_to_post},
	black_copy_edit => $action eq "edit",
	user_black_copy_creo_list => $psy->black_copy_creo_list,
	%$common_info
);

$tpl->show;
