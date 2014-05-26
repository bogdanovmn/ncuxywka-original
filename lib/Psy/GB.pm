package Psy::GB;

use strict;
use warnings;
use utf8;

use Psy::Text;
use Psy::Text::Generator;
use Psy::Statistic::User;

use base "Psy::DB";


sub enter {
	my ($class, %p) = @_;

	return Psy::DB::connect($class);
}
#
# Get guest book messages total
#
sub comments_total {
    my ($self, %p) = @_;

    my $result = $self->query(qq| SELECT COUNT(*) c FROM gb |);

    return $result->[0]->{c};
}
#
# Add comment
#
sub post_comment {
	my ($self, %p) = @_;
	
	return 'dub' if $self->last_msg eq $p{msg};
	
	$self->query(qq|
		INSERT INTO gb 
		SET user_id = ?,
			msg =  ?,
			alias = ?,
			ip = ?
		|,
		[$p{user_id}, $p{msg}, $p{alias}, $self->{ip}],
		{error_msg => "Психи слова не дают сказать!"}
	);

	Psy::Statistic::User->constructor(user_id => $p{user_id})->increment(Psy::Statistic::User::V_GB_COMMENTS);
}
#
# Load guest book messages 
#
sub load_comments {
	my ($self, %p) = @_;
	
	my $page = $p{page} || 1;
	my $offset = ($page - 1) * Psy::OP_RECS_PER_PAGE;

	my $comments = $self->query(qq|
		SELECT 
			gb.id cm_id,
			gb.id cm_inner_id,
			gb.msg cm_msg,
			DATE_FORMAT(gb.post_date, '%Y-%m-%d %H:%i') cm_post_date,
			gb.alias cm_alias,
			u.id cm_user_id,
			u.name cm_user_name,
			g.name cm_group_name,
			g.comment_phrase cm_comment_phrase,
			g.type cm_group_type,
			CASE WHEN g.id = ? THEN 1 ELSE NULL END cm_for_creo
		FROM gb
		LEFT JOIN users u ON gb.user_id = u.id
		LEFT JOIN user_group ug ON ug.user_id = u.id
		LEFT JOIN `group` g ON g.id = ug.group_id AND g.type > 0
		
		ORDER BY gb.post_date DESC
		
		LIMIT ?, ?
		|,
		[Psy::Group::PLAGIARIST, $offset, Psy::OP_RECS_PER_PAGE]
	);

	my @gb = ();
	for (my $i = 0; $i < @$comments; $i++) {
		$comments->[$i]->{cm_reply} = 1 if $p{reply};
		
		$comments->[$i]->{cm_msg} = Psy::Text::convert_to_html($comments->[$i]->{cm_msg});
		$comments->[$i]->{cm_msg} = Psy::Text::fuck_filter($comments->[$i]->{cm_msg});
		$comments->[$i]->{cm_msg} = Psy::Text::activate_inside_links($comments->[$i]->{cm_msg});
#
		$comments->[$i]->{cm_alias} = $comments->[$i]->{cm_user_name} if $comments->[$i]->{cm_user_name};
		$comments->[$i]->{cm_alias} = Psy::OP_ANONIM_NAME unless $comments->[$i]->{cm_alias};

		$comments->[$i]->{cm_major} = 1 if defined $comments->[$i]->{cm_user_id} and $comments->[$i]->{cm_user_id} eq Psy::Auth::MAIN_DOCTOR_ID;
	}
	return $comments;
}
#
# Load last guest book message
#
sub last_msg {
    my ($self, %p) = @_;

    my $result = $self->query(qq| SELECT msg FROM gb ORDER BY id DESC LIMIT 1 |);

    return $result->[0]->{msg};
}
#
# End
#
1;
