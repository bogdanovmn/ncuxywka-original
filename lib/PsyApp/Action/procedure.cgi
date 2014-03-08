#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use PSY;
use PSY::ERRORS;
use PSY::NAVIGATION;

use CGI;

my $cgi = CGI->new;

my $duration = $cgi->param('duration');
my $ip = $cgi->param('ip');
my $user_id = $cgi->param('user_id');

my $psy = PSY->enter;

error("Вы уже в процедурной!") if $psy->banned;

my $moderator_action = defined $user_id and $psy->auditor->is_moderator_scope(PSY::AUDITOR::MODERATOR_SCOPE_USER_BAN);



if ($moderator_action) {
	my $user = PSY::USER->choose($user_id);
	my $user_info = $user->info;
	error("Пациэнт успел улизнуть!") unless $user_info;

	$psy->ban(
		duration => 360, #$duration,
		ip => $user_info->{u_ip},
		user_id => $user_id
	);
	$psy->auditor->log(
		event_type => PSY::AUDITOR::EVENT_USER_BAN,
		object_id => $user_id
	);
	goto_back();
}
else {
	error("В процедурную ходят строго по времени!") if not defined $duration;
	error("Непонятное время вы указали...!") unless $duration =~ /^\d+$/;
	
	$psy->ban(duration => $duration);
	pn_goto(URL_BANNED);
}
