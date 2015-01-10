package PsyApp::Action::GB::Post;

use strict;
use warnings;
use utf8;

use Psy::GB;


sub main {
	my ($self) = @_;

	my $msg   = $self->params->{msg};
	my $alias = $self->params->{alias}; 
	my $psy   = $self->params->{psy};

	my $gb = Psy::GB->enter;

	unless ($psy->bot_detected($msg, $alias)) {
		$gb->post_comment(
			msg     => $msg, 
			user_id => $psy->user_id,
			ip      => $psy->{ip},
			alias   => $psy->is_annonimus 
				? Psy::Text::Generator::modify_alias($alias) 
				: ""
		);
		$psy->update_post_time;
	}

	return 1;
}

1;
