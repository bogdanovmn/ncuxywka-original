package PsyApp::Action::Room::Proc;

use strict;
use warnings;
use utf8;

use Psy::Room;
use Psy::Room::Procedure;
use Psy::Errors;
use Psy::Navigation;

use Paginator;


sub main {
	my ($class, $params) = @_;
	
	my $page = $params->{page} || 1;

	my $template_params = {
		multi_page => 'yes'
	};

	my $psy_room = undef;
	$psy_room = Psy::Room::Procedure->enter;
	
	$template_params->{ban_left_time} = $psy_room->{ban_left_time};
	$template_params->{inside} = $template_params->{ban_left_time} ne 0;
	
	if ($params->{psy}->is_god) {
		$template_params->{ban_left_time} = 100500;
		$template_params->{inside} = 1;
	}

	error("Вы ошиблись палатой!") unless $psy_room;

	my $comments_total = $psy_room->comments_total;
	my $pages = Paginator->init(
		total_rows => $comments_total,
		current => $page,
		rows_per_page => Psy::OP_RECS_PER_PAGE,
		uri => "/proc_room/"
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
	$template_params->{comments} = $comments;
	$template_params->{post_button_caption} = $psy_room->attributes->{post_button_caption};
	return {
		%{$template_params},
		$pages->html_template_params,
	};
}

1;
