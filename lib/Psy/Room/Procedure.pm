package Psy::Room::PROCEDURE;

use strict;
use warnings;

use Psy::Errors;
use Psy::Text;
use Psy::Navigation;

use base "Psy::Room";

sub enter {
	my ($class, %p) = @_;

	my $self = Psy::Room::enter($class,
		room_mnemonic => Psy::Room::R_PROC,
		check_ban => 0
	);

	$self->{ban_left_time} = $self->banned;

	return $self;
}
#
# End
#
1;
