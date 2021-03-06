package Psy::Creo;

use strict;
use warnings;
use utf8;

use Psy::Text;
use Psy::Text::Comments;
use Psy::Auth;
use Psy::Statistic::User;
use Psy::Statistic::Creo;
#
# Creo types
#
use constant CT_CREO       => 0;
use constant CT_QUARANTINE => 1;
use constant CT_DELETE     => 2;
use constant CT_ALEX_JILE  => 3;
use constant CT_BLACK_COPY => 4;
use constant CT_PLAGIARISM => 5;

use base "Psy::DB";


sub constructor {
	my ($class, %p) = @_;

	return $class->SUPER::connect(%p);
}

sub new {
	my ($class, %p) = @_;

	my $self = Psy::DB::connect($class, %p);
	$self->{title} = $p{title};
	$self->{body} = $p{body};
	$self->{ip} = $p{ip};
	$self->{author_user_id} = $p{user_id};
	$self->{type} = $p{black_copy} ? CT_BLACK_COPY : CT_CREO;

	return $self;
}

sub choose {
	my ($class, $id, %p) = @_;

	my $self = Psy::DB::connect($class);
	$self->{id} = $id;
	$self->{black_copy} = $p{black_copy} || 0;
	$self->{user_id} = $p{user_id} || 0;
	$self->{ip} = $p{ip};
	
	return $self;
}
#
# Add creo 
#
sub save {
	my ($self, %p) = @_;

	$self->{id} = $self->query(qq|
		INSERT INTO creo 
		SET	user_id = ?,
			title = ?,
			body = ?,
			ip = ?,
			edit_date = NOW(),
			type = ?
		|,
		[$self->{author_user_id}, $self->{title}, $self->{body}, $self->{ip}, $self->{type}],
		{
			return_last_id => 1,
			error_msg      => "Анализы сдавать - это хорошо, но зайдите попойже: перерыв на обед!"
		}
	);
	Psy::Statistic::Creo->constructor(creo_id => $self->{id})->add_object;
	Psy::Statistic::User->constructor(user_id => $self->{author_user_id})->increment(Psy::Statistic::User::V_CREO_POST);
	
	$self->update_search_index;
}
#
# Add creo to search index 
#
sub update_search_index {
	my ($self, %p) = @_;

	$self->query(qq|
		REPLACE INTO creo_text 
		SET	creo_id = ?,
			title   = ?,
			body    = ?
		|,
		[ $self->{id}, $self->{title}, $self->{body} ],
	);
}
#
# Add creo to user's selected
#
sub select_by_user {
    my ($self, %p) = @_;

	$self->query(qq|
        INSERT INTO selected_creo
        SET user_id = ?,
			creo_id = ?
		|,
		[$p{user_id}, $self->{id}],
        {error_msg => "Ваши карманы заболели дырками. Класть туда бесполезно!"}
	);

	return 1;
}
#
# Del creo from user's selected
#
sub deselect_by_user {
    my ($self, %p) = @_;

    $self->query(qq|
        DELETE FROM selected_creo
        WHERE user_id = ?
        AND creo_id = ?
		|,
		[$p{user_id}, $self->{id}],
        {error_msg => "Ваши карманы заболели дырками - там пусто!"}
	);

    return 1;
}
#
# Check user select by creo_id
#
sub already_selected_by_user {
    my ($self, %p) = @_;

    my $result = $self->query(qq|
        SELECT COUNT(id) cnt 
		FROM selected_creo
        WHERE user_id = ?
        AND creo_id = ?
		|,
		[$p{user_id}, $self->{id}],
        {error_msg => "В ваших карманах ветает неизвестность!"}
	);

    return $result->[0]->{cnt};
}
#
# Check user select by creo_id
#
sub selections_info {
    my ($self, %p) = @_;

    my $result = $self->query(qq|
        SELECT sc.user_id si_user_id, u.name si_user_name 
		FROM selected_creo sc
		JOIN users u ON u.id = sc.user_id
		JOIN creo c ON c.id = sc.creo_id
        WHERE sc.creo_id = ?
		AND sc.user_id <> c.user_id
		|,
		[$self->{id}],
        {error_msg => "В ваших карманах ветает неизвестность!"}
	);

    return $result;
}

#
# Edit creo 
#
sub update_type {
    my ($self, %p) = @_;

	return $self->error("Неверный тип анализа") unless $p{type} =~ /^\d+$/;

    $self->query(qq|
        UPDATE creo 
        SET type = ?,
            edit_date = NOW()
		WHERE id = ?
		|,
		[$p{type}, $self->{id}],
        {error_msg => "Ошибка концелярии!"}
	);
}
#
#
#
sub update {
    my ($self, %p) = @_;
	
	my @fields;
	my @values;
	my $text_change = 0;

	if ($p{title}) {
		push @fields, 'title = ?';
		push @values, $p{title};
		
		$self->{title} = $p{title};
		$text_change   = 1;
	}
	
	if ($p{body}) {
		push @fields, 'body = ?';
		push @values, $p{body};
		
		$self->{body} = $p{body};
		$text_change  = 1;
	}
	
	if (exists $p{type}) {
		push @fields, 'type = ?';
		push @values, $p{type};
	}
	
	if ($p{post_date}) {
		push @fields, 'post_date = NOW()';
	}

	return undef if not @fields;

	my $fields_string = join ", ", @fields;
	push @values, $self->{id};
    
	$self->query(qq|
        UPDATE creo 
        SET $fields_string,
            edit_date = NOW()
		WHERE id = ?
		|,
		\@values,
        {error_msg => "Ошибка концелярии!"}
	);

	if ($text_change) {
		$self->update_search_index;
	}
}
#
# Get creo
#
sub load {
	my ($self, %p) = @_;

	my $with_comments = exists $p{with_comments} ? $p{with_comments} : 1;
	my $for_edit = $p{for_edit} || 0;
	
	my $creo = $self->query(qq| 
		SELECT 
			u.name c_alias,
			c.user_id c_user_id,
			DATE_FORMAT(c.post_date, '%Y-%m-%d') c_post_date,
			c.title c_title,
			c.body c_body,
			c.type c_type,
			c.neofuturism c_neofuturism,
			c.ip c_ip,
			c.id c_id
		FROM creo c
		JOIN users u ON u.id = c.user_id
		WHERE c.id = ? 
		|,
		[$self->{id}],
		{error_msg => "Анализы нечитабельны!", only_first_row => 1}
	);
	
	if ($creo) {
		return undef if ($self->{black_copy} and $creo->{c_type} ne CT_BLACK_COPY);
		return undef if (not $self->{black_copy} and $creo->{c_type} eq CT_BLACK_COPY);
		return undef if ($self->{user_id} ne 0 and $self->{user_id} ne $creo->{c_user_id});

		$creo->{c_body} = Psy::Text::convert_to_html($creo->{c_body}) unless $for_edit;
		
		if ($with_comments) {
			return ($creo, $self->comments(reply => 1));
		}
		else {
			return $creo;
		}
	}
	else {
		return undef;
	}
}
#
# Get creo info
#
sub load_headers {
	my ($self, %p) = @_;

	my $creo_result_set = $self->query(qq| 
		SELECT 
			u.name c_alias,
			c.user_id c_user_id,
			DATE_FORMAT(c.post_date, '%Y-%m-%d') c_post_date,
			c.title c_title,
			c.type c_type,
			c.ip c_ip,
			c.id c_id
		FROM creo c
		JOIN users u ON u.id = c.user_id
		WHERE c.id = ? 
		|,
		[$self->{id}],
		{error_msg => "Анализы нечитабельны!"}
	);

	return scalar @$creo_result_set ? $creo_result_set->[0] : undef;
}
#
# Get creo user_id
#
sub author_id {
	my ($self) = @_;

	my $result = $self->query(q| 
		SELECT user_id
		FROM   creo
		WHERE  id = ? 
		|,
		[$self->{id}],
	);

	return scalar @$result ? $result->[0]->{user_id} : undef;
}

#
# Load creo's comments
#
sub comments {
	my ($self, %p) = @_;

	$p{cut} ||= 0;
	
	my $comments_result_set = $self->query(qq| 
		SELECT
			1                cm_for_creo,
			c.id             cm_id,
			c.alias          cm_alias,
			c.user_id        cm_user_id,
			u.name           cm_user_name,
			c.msg            cm_msg,
			g.name           cm_group_name,
			g.comment_phrase cm_comment_phrase,
			g.type           cm_group_type,
			DATE_FORMAT(c.post_date, '%Y-%m-%d %H:%i') cm_post_date
		FROM comments c
		LEFT JOIN users u ON u.id = c.user_id
		LEFT JOIN user_group ug ON ug.user_id = u.id
		LEFT JOIN `group` g ON g.id = ug.group_id AND g.type > 0
		WHERE creo_id = ? 
		ORDER BY post_date 
		|,
		[$self->{id}],
		{error_msg => "Диагнозы нечитабельны!"}
	);

	my @comments = ();
	my $i = 1;
	for my $row (@$comments_result_set) {
		#$row->{cm_msg} = Psy::Text::Shuffle::comment($row->{cm_msg}, words_power => 50, chars_power => 20);
		$row->{cm_msg} = Psy::Text::convert_to_html($row->{cm_msg});
		$row->{cm_msg} = Psy::Text::Comments::activate_inside_links($row->{cm_msg});

		$row->{cm_alias} = $row->{cm_user_name} if $row->{cm_user_name};
		$row->{cm_reply} = 1 if $p{reply};
		$row->{cm_major} = 1 if $row->{cm_user_id} and $row->{cm_user_id} eq Psy::Auth::MAIN_DOCTOR_ID;
		$row->{cm_inner_id} = $i;
		$i++;
		push(@comments, $row);
	}
	return \@comments;
}
#
# Add creo comment
#
sub post_comment {
    my ($self, %p) = @_;
  
	my $post_date = "NOW()";
	my $post_date_delta = $p{post_date_delta} || 0;
	if ($post_date_delta) {
		$post_date .= " - INTERVAL $post_date_delta SECOND"
	}

	return 'dub' if $self->last_msg eq $p{msg};

	$p{alias} = $p{user_id} eq Psy::Auth::ANNONIMUS_ID ? Psy::Text::Generator::modify_alias($p{alias}) : "";
	
	$self->query(qq|
        INSERT INTO comments
        SET
			creo_id = ?,
            user_id = ?,
            msg =  ?,
            alias = ?,
            ip = ?,
			post_date = $post_date
		|,
		[$self->{id}, $p{user_id} || undef, $p{msg}, $p{alias}, $p{ip}],
		{error_msg => "Психи не дают диагноз высказать!"}
	);

	my $author_user_id = $self->load_headers->{c_user_id};
	
	if ($p{user_id}) {
		my $user_stats = Psy::Statistic::User->constructor(user_id => $p{user_id});
		$user_stats->increment(Psy::Statistic::User::V_COMMENTS_OUT);

		if ($author_user_id eq $p{user_id}) {
			$user_stats->increment(Psy::Statistic::User::V_COMMENTS_IN_BY_SELF);
		}
	}

	Psy::Statistic::User->constructor(user_id => $author_user_id)->increment(Psy::Statistic::User::V_COMMENTS_IN);
	Psy::Statistic::Creo->constructor(creo_id => $self->{id})->increment(Psy::Statistic::Creo::V_COMMENTS);
}
#
# Get creo votes
#
sub votes {
	my ($self, %p) = @_;

	my $votes = $self->query(
		qq| SELECT * FROM vote WHERE creo_id = ? |,
		[$self->{id}],
		{error_msg => "Голоса затерялись в унитазе"}
	);

	return $votes;
}
#
# Load last message
#
sub last_msg {
    my ($self, %p) = @_;

    return $self->query(qq|
        SELECT msg
        FROM comments
		WHERE creo_id = ?
        ORDER BY id DESC
        LIMIT 1
		|,
		[$self->{id}],
		{only_field => 'msg'}
	);
}
#
# Add the creo to neofuturism 
#
sub add_to_neofuturism {
    my ($self, %p) = @_;

	$self->query(
		q| UPDATE creo SET neofuturism = 1 WHERE id = ? |,
		[$self->{id}]
	);
}
#
# Remove the creo from neofuturism 
#
sub remove_from_neofuturism {
    my ($self, %p) = @_;

	$self->query(
		q| UPDATE creo SET neofuturism = 0 WHERE id = ? |,
		[$self->{id}]
	);
}

sub list_by_period {
    my ($self, %p) = @_;

	$p{period} ||= -1;
	$p{type}   ||= [0];
	$p{users_to_exclude} ||= [];
	
	
	return [
		map {
			$_->{cl_votes}    = $_->{cl_creo_stat}->{votes};
			$_->{cl_comments} = $_->{cl_creo_stat}->{comments};
			delete $_->{cl_creo_stat};
			$_;
		}
		@{
			$self->schema_select(
				'Creo',
				{
					type => $p{type},

					$p{period} > 2009
						? ( post_year => $p{period} )
						: $p{period} > 0
							? ( post_date => { '>=' => \["NOW() - INTERVAL ? DAY", $p{period}] } )
							: (),
						
					$p{neofuturism} 
						? ( neofuturism => 1 ) 
						: (),
					
					scalar @{$p{users_to_exclude}}
						? ( user_id => { -not_in => $p{users_to_exclude} } )
						: ()
				},
				{
					join     => 'creo_stat',
					order_by => { -desc => 'post_date' }
				},
				[qw/ id type user_id title post_date creo_stat.comments creo_stat.votes /],
				'cl_',
				{
					date_field => 'post_date',
					user_id    => 'alias'
				}
			)
		}
	];
}


1;
