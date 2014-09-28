package PsyApp::Action::Room::PostComment;

use strict;
use warnings;
use utf8;

use Psy::Room;
use Psy::Text::Generator;


sub main {
	my ($self) = @_;
	
	my $room  = $self->params->{room};
	my $msg   = $self->params->{msg};
	my $alias = $self->params->{alias}; 
	my $psy   = $self->params->{psy};

	my $psy_room = undef;
	$psy_room = Psy::Room->enter(
		room_mnemonic => $room,
		user_id       => $psy->user_id
	);
	
	return $psy->error("Вы ошиблись палатой!") unless $psy_room;
	
	unless ($psy->bot_detected($msg, $alias)) {
		$psy_room->post_comment( 
			msg   => $msg,
			alias => $psy->is_annonimus ? Psy::Text::Generator::modify_alias($alias) : ""
		);
		$psy->update_post_time;
	}

	return 1;
}

1;
