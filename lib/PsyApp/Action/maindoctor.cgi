#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use CGI;
use Psy;
use Psy::Chart::DATA::COMMON;
use Psy::Navigation;
use Psy::Errors;
use TEMPLATE;

my $cgi = CGI->new;

my $psy = Psy->enter;

my $chart_data = Psy::Chart::DATA::COMMON->constructor;

$psy->cache->select('chart_new_users', CACHE::FRESH_TIME_DAY);
my $chart_new_users = $psy->cache->fresh
	? $psy->cache->get
	: $psy->cache->update($chart_data->new_users);

$psy->cache->select('chart_creos', CACHE::FRESH_TIME_DAY);
my $chart_creos = $psy->cache->fresh
	? $psy->cache->get
	: $psy->cache->update($chart_data->creos);

$psy->cache->select('chart_comments', CACHE::FRESH_TIME_DAY);
my $chart_comments = $psy->cache->fresh
	? $psy->cache->get
	: $psy->cache->update($chart_data->comments);

$psy->cache->select('chart_votes', CACHE::FRESH_TIME_DAY);
my $chart_votes = $psy->cache->fresh
	? $psy->cache->get
	: $psy->cache->update($chart_data->votes);

my $tpl = TEMPLATE->new('maindoctor');
#
# Set template params
#
$tpl->params(
	chart_new_users => $chart_new_users,
	chart_creos => $chart_creos,
	chart_comments => $chart_comments,
	chart_votes => $chart_votes,
	jquery_flot_required => 1,
	jquery_required => 1,
	top_selected_creos => $psy->top_selected_creos(count => 10),
	top_creo_views => $psy->top_creo_views(count => 30),
	%{$psy->cache->total_size},
	%{$psy->common_info}
);

$tpl->show;
