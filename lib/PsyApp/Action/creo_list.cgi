#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use Psy;
use Psy::Errors;
use Psy::Navigation;

use TEMPLATE;
use CGI;
use DATE;

my $cgi = CGI->new;
my $secret_flag = $cgi->param('sf');
my $type = $cgi->param('type');
my $neofuturism = $cgi->param('neofuturism');
my $period = $cgi->param('period') || 'month';
my $search_text = $cgi->param('search_text');

pn_goto(URL_404) unless $secret_flag;

#ERRORS::html_debug(\%ENV);
my $psy = Psy->enter;
my $tpl = TEMPLATE->new('creo_list');

my $first_year = 2010;
my $last_year = unix_time_to_ymdhms(time, "%Y");

my $use_period = not (
	(defined $neofuturism and $neofuturism eq 1) or 
	$type eq Psy::Creo::CT_QUARANTINE or 
	$type eq Psy::Creo::CT_DELETE
);

my %periods_table = (
	week => { value => 7, title => '�� ������', order => 0 },
	month => { value => 30, title => '�� �����', order => 1 }, 
	#year => { value => 365, title => '�� ���' }
);

my $order = 2;
for (my $year = $last_year; $year >= $first_year; $year--) {
	$periods_table{"y".$year} = {value => $year, title => $year."�", order => $order};
	$order++;
}

$period = 'month' unless defined $periods_table{$period}; 
$period = 'all' if not $use_period;

my $last_creos = $psy->creo_list(
	type => $type, 
	period => $periods_table{$period}->{value},
	neofuturism => $neofuturism
);

my @jump_links = map { 
	{
		type => "creos",
		name => $_, 
		title => $periods_table{$_}->{title},
		value => $periods_table{$_}->{value},
		order => $periods_table{$_}->{order},
		selected => $_ eq $period
	} 
} keys %periods_table;

$tpl->params(
	regular_creo_list => $use_period,
	creo_list => $last_creos,
	quarantine => $type eq Psy::Creo::CT_QUARANTINE,
	deleted => $type eq Psy::Creo::CT_DELETE,
	neofuturism => $neofuturism,
	jump_links => $use_period ? [sort { $a->{order} <=> $b->{order} } @jump_links] : [],
	top_users_by_creos_count => $psy->top_users_by_creos_count,
	%{$psy->common_info(skin => $neofuturism ? 'neo' : undef)}
);

$tpl->show;
