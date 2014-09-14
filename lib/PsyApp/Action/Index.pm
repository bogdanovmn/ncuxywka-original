package PsyApp::Action::Index;

use strict;
use warnings;
use utf8; 

use Psy;
use Psy::News;
use Utils;

sub main {
	my ($self) = @_;
	
	my $psy = $self->params->{psy};
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
		last_creos         => $psy->load_last_creos(10),
		top_creo_list      => $top_creo_list,
		anti_top_creo_list => $anti_top_creo_list,
		#popular_creo_list => $psy->popular_creo_list(count => 10), 
		new_users          => $new_users,
		news               => $news,
	};
}

sub top {
	my ($self, %p) = @_;
	
	$p{min_votes} ||= 4;
    $p{count}     ||= 10;
	
	my $desc = (defined $p{anti} and $p{anti} eq 1) ? "DESC" : "";

    #my $list = $self->query(qq|
    #    SELECT
    #        c.id tcl_id, 
    #        c.title tcl_title, 
    #        u.name tcl_alias,
	#		CASE WHEN c.user_id = ? OR ? = 0 THEN 1 ELSE sv.vote END tcl_self_vote,
    #        cs.votes_rank tcl_average, 
    #        cs.votes tcl_cnt 
    #    FROM creo c 
	#	JOIN creo_stats cs ON cs.creo_id = c.id
    #    JOIN users u ON u.id = c.user_id
	#	LEFT JOIN user_group ug ON ug.user_id = u.id
	#	LEFT JOIN vote sv ON sv.creo_id = c.id AND sv.user_id = ?
	#	WHERE c.type = 0
	#	AND IFNULL(ug.group_id, 0) <> ?
	#	AND c.post_date >= NOW() - INTERVAL 36 MONTH
    #    AND cs.votes > ? 
    #    ORDER BY tcl_average $desc, tcl_cnt DESC, tcl_title 
    #    LIMIT ?
	#	|,
	#	[$self->user_id, $self->user_id, $self->user_id, Psy::Group::PLAGIARIST, $p{min_votes}, $p{count}],
    #    {error_msg => "Самые буйные психи ускакали прочь!"}
	#);

	my $list = $self->list_by_cond(
		{
			type              => 0,
			post_date         => { '>=' => \["NOW() - INTERVAL ? MONTH", 36] },
			creo_stats => {
				votes => { '>'  => $p{min_votes} }
			},
			
			#scalar @{$p{users_to_exclude}}
			#	? ( user_id => { -not_in => $p{users_to_exclude} } )
			#	: (),
		},
		
		fields => {
			me => [ 
				qw| id title |,
			],
			users => [
				{ name => 'alias' }
			],
			creo_stats => [
				{ votes      => 'cnt'     },
				{ votes_rank => 'average' },
			]
		},
		field_prefix => 'tcl_',
		order_by     => [
			{ desc => 'average' },
			{ desc => 'cnt' },
			'title'
		],
		limit => $p{count},
		debug => 1
	);
use Utils;	webug $list;
    return $list;

}
1;
