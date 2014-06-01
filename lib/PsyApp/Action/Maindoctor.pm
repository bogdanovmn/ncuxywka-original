package PsyApp::Action::Maindoctor;

use strict;
use warnings;
use utf8;

use Psy::Chart::Data::Common;


sub main {
	my ($class, $params) = @_;
	
	my $psy = $params->{psy};

	my $chart_data = Psy::Chart::Data::Common->constructor;

	my $chart_new_users = $psy->cache->try_get(
		'chart_new_users', 
		sub { $chart_data->new_users },
		Cache::FRESH_TIME_DAY
	);

	my $chart_creos = $psy->cache->try_get(
		'chart_creos', 
		sub { $chart_data->creos },
		Cache::FRESH_TIME_DAY
	);

	my $chart_comments = $psy->cache->try_get(
		'chart_comments', 
		sub { $chart_data->comments },
		Cache::FRESH_TIME_DAY
	);

	my $chart_votes = $psy->cache->try_get(
		'chart_votes', 
		sub { $chart_data->votes },
		Cache::FRESH_TIME_DAY
	);
		
	return {
		chart_new_users => $chart_new_users,
		chart_creos     => $chart_creos,
		chart_comments  => $chart_comments,
		chart_votes     => $chart_votes,
		jquery_flot_required => 1,
		jquery_required      => 1,
		top_selected_creos   => $psy->top_selected_creos(count => 10),
		top_creo_views       => $psy->top_creo_views(count => 30),
		%{$psy->cache->total_size},
	};
}

1
