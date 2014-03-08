package PSY::ERRORS;

use strict;
use warnings;

use PSY::SKIN;

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
		PSY::SKIN::get_skin('original')
	);
	$tpl->show;
	exit;
}

sub debug {
	my $tpl = TEMPLATE->new('error');
	$tpl->params(
		msg => "ѕсихи рисуют на стенах странные письмена:",
		debug => Dumper(\@_),
		PSY::SKIN::get_skin('original')
		);
	$tpl->show;
	exit;
}

sub debug_sql_explain {
	my ($data) = @_;
		
	my $tpl = TEMPLATE->new('sql_explain');
	$tpl->params(
		msg => "ѕсихи рисуют на стенах странные письмена:",
		explains => [sort { $b->{total_rows} <=> $a->{total_rows} } @$data],
		PSY::SKIN::get_skin('original')
		);
	$tpl->show;
	exit;
}
1;
