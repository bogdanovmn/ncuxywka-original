package PSY::ROOM::PROCEDURE;

use strict;
use warnings;

use PSY::ERRORS;
use PSY::TEXT;
use PSY::NAVIGATION;

use base "PSY::ROOM";

sub enter {
	my ($class, %p) = @_;

	my $self = PSY::ROOM::enter($class,
		room_mnemonic => PSY::ROOM::R_PROC,
		check_ban => 0
	);

	$self->{ban_left_time} = $self->banned;

	return $self;
}
#
# End
#
1;
