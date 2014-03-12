#!/usr/bin/perl

use strict;
use warnings;
use lib 'inc';
use CGI;
use Psy;
use Psy::Errors;
use Psy::User;
use Psy::Navigation;
use Psy::PersonalMessages;
use TEMPLATE;
use Paginator;

my $cgi = CGI->new;
my $to_user_id = $cgi->param('user_id');
my $action = $cgi->param('action') || 'last';
my $msg = $cgi->param('msg');
my $page = $cgi->param('page');

my $psy = Psy->enter;
my $tpl = TEMPLATE->new('personal_messages');

error("Совсем охуели? =)") if $psy->is_annonimus;
#
# Case action
#
my $is_last = undef;
my $is_dialog = undef;
my $messages = [];
my $recipient = undef;
my $is_in_messages = undef;

if ($action eq 'post') {
	unless ($psy->bot_detected($msg)) {
		$psy->pm->post( 
			to_user_id => $to_user_id,
			msg => $msg
		);
		$psy->update_post_time;
		goto_back();
	};
}

my $total_rows = 0;
my $pm_get_params = '/pm/';

if ($action eq 'dialog') {
	error("Вы заблудились?") unless $to_user_id;

	$messages = $psy->pm->load_dialog( 
		from_user_id => $psy->user_id,
		to_user_id => $to_user_id,
		page => $page
	);

	$total_rows = $psy->pm->dialog_rows_count(
		from_user_id => $psy->user_id,
		to_user_id => $to_user_id
	);

	$recipient = Psy::User->choose($to_user_id)->info;
	$is_dialog = 1;

	$pm_get_params .= 'dialog/'. $to_user_id. '/';
}

if ($action eq 'in' or $action eq 'out') {
	$messages = $psy->pm->load(direct => $action, page => $page);
	$psy->pm->mark_as_read;

	$total_rows = $psy->pm->rows_count(direct => $action);

	$is_last = 1;
	$is_in_messages = 1 if $action eq 'in';

	$pm_get_params .= $action. '/';
}

my $pages = Paginator->init(
	total_rows => $total_rows,
	current => $page,
	rows_per_page => Psy::PersonalMessages::PM_RECS_PER_PAGE,
	uri => $pm_get_params
);
#
# Load contact list
#
my $contact_list = $psy->pm->load_contact_list;
#
# Set template params
#
$tpl->params(
	is_last => $is_last,
	is_dialog => $is_dialog,
	is_in_messages => $is_in_messages,
	messages => $messages,
	multi_page => 'yes',
	$pages->html_template_params,
	recipient_name => $recipient->{u_name},
	recipient_id => $recipient->{u_id},
	contact_list => $contact_list,
	%{$psy->common_info}
);

$tpl->show;
