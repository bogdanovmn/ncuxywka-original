#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use CGI;
use PSY::ROOM;
use PSY::ROOM::PROCEDURE;
use PSY::ROOM::PIG_PETR;
use PSY::ERRORS;
use PSY::NAVIGATION;

use TEMPLATE;
use PAGINATOR;

my $cgi = CGI->new;
my $action = $cgi->param('action') || 'read';
my $msg = $cgi->param('msg');
my $room = $cgi->param('room');
my $alias = $cgi->param('alias'); 
my $page = $cgi->param('page') || 1;

my $template_params = {
	room_name => $room,
	multi_page => 'yes'
};

my $psy_room = undef;
if ($room eq PSY::ROOM::R_PETR) {
	$psy_room = PSY::ROOM::PIG_PETR->enter;
	$template_params->{petr_top_users_list} = $psy_room->top_users_list;
}
elsif ($room eq PSY::ROOM::R_PROC) {
	$psy_room = PSY::ROOM::PROCEDURE->enter;
	$template_params->{ban_left_time} = $psy_room->{ban_left_time};
	$template_params->{inside} = $template_params->{ban_left_time} ne 0;
	
	if ($psy_room->user_id eq PSY::AUTH::MAIN_DOCTOR_ID) {
		$template_params->{ban_left_time} = 100500;
		$template_params->{inside} = 1;
	}
}
else {
	$psy_room = PSY::ROOM->enter(room_mnemonic => $room);
}

error("Вы ошиблись палатой!") unless $psy_room;

#
# Case action
#
if ($action eq 'add') {
	error("Вас огрели электрошокером!") if ($room eq PSY::ROOM::R_PROC and not defined $template_params->{inside});

	unless ($psy_room->bot_detected($msg, $alias)) {
		$psy_room->post_comment( 
			msg => $msg,
			alias => $alias
		);
		$psy_room->update_post_time;
		goto_back();
	}

}

my $tpl = TEMPLATE->new("rooms/$room");
my $comments_total = $psy_room->comments_total;
my $pages = PAGINATOR->init(
	total_rows => $comments_total,
	current => $page,
	rows_per_page => PSY::OP_RECS_PER_PAGE,
	uri => "/$room"."_room/"
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
$tpl->params(
	%{$template_params},
	$pages->html_template_params,
	%{$psy_room->common_info(skin => $room eq PSY::ROOM::R_NEO_FAQ ? 'neo' : undef)}
);

$tpl->show;
