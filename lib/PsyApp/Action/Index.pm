package PsyApp::Action::Index;

use strict;
use warnings;
use utf8; 

use Psy;
use Utils;

sub main {
	my ($self) = @_;
	
	my $psy = $self->params->{psy};
	my $users_to_exclude = $psy->users_to_exclude;

	my $top_creo_list = $psy->cache->try_get(
		'top_creo_list__for_user_'. $psy->user_id,
		sub { $self->_top(count => 10, users_to_exclude => $users_to_exclude) },
		Cache::FRESH_TIME_HOUR
	);

	my $anti_top_creo_list = $psy->cache->try_get(
		'anti_top_creo_list__for_user_'. $psy->user_id,
		sub { $self->_top(count => 10, anti => 1, users_to_exclude => $users_to_exclude) },
		Cache::FRESH_TIME_HOUR
	);
	my $new_users = $psy->cache->try_get(
		'new_users',
		sub { $psy->new_users(count => 3) },
		Cache::FRESH_TIME_HOUR
	);

	my $news = $psy->cache->try_get(
		'last_news',
		sub { 
			PsyApp::Action::News::View::last($self, 2);
		},
		Cache::FRESH_TIME_HOUR
	);

	return {
		last_creos         => $psy->load_last_creos(10),
		top_creo_list      => $top_creo_list,
		anti_top_creo_list => $anti_top_creo_list,
		#popular_creo_list => $psy->popular_creo_list(count => 10), 
		new_users          => $new_users,
		news               => $news,
	};
}

sub _top {
	my ($self, %p) = @_;
	
	$p{min_votes} ||= 4;
    $p{count}     ||= 10;

	my $where_users = @{$p{users_to_exclude}}
		? sprintf 'AND c.user_id NOT IN (%s)', join ', ', @{$p{users_to_exclude}}
		: '';

	my $creo_id_list = $self->psy->query(qq|
		SELECT c.id
		FROM creo c
		WHERE c.type = 0
		AND c.post_date >= NOW() - INTERVAL ? MONTH
		$where_users
		|,
		[36],
		{ list_field => 'id' }
	);

	return [] unless @$creo_id_list;
	
	my $where_creo_id = sprintf 'WHERE cs.creo_id IN (%s)', join ', ', @$creo_id_list;
	my $direct        = $p{anti} ? 'DESC' : 'ASC';

	my $creo_id_list_sorted = $self->psy->query(qq|
		SELECT cs.creo_id
		FROM creo_stats cs
		$where_creo_id
		AND cs.votes > ?
		ORDER BY cs.votes_rank $direct, cs.votes DESC
		LIMIT ?
		|,
		[$p{min_votes}, $p{count}],
		{ list_field => 'creo_id' }
	);

	return [] unless @$creo_id_list_sorted;
	
	$where_creo_id = sprintf 'WHERE c.id IN (%s)', join ', ', @$creo_id_list_sorted;
	return [ 
		sort { $a->{tcl_title} cmp $b->{tcl_title} }
		map  { $_->{tcl_alias} = $self->psy->get_user_name_by_id($_->{user_id}); $_; }
		@{
			$self->psy->query(qq|
				SELECT 
					c.id    tcl_id,
					c.title tcl_title,
					c.user_id
				FROM creo c
				$where_creo_id
				|
			)
		}
	];
}


1;
