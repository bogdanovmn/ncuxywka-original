#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use Psy;
use Psy::Errors;

use TEMPLATE;
use CGI;
use DATE;

my $cgi = CGI->new;
my $search_text = $cgi->param('search_text');

my $psy = Psy->enter;
my $tpl = TEMPLATE->new('creo_search');

$tpl->params(
	creo_list => $psy->creo_search(text => $search_text),
	search_text => $search_text,
	#top_users_by_creos_count => $psy->top_users_by_creos_count,
	%{$psy->common_info}
);

$tpl->show;
