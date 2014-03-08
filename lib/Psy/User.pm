package Psy::User;

use strict;
use warnings;

use Psy::Errors;
use Psy::Creo;
use Psy::Statistic::User;
use Digest::MD5 qw( md5_hex );
#
# Avatars
#
use constant PATH_AVATARS => 'img/avatars';
use constant AVATAR_SIZE => 200; # KB

use base 'Psy::DB';
#
# User object constructor
#
sub choose {
	my ($class, $id) = @_;

	return undef if (not defined $id or $id eq 0);
	
	my $self = Psy::DB::connect($class);
	$self->{id} = $id;
	
	return $self;
}
#
# User object constructor
#
sub new {
	my ($class, %p) = @_;

	my $self = Psy::DB::connect($class);
	$self->{name} = $p{name}; 
	$self->{about} = $p{about};
	$self->{email} = $p{email};
	$self->{loves} = $p{loves};
	$self->{hates} = $p{hates};
	$self->{city} = $p{city};
	$self->{password} = $p{password};
	
	return $self;
}
#
# Get user info
#
sub info {
	my ($self, %p) = @_;
	
	my $info = $self->query(qq|
		SELECT 
			u.id u_id,
			u.name u_name,
			u.email u_email,
			u.about u_about,
			u.loves u_loves,
			u.hates u_hates,
			u.city u_city,
			u.ip u_ip,
			u.reg_date u_reg_date,
			u.edit_date u_edit_date,
			u.pass_hash u_pass_hash,

			g.name u_group_name,
			g.type u_group_type,
			IFNULL(g.id, -1) u_group_id,

			us.votes_in_rank u_votes_in_rank,
			us.votes_out_rank u_votes_out_rank,
			us.comments_in u_comments_in,
			us.comments_out u_comments_out,
			us.comments_in_by_self u_comments_in_by_self
		FROM users u
		JOIN user_stats us ON us.user_id = u.id
		LEFT JOIN user_group ug ON u.id = ug.user_id
		LEFT JOIN `group` g ON g.id = ug.group_id
		WHERE u.id = ? 
		|,
		[$self->{id}]
	);
	
	return scalar @$info > 0 ? $info->[0] : undef;
}

sub save {
    my ($self, %p) = @_;

    $self->query(qq|
        INSERT INTO users 
        SET
            name = ?,
            pass_hash = ?,
            email = ?,
            about = ?,
            loves = ?,
            hates = ?,
            city = ?,
			ip = ?,
            edit_date = NOW()
		|,
		[
			$self->{name}, 
			md5_hex($self->{password}), 
			$self->{email}, 
			$self->{about}, 
			$self->{loves}, 
			$self->{hates}, 
			$self->{city}, 
			$self->{ip}
		],
        {error_msg => "Регистратура - бюракратическая машина! Придется подождать..."}
	);
	Psy::Statistic::User->constructor(user_name => $self->{name})->add_object;

}
#
# Edit user 
#
sub update {
    my ($self, %p) = @_;

	my $change_pass = (defined $p{password} and $p{password});
	my $pass_update = $change_pass ? 'pass_hash = ?,' : '';
    $self->query(qq|
        UPDATE users 
        SET
            $pass_update
            email = ?,
            about = ?,
            loves = ?,
            hates = ?,
            city = ?,
            ip = ?,
            edit_date = NOW()
		WHERE
			id = ?
		|,
		($change_pass) ?
			[md5_hex($p{password}), $p{email}, $p{about}, $p{loves}, $p{hates}, $p{city}, $self->{ip}, $self->{id}] :
			[$p{email}, $p{about}, $p{loves}, $p{hates}, $p{city}, $self->{ip}, $self->{id}],
        {error_msg => "Регистратура - бюракратическая машина! Придется подождать.."}
	);
}
#
# Return avatar file name
#
sub avatar_file_name {
	my ($self) = @_;

	my $file_name = PATH_AVATARS."/".$self->{id};

	if (-r $file_name) {
		return $file_name;
	}
	else {
		return undef;
	}
}

sub creo_list {
    my ($self, %p) = @_;

	my $looker_user_id = $p{looker_user_id} || 0;

	error("Вы не заблудились?") unless defined $p{type};

	my $where_type = sprintf("AND c.type IN (%s)", join(", ", @{$p{type}}));
	
	my $list = $self->query(qq|
        SELECT
            c.id cl_id,
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
        WHERE u.id = ?
        $where_type
        ORDER BY c.post_date DESC
		|,
		[$looker_user_id, $looker_user_id, $looker_user_id, $self->{id}],
		{error_msg => "Список анализов утонул в сливном бочке!"}
	);
    return $list;
}

sub favorites {
    my ($self, %p) = @_;

    my $favors = $self->query(qq|
		SELECT
			u.id uf_uid,
			u.name uf_name , 
			COUNT(cm.id) uf_cnt
		FROM comments cm
		JOIN creo c ON c.id = cm.creo_id
		JOIN users u ON u.id = c.user_id
		WHERE cm.user_id = ? 
		AND c.user_id <> ?
		GROUP BY u.id
		HAVING uf_cnt > 2
		ORDER BY uf_cnt DESC
		|,
		[$self->{id}, $self->{id}],
        {error_msg => "Невозможно узнать про любимчиков пациэнта!"}
	);
    
	for (my $i = 0; $i < scalar @$favors; $i++) {
        $favors->[$i]->{uf_master_id} = $self->{id};
    }

    return $favors;
}

sub votes_out_rank {
    my ($self, %p) = @_;

    return $self->query(qq|
		SELECT IFNULL(ROUND(-0.5 + (SUM(vote) - MAX(vote) - MIN(vote)) / (COUNT(vote) - 2), 0), 0) rank 
		FROM vote
		WHERE user_id = ?
		|,
		[$self->{id}],
        {only_field => 'rank'}
	);
}

sub selected_creo_list {
    my ($self, %p) = @_;

    my $list = $self->query(qq|
        SELECT
            c.id scl_id,
            c.type scl_type,
			CASE c.type WHEN 2 THEN 1 ELSE 0 END scl_quarantine,
            c.user_id scl_user_id,
            u.name scl_alias,
            c.title scl_title,
            DATE_FORMAT(c.post_date, '%Y-%m-%d') scl_post_date,
            cs.comments scl_comments_count,
            cs.votes scl_votes_count,
            cs.votes_rank scl_votes_rank
        FROM selected_creo sc
		JOIN creo c ON c.id = sc.creo_id
		JOIN creo_stats cs ON cs.creo_id = c.id
        JOIN users u ON u.id = c.user_id
        WHERE sc.user_id = ?
        AND c.type IN (0, 1)
        ORDER BY c.post_date DESC
		|,
		[$self->{id}],
        {error_msg => "Список избранных анализов прорпал за углом!"}
	);
	
	for (my $i = 0; $i < scalar @$list; $i++) {
		$list->[$i]->{scl_can_delete} = 1 if ($self->{id} eq $p{looker_user_id});
    }

    return $list;
}

sub set_group {
    my ($self, $group_id) = @_;

    $self->query(qq|
        DELETE FROM user_group 
        WHERE user_id = ?
		|,
		[$self->{id}],
		{ error_msg => "can't delete group" }
	);

    $self->query(qq|
        INSERT INTO user_group 
        SET
            user_id = ?,
            group_id = ?
		|,
		[$self->{id}, $group_id],
		{ error_msg => "can't set group" }
	);
}
#
# Return ban left time
#
sub ban_left_time {
	my ($self, %p) = @_;

	my $ban_end = $self->query(qq| 
		SELECT UNIX_TIMESTAMP(MAX(end)) ban_end
		FROM ban
		WHERE user_id = ?
		AND NOW() BETWEEN begin AND end
		|,
		[$self->{id}], 
		{
			error_msg => "В процедурном кабинете бунт!",
			only_field => "ban_end"
		}
	);
	
	return $ban_end ? $ban_end - time : 0;
}

1;
