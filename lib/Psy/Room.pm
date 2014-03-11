package Psy::Room;

use strict;
use warnings;

use Psy::Errors;
use Psy::Text;
use Psy::Statistic::User;

use constant R_FAQ		=> "faq";
use constant R_WISH		=> "wish";
use constant R_FRENIZM	=> "frenizm";
use constant R_PETR		=> "petr";
use constant R_MAINSHIT => "mainshit";
use constant R_PROC		=> "proc";
use constant R_NEO_FAQ	=> "neo_faq";

my %ROOM_ATTRIBUTES = (
	(R_FAQ) => {
		id => 1,
		name => "FAQ",
		post_button_caption => "Спросить" 
	},		
	(R_WISH) => {
		id => 2,
		name => "Книга желаний",
		post_button_caption => "Пожелать" 
	},		
	(R_FRENIZM) => {
		id => 3,
		name => "Олигофренизмы",
		post_button_caption => "Спросить" 
	},		
	(R_PETR) => {
		id => 4,
		name => "Похождения Поросенка Петра",
		post_button_caption => "Продолжить" 
	},		
	(R_MAINSHIT) => {
		id => 5,
		name => "Главсрач",
		post_button_caption => "Обосраться" 
	},		
	(R_PROC) => {
		id => 6,
		name => "Процедурная",
		post_button_caption => "Удариться об стену" 
	},
	(R_NEO_FAQ) => {
		id => 7,
		name => "Неофутуризм",
		post_button_caption => "Спросить" 
	}
);

use base "Psy";

sub enter {
	my ($class, %p) = @_;
	
	my $self = Psy::enter($class, %p);
	$self->{room_mnemonic} = $p{room_mnemonic};
	
	return valid_room_name($self->{room_mnemonic}) ? $self : undef;
}
#
# Load special comments
#
sub load_comments {
    my ($self, %p) = @_;

	my $recs_per_page = $p{recs_per_page} || Psy::OP_RECS_PER_PAGE;
	my $page = $p{page} || 1;
	my $offset = ($page - 1) * $recs_per_page;

    my $result_set = $self->query(qq| 
        SELECT 
            cm.id cm_id,
            cm.alias cm_alias,
            cm.msg cm_msg,
			cm.user_id cm_user_id,
			u.name cm_user_name,
            DATE_FORMAT(cm.post_date, '%Y-%m-%d %H:%i') cm_post_date,
			g.name cm_group_name,
			g.comment_phrase cm_comment_phrase,
			g.type cm_group_type,
			CASE WHEN g.id = ? THEN 1 ELSE NULL END cm_for_creo
        FROM spec_comments cm
		LEFT JOIN users u ON u.id = cm.user_id
		LEFT JOIN user_group ug ON ug.user_id = u.id
		LEFT JOIN `group` g ON g.id = ug.group_id AND g.type > 0
		WHERE cm.type = ?
        ORDER BY cm.post_date DESC
		LIMIT ?, ?
		|,
		[Psy::G_PLAGIARIST, $self->{room_mnemonic}, $offset, $recs_per_page],
        {error_msg => "Диагнозы нечитабельны!"}
	);

    my @comments = ();
	for my $row (@$result_set) {
		#$row->{cm_msg} = Psy::Text::Shuffle::comment($row->{cm_msg}, words_power => 70, chars_power => 10);
		$row->{cm_msg} = Psy::Text::convert_to_html($row->{cm_msg});
		$row->{cm_msg} = Psy::Text::activate_inside_links($row->{cm_msg});
		
		$row->{cm_alias} = $row->{cm_user_name} if $row->{cm_user_name};

		$row->{cm_reply} = 1 if $p{reply};
		
		$row->{cm_major} = 1 if $row->{cm_user_id} eq Psy::Auth::MAIN_DOCTOR_ID;
        
		push(@comments, $row);
    }

	my $len = $#comments;
	for my $i (0..$len) {
		$comments[$i]->{cm_inner_id} = $p{total} - $i - $offset;
	}
		
    return \@comments;
}
#   
# Add spec comment
#
sub post_comment {
    my ($self, %p) = @_;

	return 'dub' if $self->last_msg eq $p{msg};

	$p{alias} = $self->is_annonimus ? Psy::Text::Generator::modify_alias($p{alias}) : "";

	$self->query(qq|
        INSERT INTO spec_comments 
        SET user_id = ?,
            msg =  ?,
            alias = ?,
            ip = ?,
			type = ?
		|,
		[$self->{user_data}->{user_id}, $p{msg}, $p{alias}, $self->{ip}, $self->{room_mnemonic}],
		{error_msg => "Психи не дают слова сказать!", debug => 0}
	);

	Psy::Statistic::User->constructor(user_id => $self->user_id)->increment(Psy::Statistic::User::V_SPEC_COMMENTS);	
}   
#
# Get guest book messages total
#
sub comments_total {
    my ($self, %p) = @_;

    my $result = $self->query(
		qq| SELECT COUNT(*) c FROM spec_comments WHERE type = ? |,
		[$self->{room_mnemonic}]
	);

    return $result->[0]->{c};
}
#
# Load last guest book message
#
sub last_msg {
    my ($self, %p) = @_;

    my $result = $self->query(qq|
        SELECT msg
        FROM spec_comments
		WHERE type = ?
        ORDER BY id DESC
        LIMIT 1
		|,
		[$self->{room_mnemonic}]
	);

    return $result->[0]->{msg};
}
#
# Check spec room name
#
sub valid_room_name {
	my ($name) = @_;
	
	return 0 unless defined $name;
	return 1 if grep {/^$name$/} keys %ROOM_ATTRIBUTES;

	return 0;
}
#
# Return room attributes
#
sub attributes {
	my ($self) = @_;
	return $ROOM_ATTRIBUTES{$self->{room_mnemonic}};
}
#
# End
#
1;
