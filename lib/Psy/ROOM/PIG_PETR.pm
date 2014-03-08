package PSY::ROOM::PIG_PETR;

use strict;
use warnings;

use PSY::ERRORS;
use PSY::TEXT;

use base "PSY::ROOM";

sub enter {
	my ($class, %p) = @_;

	my $self = PSY::ROOM::enter($class, room_mnemonic => PSY::ROOM::R_PETR);

	return $self;
}
#
# Load special comments
#
sub load_comments {
    my ($self, %p) = @_;
	return [reverse @{PSY::ROOM::load_comments($self, %p)}];
}

sub top_users_list {
    my ($self, %p) = @_;

    my $users = $self->query(qq|
		SELECT 
			IFNULL(u.name, sc.alias) pp_alias, 
			u.id pp_user_id,
			COUNT(*) pp_cnt 
		FROM spec_comments sc 
		LEFT JOIN users u ON u.id = sc.user_id 
		WHERE sc.type = 'petr' 
		GROUP BY name 
		ORDER BY pp_cnt DESC
		|,
        [],
		{error_msg => "Поросенок Петр уехал на тракторе прочь!"}
	);

    return $users;
}
#
# End
#
1;
