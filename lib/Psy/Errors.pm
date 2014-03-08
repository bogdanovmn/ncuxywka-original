package Psy::Errors;

use strict;
use warnings;

use Psy::Skin;

use TEMPLATE;
use Data::Dumper;

require Exporter;
our @ISA = qw| Exporter |;
our @EXPORT = (qw|
	debug
	error
	debug_sql_explain
|);

sub error {
	my ($msg) = @_;
	my $tpl = TEMPLATE->new('error');
	$tpl->params(
		msg => $msg,
		Psy::Skin::get_skin('original')
	);
	$tpl->show;
	exit;
}

sub debug {
	my $tpl = TEMPLATE->new('error');
	$tpl->params(
		msg => "����� ������ �� ������ �������� ��������:",
		debug => Dumper(\@_),
		Psy::Skin::get_skin('original')
		);
	$tpl->show;
	exit;
}

sub debug_sql_explain {
	my ($data) = @_;
		
	my $tpl = TEMPLATE->new('sql_explain');
	$tpl->params(
		msg => "����� ������ �� ������ �������� ��������:",
		explains => [sort { $b->{total_rows} <=> $a->{total_rows} } @$data],
		Psy::Skin::get_skin('original')
		);
	$tpl->show;
	exit;
}
1;
