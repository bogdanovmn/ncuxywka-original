#!/usr/bin/perl

use strict;
use warnings;
use lib 'inc';
use CGI;
use PSY;
use PSY::CREO;
use PSY::ERRORS;
use PSY::NAVIGATION;
use TEMPLATE;

my $cgi = CGI->new;
my $id = $cgi->param('id');

my $psy = PSY->enter;
my $creo = PSY::CREO->choose($id);
my $tpl = TEMPLATE->new('creo_print');

my $common_info = $psy->common_info;

my ($creo_data, $creo_comments) = $creo->load;
unless ($creo_data) {
	pn_goto(URL_404);
}

#
# Set template params
#
$tpl->params(
	%$creo_data,
	comments => [], #$comments || [],
	quarantine => $creo_data->{c_type} eq PSY::CREO::CT_QUARANTINE,
	deleted => $creo_data->{c_type} eq PSY::CREO::CT_DELETE,
	creo_id => $id,
	%$common_info
);

$tpl->show;
