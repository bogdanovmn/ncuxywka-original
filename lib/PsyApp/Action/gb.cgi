#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use CGI;
use Psy::GB;
use Psy::Navigation;
use Psy::Errors;
use TEMPLATE;
use Paginator;

my $cgi = CGI->new;
my $action = $cgi->param('action') || 'read';
my $msg = $cgi->param('msg');
my $alias = $cgi->param('alias'); 
my $page = $cgi->param('page') || 1;

my $gb = Psy::GB->enter;

my $tpl = TEMPLATE->new('gb');
#
# Case action
#
if ($action eq 'add') {

	unless ($gb->bot_detected($msg, $alias)) {
		$gb->post_comment(msg => $msg, alias => $alias);
		$gb->update_post_time;
		goto_back();
	}
}
my $pages = Paginator->init(
	total_rows => $gb->comments_total,
	current => $page,
	rows_per_page => Psy::OP_RECS_PER_PAGE,
	uri => '/gb/'
);
#
# Load guest book records
#
my $comments = $gb->load_comments( 
	page => $page,
	reply => 'yeaaah'
);
#
# Set template params
#
$tpl->params(
	comments => $comments, 
	multi_page => 'yes',
	post_button_caption => 'Кря-кря!',
	anti_top_votes => $gb->is_annonimus ? [] : $gb->anti_top_votes,
	$pages->html_template_params,
	%{$gb->common_info}
);

$tpl->show;
