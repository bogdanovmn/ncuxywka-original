##############################
# Author: Mihail N. Bogdanov #
# Date:   03.2009            #
##############################

#
# пВЯЕЛФ ДМС УПЪДБОЙС ХДПВПЮЙФБЕНПЗП УРЙУЛБ УФТБОЙГ
# У ОБЧЙЗБГЙЕК
#
package Paginator;

use strict;
use warnings;
use utf8;


#
# лПОУФТХЛФПТ
# чИПДОЩЕ РБТБНЕФТЩ - TODO
#
sub init {
	my ($class, %params) = @_;
	my $self = {};
	#use Data::Dumper; print "Content-Type: text/html\n\n";print "<pre>".Dumper(%params); exit;
	$self->{visible} = $params{visible} || 4;
	$self->{uri} = $params{uri} || $ENV{SCRIPT_NAME};
	$self->{total_pages} = $params{total_pages} || 0;
	$self->{current} = $params{current} || 1;
	$self->{total_rows} = $params{total_rows} || undef;
	$self->{width} = $params{width};
	$self->{rows_per_page} = $params{rows_per_page} || 20;

	if ($params{total_rows} && $params{rows_per_page}) {
		$self->{total_pages} = round_up($params{total_rows} / $params{rows_per_page});
	}

	$self->{current} = 1 if $self->{current} < 1;
	$self->{current} = $self->{total_pages} if $self->{current} > $self->{total_pages};

	unless ($self->{total_rows}) {
		$self->{total_rows} = $self->{total_pages} * $params{rows_per_page};
	}

	bless($self, $class);

	return $self;
}

#
# пУОПЧОПК НЕФПД - ПФДБЕФ ИЬЫ c РБТБНЕФТБНЙ ДМС ОБЧЙЗБГЙЙ РП УФТБОЙГБН
#
sub html_template_params {
	my $self = shift;
	my $current = $self->{current};
	my $visible = $self->{visible};
	my $total = $self->{total_pages};
	my @left = ();
	my @right = ();
	my $first = 1;
	my $last = $total;
	my $many = undef;
	my $prev_page = $current > 1 ? $current - 1 : undef;
	my $next_page = $current < $total ? $current + 1 : undef;

	for my $p ($current - $visible .. $current + $visible) {
		next if ($p > $total || $p < 1);
		if ($p == 1) { $first = undef; }
		if ($p == $total) { $last = undef; }
		if ($p < $current) { push(@left, { p_uri => $self->{uri}, page => $p }); }
		if ($p > $current) { push(@right, { p_uri => $self->{uri}, page => $p }); }
	}

	my $no_empty = $total > 1 ? 1 : undef;

	if ((scalar(@left) + scalar(@right) + 1) < $total) {
		$many = 1;
	}

	my $left_jump = $first ? $self->page_shift($current, -1 * ($visible*2 + 1)) : undef;
	my $right_jump = $last ? $self->page_shift($current, $visible*2 + 1) : undef;

	my %result = (
		uri => $self->{uri},
		rows_count => $self->{total_rows},
		rows_per_page => $self->{rows_per_page},
		no_empty => $no_empty,		# оЕ РХУФПК УРЙУПЛ УФТБОЙГ
		many => $many,				# уФТБОЙГ НОПЗП
		first => $first,			# рЕТЧБС УФТБОЙГБ ЪБ РТЕДЕМБНЙ РТПУНПФТБ
		left => \@left,				# уФТБОЙГЩ УМЕЧБ ПФ ФЕЛХЭЕК
		right => \@right,			# уФТБОЙГЩ УРТБЧБ ПФ ФЕЛХЭЕК
		last => $last,				# рПУМЕДОСС УФТБОЙГБ ЪБ РТЕДЕМБНЙ РТПУНПФТБ
		next_page => $next_page,	# оПНЕТ УМЕДХАЭЕК УФТБОЙГЩ
		prev_page => $prev_page,	# оПНЕТ РТЕДЩДХЭЕК УФТБОЙГЩ
		current_page => $current,	# оПНЕТ ФЕЛХЭЕК УФТБОЙГЩ
		left_jump => $left_jump,	# оПНЕТ УФТБОЙГЩ МЕЧПЗП РТЩЦЛБ (РЕТЕИПД ЧМЕЧП ОБ N УФТБОЙГ)
		right_jump => $right_jump,	# оПНЕТ УФТБОЙГЩ ДМС РТБЧПЗП РТЩЦЛБ
		width => $self->{width}		# дМЙОБ ПВМБУФЙ РБЗЙОБФПТБ
	);

	return %result;
}

#
# дЕМБЕФ УДЧЙЗ УФТБОЙГЩ N ОБ X ЕДЙОЙГ
#
sub page_shift {
	my ($self, $page, $delta) = @_;
	my $res = $page + $delta;
	if ($res < 1) { $res = 1; }
	if ($res > $self->{total_pages}) { $res = $self->{total_pages}; }

	return $res;
}

#
# пВТЕЪБЕФ УРЙУПЛ Ч УППФЧЕФУФЧЙЙ У РБТБНЕФТБНЙ РБЗЙОБФПТБ
#
sub paged_list {
	my ($self, $list) = @_;
	my $offset = $self->{rows_per_page} * ($self->{current} - 1);
	my $delta = $self->{rows_per_page} - 1;
	my @cuted_list = @$list[$offset .. $offset + $delta];
	my @tmp = ();
	for my $i (@cuted_list) {
		if ($i) { push(@tmp, $i); }
	}
	#use Data::Dumper; print "Content-Type: text/html\n\n";print "<pre>".Dumper($offset, $delta,$self, @tmp); exit;
	return @tmp;
}

#
# пЛТХЗМСЕФ ЮЙУМП Ч ВПМШЫХА УФПТПОХ
#
sub round_up {
	my $x = shift;
	return (int($x) + (int($x) != $x));
}

sub get_page_count {
	my $self = shift;
	return $self->{total_pages};
}

sub get_current_page {
	my $self = shift;
	return $self->{current};
}

1;
