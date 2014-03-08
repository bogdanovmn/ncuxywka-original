#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use PSY;
use PSY::NAVIGATION;
use PSY::CREO;
use PSY::ERRORS;

use CGI;

my $cgi = CGI->new;
my $action = $cgi->param('action') || 'bot';
my $creo_id = $cgi->param('creo_id');

error("������ ������? =)") if ($ENV{REQUEST_METHOD} ne 'POST' and $action eq 'add');

my $psy = PSY->enter;
my $creo = PSY::CREO->choose($creo_id);

error("������ ������? ���������� ����� ��� �������...") if $psy->is_annonimus;
error("����� �� �����������?") if (!$creo_id);

if ($action eq 'add') {
	error("��� �� ������ �� ������?") unless $creo->select_by_user(user_id => $psy->user_id);
}
if ($action eq 'del') {
	error("��� �� ������ �� ������?") unless $creo->deselect_by_user(user_id => $psy->user_id);
}

goto_back();
