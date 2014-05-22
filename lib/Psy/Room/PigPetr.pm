package Psy::Room::PIG_PETR;

use strict;
use warnings;
use utf8;

use Psy::Errors;
use Psy::Text;

use base "Psy::Room";

sub enter {
	my ($class, %p) = @_;

	my $self = Psy::Room::enter($class, room_mnemonic => Psy::Room::R_PETR);

	return $self;
}
#
# Load special comments
#
sub load_comments {
    my ($self, %p) = @_;
	return [reverse @{Psy::Room::load_comments($self, %p)}];
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
		{error_msg => "РџРѕСЂРѕСЃРµРЅРѕРє РџРµС‚СЂ СѓРµС…Р°Р» РЅР° С‚СЂР°РєС‚РѕСЂРµ РїСЂРѕС‡СЊ!"}
	);

    return $users;
}
#
# End
#
1;
