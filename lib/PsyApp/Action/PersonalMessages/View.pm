package PsyApp::Action::PersonalMessages::View;

use strict;
use warnings;
use utf8;

use Psy::User;
use Psy::PersonalMessages;
use Paginator;


sub main {
	my ($class, $params) = @_;

	my $to_user_id = $params->{to_user_id};
	my $action     = $params->{action} || 'last';
	my $page       = $params->{page};
	my $psy        = $params->{psy};

	return undef if $psy->is_annonimus;
	
	my $is_last        = undef;
	my $is_dialog      = undef;
	my $messages       = [];
	my $recipient      = undef;
	my $is_in_messages = undef;

	my $total_rows = 0;
	my $pm_get_params = '/pm/';

	if ($action eq 'dialog') {
		$messages = $psy->pm->load_dialog( 
			from_user_id => $psy->user_id,
			to_user_id   => $to_user_id,
			page         => $page
		);

		$total_rows = $psy->pm->dialog_rows_count(
			from_user_id => $psy->user_id,
			to_user_id   => $to_user_id
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
	
	return {	
		is_last        => $is_last,
		is_dialog      => $is_dialog,
		is_in_messages => $is_in_messages,
		messages       => $messages,
		multi_page     => 'yes',
		recipient_name => $recipient->{u_name},
		recipient_id   => $recipient->{u_id},
		contact_list   => $psy->pm->load_contact_list,
		$pages->html_template_params,
	};
}

1
