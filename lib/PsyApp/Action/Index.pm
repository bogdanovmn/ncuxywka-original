package PsyApp::Action::Index;

use strict;
use warnings;
use utf8; 

use Psy;
use Psy::News;
use Utils;

sub main {
	my ($class, $params) = @_;
	
	my $psy = $params->{psy};
#webug $psy;
	my $top_creo_list = $psy->cache->try_get(
		'top_creo_list__for_user_'. $psy->user_id,
		#sub { $psy->top_creo_list(count => 10) },
		sub { Psy::Creo->constructor->top(count => 10) },
		Cache::FRESH_TIME_HOUR
	);

	my $anti_top_creo_list = $psy->cache->try_get(
		'anti_top_creo_list__for_user_'. $psy->user_id,
		sub { $psy->top_creo_list(count => 10, anti => 1) },
		#ub { Psy::Creo->constructor->top(count => 10, anti => 1) },
		Cache::FRESH_TIME_HOUR
	);

	my $new_users = $psy->cache->try_get(
		'new_users',
		sub { $psy->new_users(count => 5) },
		Cache::FRESH_TIME_HOUR
	);

	my $news = $psy->cache->try_get(
		'last_news',
		sub { Psy::News->constructor->load(2) },
		Cache::FRESH_TIME_HOUR
	);

	return {
		last_creos => $psy->load_last_creos(10),
		top_creo_list => $top_creo_list,
		anti_top_creo_list => $anti_top_creo_list,
		#popular_creo_list => $psy->popular_creo_list(count => 10), 
		new_users => $new_users,
		news => $news,
	};
}

1;
