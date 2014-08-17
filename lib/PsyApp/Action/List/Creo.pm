package PsyApp::Action::List::Creo;

use strict;
use warnings;
use utf8;

use Psy;
use Utils;
use Date;

sub main {
	my ($class, $params) = @_;
	
	my $type        = $params->{type};
	my $neofuturism = $params->{neofuturism};
	my $period      = $params->{period} || 'month';
	my $search_text = $params->{search_text};
	my $psy         = $params->{psy};

	my $first_year = 2010;
	my $last_year  = Date::unix_time_to_ymdhms(time, "%Y");

	my $use_period = not (
		(defined $neofuturism and $neofuturism eq 1) or 
		$type eq Psy::Creo::CT_QUARANTINE or 
		$type eq Psy::Creo::CT_DELETE
	);
	my %periods_table = (
		week  => { value => 7,  title => 'За неделю', order => 0 },
		month => { value => 30, title => 'За месяц',  order => 1 }, 
		#year => { value => 365, title => 'За год' }
	);

	my $order = 2;
	for (my $year = $last_year; $year >= $first_year; $year--) {
		$periods_table{"y".$year} = {
			value => $year, 
			title => $year."г", 
			order => $order
		};
		$order++;
	}

	$period = 'month' unless defined $periods_table{$period}; 
	$period = 'all'   unless $use_period;

	my $creos = Psy::Creo->constructor;
	my $last_creos = $creos->list_by_period(
		type        => $type, 
		period      => $periods_table{$period}->{value},
		neofuturism => $neofuturism
	);

	my @jump_links = map { 
		{
			type     => "creos",
			name     => $_, 
			title    => $periods_table{$_}->{title},
			value    => $periods_table{$_}->{value},
			order    => $periods_table{$_}->{order},
			selected => $_ eq $period
		} 
	} keys %periods_table;

	return {
		regular_creo_list => $use_period,
		creo_list         => $last_creos,
		quarantine        => $type eq Psy::Creo::CT_QUARANTINE,
		deleted           => $type eq Psy::Creo::CT_DELETE,
		neofuturism       => $neofuturism,
		jump_links        => $use_period ? [sort { $a->{order} <=> $b->{order} } @jump_links] : [],
		top_users_by_creos_count => $psy->top_users_by_creos_count,
	};
}

1;
