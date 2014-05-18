package PsyApp::Action::ProcedureSet;

use strict;
use warnings;
use utf8;

sub main {
	my ($class, $params) = @_;

	my $duration = $params->{duration};
	my $ip       = $params->{ip};
	my $user_id  = $params->{user_id};
	my $psy      = $params->{psy};

	return $psy->error("Вы уже в процедурной!") if $params->{ban_left_time};

	my $moderator_action = defined $user_id and $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_USER_BAN);

	if ($moderator_action) {
		my $user      = Psy::User->choose($user_id);
		my $user_info = $user->info;
		return $psy->error("Пациэнт успел улизнуть!") unless $user_info;

		$psy->ban(
			duration => 360, #$duration,
			ip       => $user_info->{u_ip},
			user_id  => $user_id
		);

		$psy->auditor->log(
			event_type => Psy::Auditor::EVENT_USER_BAN,
			object_id  => $user_id
		);
	}
	else {
		return $psy->error("В процедурную ходят строго по времени!") unless defined $duration;
		return $psy->error("Непонятное время вы указали...!")        unless $duration =~ /^\d+$/;
		
		$psy->ban(duration => $duration);
	}

	return 1;
}

1
