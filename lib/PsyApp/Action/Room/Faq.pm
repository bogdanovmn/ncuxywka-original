package PsyApp::Action::Room::Faq;

use strict;
use warnings;
use utf8;

use Psy::Room;
use Psy::Errors;

use Paginator;

sub main {
	my ($class, $params) = @_;

	my $page = $params->{page} || 1;
	my $room = $params->{room};

	my $template_params = {
		room_name => $room,
		multi_page => 'yes'
	};

	my $psy_room = undef;
	$psy_room = Psy::Room->enter(room_mnemonic => $room);

	return error("Вы ошиблись палатой!") unless $psy_room;

	my $comments_total = $psy_room->comments_total;
	my $pages = Paginator->init(
		total_rows => $comments_total,
		current => $page,
		rows_per_page => Psy::OP_RECS_PER_PAGE,
		uri => sprintf("/%s_room/", $room)
	);
	#
	# Load spec comments records
	#
	my $comments = $psy_room->load_comments( 
		total => $comments_total,
		page => $page,
		reply => 'yeaaah'
	);
	#
	# Set template params
	#
	return {
		comments => $comments,
		post_button_caption => $psy_room->attributes->{post_button_caption},
		$pages->html_template_params,
	};
}

1;
