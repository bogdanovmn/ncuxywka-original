package PsyApp::Action::Index;

use strict;
use warnings;
use utf8; 

use Psy;
use Utils;

sub main {
	my ($self) = @_;
	
	my $users_to_exclude = $self->psy->users_to_exclude;

	my $top_creo_list = $self->psy->cache->try_get(
		'top_creo_list__for_user_'. $self->psy->user_id,
		sub { $self->_top(count => 10, users_to_exclude => $users_to_exclude) },
		Cache::FRESH_TIME_HOUR*24
	);

	my $anti_top_creo_list = $self->psy->cache->try_get(
		'anti_top_creo_list__for_user_'. $self->psy->user_id,
		sub { $self->_top(count => 10, anti => 1, users_to_exclude => $users_to_exclude) },
		Cache::FRESH_TIME_HOUR*24
	);
	my $new_users = $self->psy->cache->try_get(
		'new_users',
		sub { $self->_new_users(count => 3) },
		Cache::FRESH_TIME_HOUR
	);

	my $news = $self->psy->cache->try_get(
		'last_news',
		sub { 
			PsyApp::Action::News::View::last($self, 2);
		},
		Cache::FRESH_TIME_HOUR
	);

	return {
		last_creos         => $self->_load_last_creos(10, $users_to_exclude),
		top_creo_list      => $top_creo_list,
		anti_top_creo_list => $anti_top_creo_list,
		#popular_creo_list => $self->psy->popular_creo_list(count => 10), 
		new_users          => $new_users,
		news               => $news,
	};
}

sub _load_last_creos {
    my ($self, $n, $users_to_exclude) = @_;


	my $creos = $self->psy->schema_select('Creo',
		{ 
			type    => 0, 
			user_id => { -not_in => $users_to_exclude } 
		},
		{
			order_by => { -desc => 'post_date' },
			rows     => 35
		},
		[qw/ id user_id /],
		'lc_'
	);

	my @creo;
	my @creo_ids_all;
	my @creo_ids_full;
	my @creo_ids_short;

	my $i = 1;
	my $prev_user_id = 0;
    for my $row (@$creos) {
		if ($prev_user_id eq $row->{lc_user_id}) {
			push @{$creo[@creo - 1]->{lc_more}}, { lc_id => $row->{lc_id} };
			push @creo_ids_short, $row->{lc_id};
		}
		else {
			push @creo, $row;
			push @creo_ids_full, $row->{lc_id};
			$i++;
			$prev_user_id = $row->{lc_user_id};
		}
		push @creo_ids_all, $row->{lc_id};
		
		last if $i > $n;
    }

	my %creo_comments =
		map { $_->{creo_id} => $_->{comments} }
		@{
			$self->psy->schema_select('CreoStat',
				{ creo_id => { -in => \@creo_ids_all } },
				undef,
				[qw/ creo_id comments /]
			)
		};

	my %full_creos = 
		map { $_->{lc_id} => $_ }
		@{
			$self->psy->schema_select('Creo',
				{ id => { -in => \@creo_ids_full } },
				undef,
				[qw/ id title body post_date user_id /],
				'lc_',
				{ 
					user_id         => 'alias',
					nice_date_field => 'post_date' 
				}
			)
		};
	
	my %short_creos = 
		map { 
			$_->{lc_comments_count} = $creo_comments{$_->{lc_id}};
			$_->{lc_id} => $_ 
		}
		@{
			$self->psy->schema_select('Creo',
				{ id => { -in => \@creo_ids_short } },
				undef,
				[qw/ id title post_date /],
				'lc_',
				{ nice_date_field => 'post_date' }
			)
		};

    for my $row (@creo) {
		$row = { %$row, %{$full_creos{$row->{lc_id}}} };
		if ($row->{lc_more}) {
			for my $more (@{$row->{lc_more}}) {
				$more = { %$more, %{$short_creos{$more->{lc_id}}} };
			}
		}

		my $text_original_length = length $row->{lc_body};
		
		#$row->{lc_body} = Psy::Text::Shuffle::text($row->{lc_body}, words_power => 30, chars_power => 5);

		$row->{lc_body} = Psy::Text::convert_to_html($row->{lc_body});
		$row->{lc_body} = Psy::Text::cut_top_lines($row->{lc_body}, Psy::TM_PREVIEW_LINES);
		$row->{lc_body} = Psy::Text::cut_first_chars($row->{lc_body}, Psy::TM_PREVIEW_MAX_SIZE);
		
		$row->{lc_cuted} = 1 if $text_original_length > length $row->{lc_body};
		
		my $user = Psy::User->choose($row->{lc_user_id});
		$row->{lc_avatar} = $user->avatar_file_name;
		$row->{lc_comments_count} = $creo_comments{$row->{lc_id}};
    }

    return \@creo;
}
sub _new_users {
    my ($self, %p) = @_;

	my $user_ids = $self->psy->schema_select(
		'UserStat',
		{ 
			-or => {
				comments_out  => { '>' => 0 },
				spec_comments => { '>' => 0 },
				gb_comments   => { '>' => 0 },
				creo_post     => { '>' => 0 },
			}
		},
		{ 
			order_by => { -desc => 'user_id' },
			rows     => $p{count} || 3
		},
		['user_id'],
	);

	my $users = $self->psy->schema_select(
		'User',
		{ id => { -in => $user_ids } },
		undef,
		[qw/ id name reg_date /],
		'nu_',
		{ date_field => 'reg_date' }
	);

	return $users;
}

sub _top {
	my ($self, %p) = @_;
	
	$p{min_votes} ||= 4;
    $p{count}     ||= 10;

	my $creo_id_list = $self->psy->schema_select(
		'Creo',
		{ 
			type      => 0,
			post_date =>  { '>' => \'NOW() - INTERVAL 36 MONTH' },
			$p{users_to_exclude} 
				? ( user_id => { -not_in => $p{users_to_exclude} } )
				: ()
		},
		undef,
		['id']
	);

	return [] unless @$creo_id_list;
	
	my $direct = $p{anti} ? '-desc' : '-asc';

	my $creo_id_list_sorted = $self->psy->schema_select(
		'CreoStat',
		{
			votes   => { '>' => $p{min_votes} },
			creo_id => { -in => $creo_id_list }
		},
		{
			order_by => [
				{ $direct => 'votes_rank' },
				{ -desc   => 'votes' }
			],
			rows => $p{count}
		},
		['creo_id']

	);

	return [] unless @$creo_id_list_sorted;
	
	return [ 
		sort { $a->{tcl_title} cmp $b->{tcl_title} }
		map  { $_->{tcl_alias} = $self->psy->get_user_name_by_id($_->{tcl_user_id}); $_; }
		@{
			$self->psy->schema_select(
				'Creo',
				{ id =>  { -in => $creo_id_list_sorted } },
				undef,
				[qw/ id title user_id /],
				'tcl_',
				{ user_id => 'alias' }
			)
		}
	];
}


1;
