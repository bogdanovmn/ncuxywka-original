package PsyApp::Action::Room::View::Proc;

use strict;
use warnings;
use utf8;

use base 'PsyApp::Action::Room::View';


sub _custom_action {
	my ($class, $params, $psy_room, $template_params) = @_;
	
	if ($self->params->{psy}->is_god) {
		$template_params->{ban_left_time} = 100500;
		$template_params->{inside}        = 1;
	}
	else {
		$template_params->{ban_left_time} = $self->params->{ban_left_time};
		$template_params->{inside}        = $self->params->{ban_left_time} ne 0;
	}
}

1;
