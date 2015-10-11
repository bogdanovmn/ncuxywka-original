package Psy;

use strict;
use warnings;
use utf8;

use Utils;
use Psy::Skin;
use Date;
use Psy::Group;
use Psy::Text;
use Psy::Text::Comments;
use Psy::Text::Generator;
use Psy::PersonalMessages;
use Psy::Creo;
use Psy::Auditor;
use Psy::Statistic::User;
use Psy::Statistic::Creo;
use Cache;
use Format::LongNumber;
use FindBin;
use JSON::XS;
#
# Votes rank titles
#
my %VOTES_RANK_TITLES = (
	1 => 'Брат/Сестра по разуму',
	2 => 'Шизофрения',
	3 => 'паФрейду',
	4 => 'Параноя',
	5 => 'Пациэнту требуется лоботомия!'
);
#
# Constants
#
# Log file 
#
use constant LOG_FILE => $FindBin::Bin. '/../logs/psy.log';

#
# Text modification params
#
use constant TM_PREVIEW_LINES    => 8;
use constant TM_PREVIEW_MAX_SIZE => 528; # 66*8
#
# Output params
#
use constant OP_RECS_PER_PAGE                 => 19;
use constant OP_RECS_PER_PAGE_FOR_PETR_MOBILE => 5;
use constant OP_ANONIM_NAME                   => 'Я буйный, в рот мне клизму';
#
# Moderator's scope
#
use constant MODERATOR_SCOPE_CREO_EDIT	=> "creo_edit";
use constant MODERATOR_SCOPE_USER_BAN	=> "user_ban";
use constant MODERATOR_SCOPE_QUARANTINE => "quarantine";
use constant MODERATOR_SCOPE_CREO_DELETE=> "creo_delete";
use constant MODERATOR_SCOPE_PLAGIARISM => "plagiarism";

use base "Psy::Auth", "Psy::Statistic", "Psy::Admin::Info", "Psy::Search", "Psy::Online";

sub enter {
	my ($class, %p) = @_;

	$p{check_ban} = not defined $p{check_ban} ? 1 : 0;

	my $self = Psy::Auth::info($class, %p);

	$self->{personal_messages} = Psy::PersonalMessages->constructor(user_id => $self->{user_data}->{user_id});
	$self->{auditor}           = Psy::Auditor->constructor(user_id => $self->{user_data}->{user_id});
    
	return $self;
}

sub common_info {
	my ($self, %p) = @_;
	
	unless ($self->is_annonimus) {
		$self->{user_data}->{online} = $self->cache->try_get(
			'online',
			sub { $self->online_list },
			Cache::FRESH_TIME_MINUTE
		);
	}

	$self->{user_data}->{is_plagiarist} = $self->is_plagiarist;

	my %common_params = (
		$self->last_gb_comment(),
		$self->last_comment(),
		$self->last_comment_by_spec_room(),
		#Psy::Skin::get_skin($p{skin} || "feb14"),
		Psy::Skin::get_skin($p{skin} || "original"),
		mad_phrase => Psy::Text::Generator::attention_phrase(),
		%{$self->{user_data}}
	);
	
	if ($self->success_in) {
		my %moderator_scopes_template_params = ();
		for my $key (keys %{$self->auditor->load_moderator_scopes}) {
			$moderator_scopes_template_params{"ms_". $key} = 1;
		}
		return { 
			new_messages => $self->pm->news_count,
			%common_params,
			%moderator_scopes_template_params,
			$self->last_comment_for_me
		};
	}
	else {
		return \%common_params
	}
}
#
# Load user(s)
#
sub load_users {
	my ($self, %p) = @_;

	my $order_by_date = $p{order_by_date} ? "u.reg_date DESC," : "";
	my $full_info = $p{full_info} ? 'u.about u_about, u.loves u_loves, u.hates u_hates, u.pass_hash u_pass_hash,' : '';
	
	my $users = $self->query(qq|
		SELECT
			$full_info
			u.id u_id,
			u.ip u_ip,
			u.city u_city,
			u.email u_email,
			u.name u_name,
			DATE_FORMAT(u.reg_date, '%Y-%m-%d') u_reg_date,
			DATE_FORMAT(u.edit_date, '%Y-%m-%d') u_edit_date,
			u.type u_type,
			UPPER(SUBSTRING(u.name, 1, 1)) u_letter,
			ug.group_id u_group,
			IFNULL(ug.group_id, 0) = 4 u_plagiarist
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
		ORDER BY $order_by_date u.name
		|,
		[],
        {error_msg => "Регистратура временно не работает!"}
	);
	
	if ($p{id} and defined $users->[0]) { 
		$users->[0]->{u_from_comments_count} = $self->get_comments_total(from => $p{id});
		$users->[0]->{u_for_comments_count} = $self->get_comments_total(for => $p{id});
		return $users->[0];
	}
	elsif (defined $users->[0]) {
		return $users;
	}
}
#
# Load creo's comments
#
sub comments {
    my ($self, %p) = @_;

	if ((defined $p{for} and $p{for} =~ /\D/) or (defined $p{from} and $p{from} =~ /\D/)) {
		error("Вы явно заблудились, голубчик...");	
	}

	$p{cut} ||= 0;
	my $page = $p{page} || 1;
	my $offset = ($page - 1) * OP_RECS_PER_PAGE;	

	my $where = '';
	my @params;
	
	if ($p{from}) {
		$where .= 'AND cm.user_id = ? ';
		push @params, $p{from};
	}
	if ($p{for}) {
		$where .= 'AND cr.user_id = ? ';
		push @params, $p{for};
	}
	
	if ($p{creo_types}) {
		$where .= 'AND cr.type IN (' . join(', ', @{$p{creo_types}}).") ";
	}

    my $comment_ids = $self->query(qq| 
        SELECT cm.id
        FROM   comments cm
		JOIN   creo cr ON cm.creo_id = cr.id
		WHERE 1 = 1
		$where
        ORDER BY cm.post_date DESC 
		LIMIT ?, ?
		|,
		[ @params, $offset, OP_RECS_PER_PAGE ],
		{ list_field => 'id' }
    );

	return [] unless @$comment_ids;

	my $where_comments = sprintf 'WHERE cm.id IN (%s)', join(',', @$comment_ids);
	my $comments = $self->query(qq| 
        SELECT 
            cm.id lc_id,
            cm.alias lc_alias,
            cm.msg lc_msg,
            DATE_FORMAT(cm.post_date, '%Y-%m-%d %H:%i') lc_post_date,
			cm.user_id lc_user_id,
			
			cr.id      lc_creo_id,
			cr.title   lc_creo_title,
			cr.type    lc_creo_type,
			cr.user_id lc_creo_user_id,
			CASE cr.type WHEN 1 THEN 1 ELSE 0 END lc_quarantine,
			g.name lc_group_name,
			g.comment_phrase lc_comment_phrase,
			g.type lc_group_type
        FROM comments cm
		JOIN creo cr ON cm.creo_id = cr.id
		LEFT JOIN users u ON u.id = cm.user_id
		LEFT JOIN user_group ug ON ug.user_id = cm.user_id
		LEFT JOIN `group` g ON g.id = ug.group_id AND g.type > 0
		$where_comments
	|);

    foreach my $row (@$comments) {
		my $text_original_length = length $row->{lc_msg};
		
		#$row->{lc_msg} = Psy::Text::Shuffle::comment($row->{lc_msg}, words_power => 40, chars_power => 10);
		$row->{lc_msg} = Psy::Text::convert_to_html($row->{lc_msg});
		$row->{lc_msg} = Psy::Text::cut_top_lines($row->{lc_msg}, TM_PREVIEW_LINES) if $p{cut} eq 1;
		$row->{lc_msg} = Psy::Text::cut_first_chars($row->{lc_msg}, TM_PREVIEW_MAX_SIZE) if $p{cut} eq 1;
		$row->{lc_msg} = Psy::Text::Comments::activate_inside_links($row->{lc_msg});
        	
		$row->{lc_cuted} = 1 if $text_original_length > 10 + length $row->{lc_msg};
		
		$row->{lc_alias} = OP_ANONIM_NAME unless $row->{lc_alias};
		
		$row->{lc_major} = 1 if $row->{lc_user_id} and $row->{lc_user_id} eq Psy::Auth::MAIN_DOCTOR_ID;

		$row->{lc_creo_alias} = $self->get_user_name_by_id($row->{lc_creo_user_id});
		$row->{lc_user_name}  = $self->get_user_name_by_id($row->{lc_user_id});
    }

	return [ sort { $b->{lc_post_date} cmp $a->{lc_post_date} } @$comments ];
}

sub black_copy_creo_list {
	my ($self, %p) = @_;

	my $list = $self->query(qq|
		SELECT c.id bccl_id, c.title bccl_title
		FROM creo c
		WHERE c.type = ?
		AND c.user_id = ?
		ORDER BY c.post_date 
		|,
		[Psy::Creo::CT_BLACK_COPY, $self->user_id],
		{error_msg => "Черновики не найдены..."}
	);
	return $list;
}

#
# Get creo comment messages total
#
sub get_comments_total {
    my ($self, %p) = @_;

	my $where = '';
	my @params = ();
	
	if ($p{for} and $p{from}) {
		$where = 'AND cm.user_id = ? AND cr.user_id = ?';
		push(@params, $p{from});
		push(@params, $p{for});
	}
	elsif ($p{from}) {
		$where = 'AND cm.user_id = ?';
		push(@params, $p{from});
	}
	elsif($p{for}) {
		$where = 'AND cr.user_id = ?';
		push(@params, $p{for});
	}

	my $result_set = $self->query(qq| 
		SELECT COUNT(1) c 
		FROM comments cm
		JOIN creo cr ON cr.id = cm.creo_id
		WHERE cr.type IN (0, 1) 
		$where
		|,
		[@params]
	);
	
    return $result_set->[0]->{c};
}
#
# Update last post time for current session
#
sub update_post_time {
	my $self = shift;

	$self->{session}("last_post_time", time);
}
#
# Get last post time for current session
#
sub get_post_interval {
	my $self = shift;
	
	return time - ($self->{session}("last_post_time") || 0);
}
#
# Check for bot posting
#
sub bot_detected {
	my ($self, $msg, $alias) = @_;

	$alias ||= '';

	my $check_result = 0;

	$check_result = 1 if ($msg =~/^\s*$/);

	if ($self->is_annonimus) {
		$check_result = 1 if $msg =~ /(http:\/\/)|(<a href=)|(\[url=)|(\[link=)/i;
		#$check_result = 1 if !(
		#	(($alias eq '') || $alias =~ /[0-9а-я]/i) 
		#	&& 
		#	$msg =~ /[0-9а-я]/i
		#);
	}
	$check_result = 1 if ($self->get_post_interval < 11);
	
	$self->logit(
		sprintf("BOT '%s' SAY: %s", $alias ? $alias : "???", $msg)
	) if $check_result;

	return $check_result;
}
#
# Calculate votes and return human like rank title
#
sub votes_rank {
	my ($self, $votes) = @_;

	return undef unless defined $votes->[0];

	my $max = $votes->[0]->{vote};
	my $min = $votes->[0]->{vote};
	my $sum = 0;
	my $count = 0;

	for my $v (@$votes) {
		$count++;
		$sum += $v->{vote};
		$max = $v->{vote} if $v->{vote} > $max;
		$min = $v->{vote} if $v->{vote} < $min;
	}

	return undef if $count < 5;
	
	my $rank = sprintf("%.f", ($sum - $max - $min) / ($count - 2));

	return { value => $rank, title => $VOTES_RANK_TITLES{$rank} };
}
#
# Ban cast =)
#
sub ban {
	my ($self, %p) = @_;

	my $ip = $self->{ip};
	my $user_id = $self->user_id;
	my $duration = $p{duration} =~ /^\d+$/ ? $p{duration} : 1;

	if (defined $p{ip} and not defined $p{user_id}) {
		$ip = $p{ip};
		$user_id = 0;
	}
	elsif (defined $p{user_id} and not defined $p{ip}) {
		$user_id = $p{user_id};
		$ip = "";
	}
	elsif (not defined $p{ip} and not defined $p{user_id}) {
		$ip = $self->{ip};
		$user_id = $self->user_id;
	}
	else {
		$ip = $p{ip};
		$user_id = $p{user_id};
	}
	$self->query(qq| 
		INSERT INTO ban
		SET ip = ?,
			user_id = ?,
			end = NOW() + INTERVAL ? MINUTE
		|,
		[$ip, $user_id, $duration],
		{error_msg => "Запись в процедурную не работает!"}
	);
}
#
# Check for vote power
#
sub check_vote_power {
	my ($self) = @_;
	
	return undef if $self->is_annonimus;

	return 1 if $self->user_id eq Psy::Auth::MAIN_SISTER_ID;
	
	my $user_statistic = $self->query(qq|
		SELECT
			c.cnt creos,
			cm.cnt comments
		FROM
			( SELECT COUNT(id) cnt FROM creo WHERE type = '0' AND user_id = ? ) c,
			( SELECT COUNT(id) cnt FROM comments WHERE user_id = ? ) cm
		|,
		[$self->user_id, $self->user_id],
		{error_msg => "Главврач потерял свои очки и не может проверить подлинность анализа!"}
	);
	
	$user_statistic = $user_statistic->[0];
	
	return (
		(($user_statistic->{creos} > 0) and ($user_statistic->{comments} > 14))
		or
		$user_statistic->{comments} > 50
		or
		$user_statistic->{creos} > 3
	);
}
#
# Vote for creo
#
sub vote {
	my ($self, %p) = @_;

	$self->query(qq| 
		INSERT INTO vote 
		SET user_id = ?,
			creo_id = ?,
			vote = ?,
			ip = ?
		|,
		[$self->user_id, $p{creo_id}, $p{vote_id}, $self->{ip}],
		{error_msg => "Право ты имеешь, али тварь дрожащая?"}
	);

	my $stats = Psy::Statistic::Creo->constructor(creo_id => $p{creo_id});
	$stats->increment(Psy::Statistic::Creo::V_VOTES);
	$stats->set(Psy::Statistic::Creo::V_VOTES_RANK);
	
	$stats = Psy::Statistic::User->constructor(user_id => $self->user_id);
	$stats->increment(Psy::Statistic::User::V_VOTES_OUT);
	$stats->set(Psy::Statistic::User::V_VOTES_OUT_RANK);
	
	my $creo_user_id = $self->query(
		'SELECT user_id FROM creo WHERE id = ?',
		[$p{creo_id}],
		{only_field => 'user_id'}
	);

	$stats = Psy::Statistic::User->constructor(user_id => $creo_user_id);
	$stats->increment(Psy::Statistic::User::V_VOTES_IN);
	$stats->set(Psy::Statistic::User::V_VOTES_IN_RANK);
}
#
# Get day quota for post creo
#
sub day_creo_quota {
    my ($self) = @_;

	return 0 if $self->is_annonimus;
	
	my $sql_result_set = $self->query(qq|
		SELECT
		IFNULL(
			ROUND(
				SUM(CASE WHEN type = 0 THEN 1 ELSE 0 END)
				- 0.5 * SUM(CASE WHEN type = 1 THEN 1 ELSE 0 END)
				- 3 * SUM(CASE WHEN type = 2 THEN 1 ELSE 0 END)
			),
			0
		) + 1 quota
		FROM creo 
		WHERE user_id = ?
		|,
		[$self->user_id],
		{error_msg => "Невозможо определить квоту для пациэнта!"}
	);

    my $row = $sql_result_set->[0];

	$row->{quota} = 10 if $row->{quota} > 10;
	$row->{quota} = -10 if $row->{quota} < -10;
	$row->{quota} = 1 if $row->{quota} == 0;
	
    return $row->{quota};
}
#
# Can post creo? If no then return time for it
#
sub can_creo_add {
    my ($self) = @_;

	my $quota = $self->day_creo_quota;
	
	my $positive_sql = qq|
    SELECT 
		COUNT(id) cnt, 
		MIN(post_date) last_day_post, 
		86400 - (UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(MIN(post_date))) time_to_post
	FROM creo
	WHERE user_id = ?
	AND type <> 4   -- not black copy 
	AND post_date > NOW() - INTERVAL 1 DAY
	ORDER BY post_date DESC
    |;

	my $negative_sql = qq|
    SELECT 
		UNIX_TIMESTAMP(MAX(post_date)) last_post_date
	FROM creo
	WHERE user_id = ?
    |;
	
	my $sql = $quota > 0 ? $positive_sql : $negative_sql;
    my $sql_result_set = $self->query($sql, 
		[$self->{user_data}->{user_id}], 
		{error_msg => "Психиатр отказался принять ваши анализы!"}
	);

	my $row = $sql_result_set->[0];
	my $result = { quota => $quota };
	if ($quota > 0) {
		$result->{can} = $row->{cnt} < $quota;
		$result->{time_to_post} = full_time($row->{time_to_post});
		$result->{type} = "positive";
	}
	else {
		$result->{time_to_post} = -1 * $quota * 86400 - (time - $row->{last_post_date});
		$result->{can} = $result->{time_to_post} <= 0;
		$result->{time_to_post} = full_time($result->{time_to_post});
		$result->{type} = "negative";
	}
	
    return $result;
}
#
# Logger
#
sub logit {
	my ($self, $msg) = @_;
	return;
	if (open(F, '>>'.LOG_FILE)) {
		print F sprintf("[%s] %s uid=%d msg=%s\n", DATE::unix_time_to_ymdhms(), $self->{ip}, $self->{user_data}->{user_id}, $msg);
		close(F);
	}
	else {
		error('Журналы не пишутся!');
	}
}
#
# Return user_id
#
sub user_id {
	my $self = shift;
	return $self->{user_data}->{user_id} || 0;
}
#
# Получаем список забаненых юзеров
#
sub users_to_exclude {
	my ($self, %p) = @_;
	
	my $banned_users = $self->query(qq|
		SELECT ug.user_id
		FROM user_group ug
		WHERE ug.group_id = ?
		|,
		[ Psy::Group::PLAGIARIST ],
		{ list_field => 'user_id' }
	);
	if ($p{self} and $self->user_id) {
		push @$banned_users, $self->user_id;
	}

	return $banned_users;
}
#
# Return plagiarist flag
#
sub is_plagiarist {
	my $self = shift;
	return (exists $self->{user_data}->{user_group_id} and $self->{user_data}->{user_group_id} eq Psy::Group::PLAGIARIST);
}
#
# Is curreent user an annonimus?
#
sub is_annonimus {
	my $self = shift;
	return $self->user_id eq Psy::Auth::ANNONIMUS_ID;
}
#
# Is curreent user a God?
#
sub is_god {
	my $self = shift;
	return exists $self->{user_data}->{god} and $self->{user_data}->{god} eq 1;
}
#
# Is curreent user a God?
#
sub is_moderator_scope {
	my ($self, $scope) = @_;
	return exists $self->{moderator_scopes}->{$scope};
}
#
# Personal messages object
#
sub pm {
	my ($self) = @_;
	return $self->{personal_messages};
}
#
# Cache object
#
sub cache {
	my ($self) = @_;
	return $self->cacher->cache;
}
#
# Auditor object
#
sub auditor {
	my ($self) = @_;
	return $self->{auditor};
}
#
# End
#
1;
