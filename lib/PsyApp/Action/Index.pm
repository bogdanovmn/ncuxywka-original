package PsyApp::Action::Index;

use strict;
use warnings;

use Psy;
use Psy::News;


sub main {
	my ($class, $params) = @_;

	my $psy = $params->{psy};

	$psy->cache->select('top_creo_list__for_user_'. $psy->user_id, Cache::FRESH_TIME_HOUR);
	my $top_creo_list = $psy->cache->fresh
		? $psy->cache->get
		: $psy->cache->update($psy->top_creo_list(count => 10));

	$psy->cache->select('anti_top_creo_list__for_user_'. $psy->user_id, Cache::FRESH_TIME_HOUR);
	my $anti_top_creo_list = $psy->cache->fresh
		? $psy->cache->get
		: $psy->cache->update($psy->top_creo_list(count => 10, anti => 1));

	$psy->cache->select('new_users', Cache::FRESH_TIME_HOUR);
	my $new_users = $psy->cache->fresh
		? $psy->cache->get
		: $psy->cache->update($psy->new_users(count => 5));

	$psy->cache->select('last_news');
	my $news = $psy->cache->fresh
		? $psy->cache->get
		: $psy->cache->update(Psy::News->constructor->load(2));

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
