package Psy::Statistic;

use strict;
use warnings;
use utf8;

use Psy::Group;
use Psy::Auth;
use Utils;

sub creo_list {
    my ($self, %p) = @_;

	my $limit = $p{count} ? 'LIMIT ?' : '';
	
	my $where_user = $p{user_id} ? "AND c.user_id = ?" : "";
	my $where_type = defined $p{type} ? 'AND c.type = ?' : 'AND c.type IN (0, 1)';
	
	my $where_period = '';
	if (defined $p{period}) {
		if ($p{period} > 2009) {
			$where_period = "AND DATE_FORMAT(c.post_date, '%Y') = ?";
		}
		else {
			$where_period = "AND c.post_date >= NOW() - INTERVAL ? DAY";
		}
	} 
	
	my $users_to_exclude = $self->users_to_exclude;
	my $users_to_exclude_cond = scalar @$users_to_exclude
		? sprintf 'AND c.user_id NOT IN (%s)', join(',', @$users_to_exclude)
		: '';

	my $where_neofuturism = defined $p{neofuturism} ? "AND neofuturism = ?" : "";

    my @query_params = ($self->user_id, $self->user_id, $self->user_id);
    push(@query_params, $p{user_id}) if defined $p{user_id};
    push(@query_params, $p{type}) if defined $p{type};
	push(@query_params, $p{period}) if defined $p{period};
    push(@query_params, $p{count}) if defined $p{count};
    push(@query_params, $p{neofuturism}) if defined $p{neofuturism};

    my $list = $self->query(qq|
        SELECT
            c.id   cl_id,
            c.type cl_type,
			CASE c.type WHEN 1 THEN 1 ELSE 0 END cl_quarantine,
            c.user_id cl_user_id,
            u.name cl_alias,
            c.title cl_title,
            CASE DATE_FORMAT(c.post_date, '%Y%m%d') 
				WHEN DATE_FORMAT(NOW(), '%Y%m%d') THEN 'Сегодня'
				WHEN DATE_FORMAT(NOW() - INTERVAL 1 DAY, '%Y%m%d') THEN 'Вчера'
				ELSE DATE_FORMAT(c.post_date, '%Y-%m-%d') 
			END cl_post_date,
            cs.comments cl_comments_count,
			CASE WHEN c.user_id = ? OR ? = 0 THEN 1 ELSE sv.vote END cl_self_vote,
            cs.votes cl_votes_count,
            cs.votes_rank cl_votes_rank
        FROM creo c
		JOIN creo_stats cs ON cs.creo_id = c.id
        JOIN users u ON u.id = c.user_id
		LEFT JOIN vote sv ON sv.creo_id = c.id AND sv.user_id = ?
        WHERE 1 = 1
            $where_user
            $where_type
			$where_period
			$where_neofuturism
        ORDER BY
            c.post_date DESC
		$limit
		|,
		[@query_params],
		{error_msg => "Список анализов утонул в сливном бочке!"}
	);

    return $list;
}

sub random_creo_list {
    my ($self, %p) = @_;

	$p{count} = 5 unless $p{count} =~ /^\d+$/;
	
	#
	# Получаем список забаненых юзеров
	#
	my $banned_users = $self->users_to_exclude(self => 1);
	if ($p{user_id}) {
		push @$banned_users, $p{user_id};
	}

	my $exclude_user_cond = scalar(@$banned_users)
		? sprintf('AND us.user_id NOT IN (%s)', join(",", @$banned_users))
		: '';
	#
	# Кол-во юзеров
	#
	my $users = $self->query(qq|
		SELECT us.user_id 
		FROM user_stats us
		WHERE us.creo_post > 2
		$exclude_user_cond
		|,
		[],
		{ list_field => 'user_id' }
	);
	my $users_cond = sprintf(
		'AND c.user_id IN (%s) ', 
		join(',', @{List::rand_list(source => $users, count => $p{count})})
	);
	
	my %creos_by_users; 
	my $data = $self->query(qq|
		SELECT 
			c.id, 
			c.user_id 
		FROM creo c
		JOIN users u ON u.id = c.user_id
		WHERE c.type = 0
		$users_cond 
		|,
	);
	
	foreach (@$data) {
		push @{$creos_by_users{$_->{user_id}}}, $_->{id};
	}

	my $creo_cond = sprintf(
		'WHERE c.id IN (%s)',
		join(',', 
			map { List::random_element(@{$creos_by_users{$_}}) }
			keys %creos_by_users
		)
	);

	my $list = $self->query(qq|
		SELECT 
			c.id      cl_id, 
			c.user_id cl_user_id, 
			c.title   cl_title, 
			u.name    cl_alias
		FROM creo c
		JOIN users u ON u.id = c.user_id
		$creo_cond
		|,
	);

    return $list;
}

sub popular_creo_list {
	my ($self, %p) = @_;
    
	my $list = $self->query(qq|
        SELECT
			*,
			IFNULL(cmu.name, cm.alias) pcl_comment_alias
		FROM (
			SELECT
				c.id pcl_id, 
				c.title pcl_title, 
				u.name pcl_alias,
				ROUND( COUNT(cm.id) / ((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(c.post_date)) / 86400), 2) pcl_rank,
				CASE DATE_FORMAT(MAX(cm.post_date), '%Y%m%d') 
					WHEN DATE_FORMAT(NOW(), '%Y%m%d') THEN DATE_FORMAT(MAX(cm.post_date), '%H:%i')
					ELSE DATE_FORMAT(MAX(cm.post_date), '%Y-%m-%d %H:%i') 
				END pcl_last_comment_date,
				cm.post_date post_date_for_order,
				MAX(cm.id) pcl_cm_id
			FROM creo c 
			LEFT JOIN comments cm ON c.id = cm.creo_id
			JOIN users u ON u.id = c.user_id 
			LEFT JOIN users cmu ON cm.user_id = cmu.id
			GROUP BY c.id
			ORDER BY pcl_rank DESC 
			LIMIT ?
		) pcl_select,
		comments cm
		LEFT JOIN users cmu ON cmu.id = cm.user_id
		WHERE cm.id = pcl_select.pcl_cm_id
		ORDER BY pcl_select.post_date_for_order DESC
		|,
		[$p{count} || 10],
        {error_msg => "Самые говорливые психи ускакали прочь!"}
	);

    for (my $i = 0; $i < scalar @$list; $i++) {
		$list->[$i]->{pcl_last_comment_idle} = short_time($list->[$i]->{pcl_last_comment_idle});
    }

    return $list;
}
#
# Load top creos list
#}
sub most_commented_creo_list {
    my ($self, %p) = @_;

    $p{count} ||= 10;
	my $sort_order = (defined $p{sort_order} and $p{sort_order} eq 'asc') ? '' : 'DESC';

    my $list = $self->query(qq|
        SELECT
            c.id mccl_id, 
            c.title mccl_title, 
            u.name mccl_alias,
            cs.comments mccl_cnt 
        FROM creo c 
		JOIN creo_stats cs ON cs.creo_id = c.id
        JOIN users u ON u.id = c.user_id
		LEFT JOIN user_group ug ON ug.user_id = u.id
		WHERE c.type = 0
		AND IFNULL(ug.group_id, 0) <> ?
        ORDER BY mccl_cnt $sort_order
        LIMIT ?
		|,
		[Psy::Group::PLAGIARIST, $p{count}],
        {error_msg => "Самые говорливые психи ускакали прочь!"}
	);

    return $list;
}

sub top_users_by_votes {
    my ($self, %p) = @_;

    $p{min_votes} ||= 15;
    $p{count} ||= 15;

    my $users = $self->query(qq|
        SELECT
            u.id tul_user_id,
            u.name tul_user_name,
            us.votes_in_rank tul_average,
            us.votes_in tul_cnt
        FROM users u
		JOIN user_stats us ON us.user_id = u.id
		LEFT JOIN user_group ug ON ug.user_id = u.id
        WHERE IFNULL(ug.group_id, 0) <> ?
        AND us.votes_in > ?
        ORDER BY tul_average
        LIMIT ?
		|,
		[Psy::Group::PLAGIARIST, $p{min_votes}, $p{count}],
        {error_msg => "Самые уважаемые психи ускакали прочь!"}
	);

    return $users;
}

sub last_comment_by_spec_room {
    my ($self, %p) = @_;

    my $result_set = $self->query(qq|
        SELECT
			sc.type srlc_type,
			sc.post_date srlc_post_date,
            CASE DATE_FORMAT(sc.post_date, '%Y%m%d') 
				WHEN DATE_FORMAT(NOW(), '%Y%m%d') THEN DATE_FORMAT(sc.post_date, '%H:%i')
				ELSE DATE_FORMAT(sc.post_date, '%Y-%m-%d %H:%i') 
			END srlc_post_date,
			IFNULL(u.name, sc.alias) srlc_alias
        FROM (
			SELECT MAX(id) sc_id, type
			FROM spec_comments FORCE INDEX(i_spec_comments__type)
			GROUP BY type
		) sc_select
		JOIN spec_comments sc ON sc_select.sc_id = sc.id
		LEFT JOIN users u ON u.id = sc.user_id
		|,
        [],
		{error_msg => "Самые буйные психи ускакали прочь!"}
	);
	
	my %list = ();
	for (my $i = 0; $i < scalar @$result_set; $i++) {
        $list{'srlc_'.$result_set->[$i]->{srlc_type}.'_post_date'} = $result_set->[$i]->{srlc_post_date};
        $list{'srlc_'.$result_set->[$i]->{srlc_type}.'_alias'} = $result_set->[$i]->{srlc_alias};
    }

    return %list;
}

sub last_comment {
    my ($self, %p) = @_;

    my $result_set = $self->query(qq|
        SELECT
            CASE DATE_FORMAT(cm.post_date, '%Y%m%d') 
				WHEN DATE_FORMAT(NOW(), '%Y%m%d') THEN DATE_FORMAT(cm.post_date, '%H:%i')
				ELSE DATE_FORMAT(cm.post_date, '%Y-%m-%d %H:%i') 
			END lcm_post_date,
            IFNULL(u.name, cm.alias) lcm_alias
        FROM comments cm
        LEFT JOIN users u ON u.id = cm.user_id
		ORDER BY cm.post_date DESC
		LIMIT 1
		|,
        [],
		{error_msg => "О последнем диспуте Психуюшка умалчивает!"}
	);

    return %{$result_set->[0]};
}

sub last_gb_comment {
    my ($self, %p) = @_;

    my $result_set = $self->query(qq|
        SELECT
            CASE DATE_FORMAT(gb.post_date, '%Y%m%d') 
				WHEN DATE_FORMAT(NOW(), '%Y%m%d') THEN DATE_FORMAT(gb.post_date, '%H:%i')
				ELSE DATE_FORMAT(gb.post_date, '%Y-%m-%d %H:%i') 
			END lgbc_post_date,
            IFNULL(u.name, gb.alias) lgbc_alias
        FROM gb
        LEFT JOIN users u ON u.id = gb.user_id
        ORDER BY gb.post_date DESC
        LIMIT 1
		|,
		[],
        {error_msg => "В палате номир шесть - ТИХО....!"}
	);

    return %{$result_set->[0]};
}

sub last_comment_for_me {
    my ($self, %p) = @_;

	return undef if $self->is_annonimus;

    my $result_set = $self->query(qq|
        SELECT
            cm.post_date lcfm_post_date,
            IFNULL(u.name, cm.alias) lcfm_alias
        FROM comments cm
		JOIN creo c ON c.id = cm.creo_id
        LEFT JOIN users u ON u.id = cm.user_id
        WHERE c.user_id = ?
		ORDER BY cm.post_date DESC
		LIMIT 1
		|,
		[$self->user_id],
        {error_msg => "Сплетни про вас не найдены!"}
	);

    if (scalar @$result_set > 0 and defined $result_set->[0]->{lcfm_post_date}) {
		return %{$result_set->[0]};
	}
	else {
		return (1 => 1);
	}
}


sub users_by_rank {
    my ($self, %p) = @_;
    my $users = $self->query(qq|
		SELECT 
			u.id ru_id, 
			u.name ru_name,
			ug.group_id ru_group,
			us.creo_post ru_creos_cnt,
			us.votes_in ru_votes_cnt,
			IFNULL(us.votes_in_rank, 100) ru_rank
		FROM users u 
		JOIN user_stats us ON us.user_id = u.id
		LEFT JOIN user_group ug ON ug.user_id = u.id
		WHERE (
			us.comments_out > 0 
			OR 
			us.spec_comments > 0 
			OR 
			us.gb_comments > 0 
			OR
			us.creo_post > 0
		)
		ORDER BY ru_name
		|,
        [],
		{error_msg => "Амбулаторное отделение сгорело!"}
	);
    
	my %list = ();
    for my $u (@$users) {
		if ($u->{ru_id} eq Psy::Auth::MAIN_DOCTOR_ID) {
			$u->{ru_rank} = 'x' 
		}
		elsif (defined $u->{ru_group} and $u->{ru_group} eq Psy::Group::PLAGIARIST) {
			$u->{ru_rank} = '5';
			$u->{ru_plagiarist} = 1;
		}
		elsif ($u->{ru_creos_cnt} eq 0) {
			$u->{ru_rank} = '100';
		}
		elsif ($u->{ru_creos_cnt} < 3 || $u->{ru_votes_cnt} < 15) {
			$u->{ru_rank} = '0';
		}
        push(@{$list{'rank_'.$u->{ru_rank}}}, $u);
    }
    return %list; 
}

sub new_users {
    my ($self, %p) = @_;

    my $users = $self->query(qq|
        SELECT 
            u.id nu_id, 
            u.name nu_name,
			DATE_FORMAT(u.reg_date, '%Y-%m-%d') nu_reg_date
        FROM users u
		JOIN user_stats us ON us.user_id = u.id
		LEFT JOIN user_group ug ON ug.user_id = u.id
		WHERE IFNULL(ug.group_id, 0) <> ?
		AND (
			us.comments_out > 0 
			OR 
			us.spec_comments > 0 
			OR 
			us.gb_comments > 0 
			OR
			us.creo_post > 0
		)
		ORDER BY u.reg_date DESC
		LIMIT ?
		|,
		[Psy::Group::PLAGIARIST, $p{count} || 3],
        {error_msg => "История поступления больных уничтожена!"}
	);
    
	return $users;
}

sub most_active_users {
    my ($self, %p) = @_;

    my $users = $self->query(qq|
        SELECT 
            u.id au_id, 
            u.name au_name,
			cu.cnt cu_cnt,
			cmu.cnt cmu_cnt,
			scmu.cnt scmu_cnt,
			gbu.cnt gbu_cnt,
			vu.cnt vu_cnt,
            
				IFNULL(cu.cnt, 0) * 8 
				+ IFNULL(cmu.cnt, 0) * 3 
				+ IFNULL(scmu.cnt, 0) * 2
				+ IFNULL(gbu.cnt, 0) * 2
				+ IFNULL(vu.cnt, 0)
			 au_rank
        FROM users u
		LEFT JOIN user_group ug ON ug.user_id = u.id
		LEFT JOIN (
				SELECT user_id, COUNT(id) cnt
				FROM creo
				WHERE post_date >= NOW() - INTERVAL 1 MONTH
				AND type IN (0, 1)
				GROUP BY user_id
		) cu ON cu.user_id = u.id
		LEFT JOIN (
				SELECT user_id, COUNT(id) cnt
				FROM comments
				WHERE post_date >= NOW() - INTERVAL 1 MONTH
				GROUP BY user_id
		) cmu ON cmu.user_id = u.id
		LEFT JOIN (
				SELECT user_id, COUNT(id) cnt
				FROM spec_comments
				WHERE post_date >= NOW() - INTERVAL 1 MONTH
				GROUP BY user_id
		) scmu ON scmu.user_id = u.id
		LEFT JOIN (
				SELECT user_id, COUNT(id) cnt
				FROM gb 
				WHERE post_date >= NOW() - INTERVAL 1 MONTH
				GROUP BY user_id
		) gbu ON gbu.user_id = u.id
		LEFT JOIN (
				SELECT user_id, COUNT(id) cnt
				FROM vote 
				WHERE date >= NOW() - INTERVAL 1 MONTH
				GROUP BY user_id
		) vu ON vu.user_id = u.id

		WHERE u.id <> 4
		AND IFNULL(ug.group_id, 0) <> ?
		ORDER BY au_rank DESC
		LIMIT ?
		|,
		[Psy::Group::PLAGIARIST, $p{limit} || 15],
        {error_msg => "Активность пациэнтов не поддается анализу!"}
	);

    return $users;
}

sub top_users_by_creos_count {
    my ($self, %p) = @_;

    my $users = $self->query(qq|
        SELECT 
            u.id ccu_id, 
            u.name ccu_name,
			us.creo_post ccu_cnt
        FROM users u 
		JOIN user_stats us ON us.user_id = u.id
		LEFT JOIN user_group ug ON ug.user_id = u.id
		WHERE IFNULL(ug.group_id, 0) <> ?
		ORDER BY ccu_cnt DESC
		LIMIT ?
		|,
		[Psy::Group::PLAGIARIST, $p{limit} || 15],
		{error_msg => "Подсчет анализов не дал должного результата!"}
	);

    return $users;
}

sub ban_total_list {
    my ($self, %p) = @_;

    my $sql = qq|
    SELECT 
		IFNULL(u.name, 'Неизвестный пациэнт') btl_name,
		u.id btl_user_id,
		SUM(UNIX_TIMESTAMP(b.end) - UNIX_TIMESTAMP(b.begin)) btl_time
	FROM 
		ban b 
	LEFT JOIN 
		users u ON u.id = b.user_id
	GROUP BY 
		name
	ORDER BY btl_time DESC 
	|;

    my $sth = $p{psy}->{dbh}->prepare($sql);
    $sth->execute;

    if ($sth->err) {
        ERRORS::html_error("Процедурная в панике!");
    }

    my @list = ();
    while (my $row = $sth->fetchrow_hashref) {
		$row->{btl_time} = short_time($row->{btl_time});
        push(@list, $row);
    }

    $sth->finish;

    return \@list;
}

sub anti_top_votes {
    my ($self, %p) = @_;

    my $result_set = $self->query(qq|
		SELECT 
			c.id vs_creo_id,
			c.title vs_title, 
			u.name vs_alias,
			c.post_date,
			cs.votes vs_cnt
		FROM creo c
		JOIN creo_stats cs ON cs.creo_id = c.id
		JOIN users u ON u.id = c.user_id
		LEFT JOIN user_group ug ON ug.user_id = c.user_id
		
		WHERE c.type = 0
		AND c.id NOT IN ( SELECT creo_id FROM vote WHERE user_id = ? )
		AND c.user_id <> ?
		AND IFNULL(ug.group_id, 0) <> ?
		
		ORDER BY c.post_date DESC
		LIMIT 10
		|,
		[$self->user_id, $self->user_id, Psy::Group::PLAGIARIST],
        {error_msg => "Архив сплетен уничтожен!"}
	);

    return $result_set;
}

sub top_selected_creos {
	my ($self, %p) = @_;

	return $self->query(q|
		SELECT
			c.id sct_creo_id,
			c.title sct_title,
			u.name sct_user_name,
			COUNT(sc.creo_id) sct_cnt
		FROM selected_creo sc
		JOIN creo c ON c.id = sc.creo_id
		JOIN users u ON u.id = c.user_id
		WHERE c.user_id <> sc.user_id
		GROUP BY sc.creo_id
		ORDER BY sct_cnt DESC, u.id, c.title
		LIMIT ?
		|,
		[$p{count} || 10]
	);
}

sub top_creo_views {
	my ($self, %p) = @_;

	return $self->query(q|
		SELECT
			c.id cvt_creo_id,
			c.title cvt_title,
			u.name cvt_user_name,
			cs.views cvt_cnt
		FROM creo_stats cs
		JOIN creo c ON c.id = cs.creo_id
		JOIN users u ON u.id = c.user_id
		ORDER BY cvt_cnt DESC
		LIMIT ?
		|,
		[$p{count} || 10]
	);
}

1;
