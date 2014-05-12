package PsyApp::Action::RoomPost;

use strict;
use warnings;
use utf8;

use Psy::Room;
use Psy::Errors;
use Utils;

sub main {
	my ($class, $params) = @_;
	webug $params;
	my $room = $params->{room};
	my $msg = $params->{msg};
	my $alias = $params->{alias}; 

	my $psy_room = undef;
	$psy_room = Psy::Room->enter(room_mnemonic => $room);

	return error("Вы ошиблись палатой!") unless $psy_room;
	
	unless ($params->{psy}->bot_detected($msg, $alias)) {
		$psy_room->post_comment( 
			msg => $msg,
			alias => $alias
		);
		$params->{psy}->update_post_time;
	}

	return 1;
}

1;
