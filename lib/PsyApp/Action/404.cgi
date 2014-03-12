#!/usr/bin/perl

use strict;
use warnings;
use lib 'inc';
use PSY;
use PSY::ERRORS;
use TEMPLATE;

my $psy = PSY->enter;
my $common_info = $psy->common_info;
#y $last_creos = $psy->load_last_creos(10);

my $tpl = TEMPLATE->new('404');
$tpl->params(
	#ast_creos => $last_creos,
	#top_creo_list => PSY_STATISTIC::top_creo_list(psy => $psy, count => 10),
	#popular_creo_list => PSY_STATISTIC::popular_creo_list(psy => $psy, count => 10), 
	%$common_info
);

$tpl->show;
