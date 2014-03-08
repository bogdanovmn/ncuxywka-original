#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use PSY;
use PSY::ERRORS;
use PSY::CREO;
use TEMPLATE;
use PAGINATOR;
use CGI;

my $cgi = CGI->new;
my $page = $cgi->param('page') || 1;
my $from_id = $cgi->param('from');
my $for_id = $cgi->param('for');

error("Вы не заблудились, голубчик?") if (($from_id and not $from_id =~ /^\d+$/) or ($for_id and not $for_id =~ /^\d+$/));

my $psy = PSY->enter;
my $tpl = TEMPLATE->new('talks');
#
# Load last comments 
#
my $last_comments = $psy->comments(
	cut => 1,
	page => $page,
	from => $from_id,
	for => $for_id,
	creo_types => [PSY::CREO::CT_CREO, PSY::CREO::CT_QUARANTINE]
);

my $get_params = '';
$get_params = 'from/'.$from_id."/" if $from_id;
$get_params = 'for/'.$for_id."/" if $for_id;
$get_params = sprintf('for/%d/from/%d/', $for_id, $from_id) if ($for_id and $from_id);

my $pages = PAGINATOR->init(
	total_rows => $psy->get_comments_total( from => $from_id, for => $for_id),
	current => $page,
	rows_per_page => PSY::OP_RECS_PER_PAGE,
	uri => '/talks/'.$get_params
);
#
# Some statistic
#
$psy->{cache}->select('most_commented_creo_list', CACHE::FRESH_TIME_HOUR);
my $most_commented_creo_list = $psy->{cache}->fresh
	? $psy->{cache}->get
	: $psy->{cache}->update($psy->most_commented_creo_list(count => 15));

$psy->{cache}->select('most_commented_creo_list_revert', CACHE::FRESH_TIME_HOUR);
my $most_commented_creo_list_revert = $psy->{cache}->fresh
	? $psy->{cache}->get
	: $psy->{cache}->update($psy->most_commented_creo_list(count => 15, sort_order => 'asc'));
#
#Set template params
#
$tpl->params(
	last_comments => $last_comments, 
	multi_page => 'yes',
	most_commented_creo_list => $most_commented_creo_list,
	most_commented_creo_list_revert => $most_commented_creo_list_revert,
	$pages->html_template_params,
	%{$psy->common_info}

);
#debug_sql_explain($PSY::DB::__STATISTIC->{queries_details});
$tpl->show;
