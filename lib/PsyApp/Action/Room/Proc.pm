package PsyApp::Action::Room::Proc;

use strict;
use warnings;
use utf8;

use base 'PsyApp::Action::Room';

sub _custom_action {
	my ($class, $params, $psy_room, $template_params) = @_;

	$template_params->{ban_left_time} = $psy_room->{ban_left_time};
	$template_params->{inside} = $template_params->{ban_left_time} ne 0;
	
	if ($params->{psy}->is_god) {
		$template_params->{ban_left_time} = 100500;
		$template_params->{inside} = 1;
	}
}

1;
