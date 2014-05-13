package Psy::Auth;

use strict;
use warnings;
use utf8;

use lib 'inc';
use CGI;
use CGI::Session;
use Digest::MD5 qw( md5_hex );

use Psy::Navigation;
use Psy::User;
use Psy::Errors;
use Psy::Text;
#
# Special user ID
#
use constant ANNONIMUS_ID => 0;
use constant MAIN_DOCTOR_ID => 4;
use constant MAIN_SISTER_ID => 81;
use constant KRAB_ID => -80;
#
# Login event type
#
use constant LOGIN_EVENT_TYPE_IN => 'in';
use constant LOGIN_EVENT_TYPE_OUT => 'out';

use base 'Psy::DB';

#
# Get login info
#
sub info {
	my ($class, %p) = @_;

	my $self = Psy::DB::connect($class) or die;

	$self->{user_data} = {};
	$self->{session} = CGI::Session->new;
	$self->{session}->param("ip", $self->{ip});
	$self->{login_error_msg} = "";

	my $user = Psy::User->choose($self->{session}->param("user_id"));

	if ($user) {
		my $user_info = $user->info;
		
		my $is_god = ($user_info->{u_id} eq MAIN_DOCTOR_ID);
		$self->{user_data}->{user_id} = $user_info->{u_id};
		$self->{user_data}->{alias} = $user_info->{u_name};
		$self->{user_data}->{user_group_id} = $user_info->{u_group_id};
		$self->{user_data}->{user_auth} = $self->{session}->param("user_auth");
		if ($is_god) {
			$self->{user_data}->{god} = 1;
			$self->{user_data}->{counter} = 1;
		}
	}
	else {
		$self->{user_data} = { 
			alias => $self->{session}->param("alias"),
			user_auth => 0,
			user_id => ANNONIMUS_ID 
		};
	}
	return $self;
}
#
# Login to the system
#
sub login {
	my ($self, %p) = @_;

	if (!$p{user_name} or !$p{password}) {
		#$self->{login_error_msg} = "Введите логин и пароль!";
		error("Введите логин и пароль!");
		return 0;
	}

	my $user_info = $self->query(qq| 
		SELECT u.*, ug.group_id 
		FROM users u
		LEFT JOIN user_group ug ON ug.user_id = u.id
		WHERE name = ? 
		AND pass_hash = ? 
		|,
		[$p{user_name}, md5_hex($p{password})]
	);
   

	if (@$user_info) {
		$self->{session}->param("user_id", $user_info->[0]->{id});
		$self->{session}->param("user_name", $user_info->[0]->{name});
		$self->{session}->param("user_group_id", $user_info->[0]->{group_id});
		$self->{session}->param("user_auth", 1);
		$self->{session}->expire('1w');
		
		$self->store_login_event($user_info->[0]->{id}, LOGIN_EVENT_TYPE_IN);
	}
	else {
		#$self->{login_error_msg} =  "Неправильный логин/пароль!";
		error("Неправильный логин/пароль!");
	}
	
	#my @cookie_header = split(/\n/, $self->{session}->header);
	#print $cookie_header[0];
	#print $cookie_header[1];

	#pn_goto(URL_MAIN);

	return 1;
}
#
# Logout from the system
#
sub logout {
	my ($self, %p) = @_; 
	
	$self->{session}->delete;
	$self->{session}->flush;

	$self->store_login_event($self->user_data->{user_id}, LOGIN_EVENT_TYPE_OUT);

	return undef;
}
#
#
#
sub success_in {
	my ($self, %p) = @_;
	return $self->{user_data}->{user_auth};
}
#
#
#
sub login_error_msg {
	my ($self, %p) = @_;
	return $self->{login_error_msg};
}
#
#
#
sub user_data {
	my ($self, %p) = @_;
	return $self->{user_data};
}
#
# Return ban left time
#
sub banned {
	my ($self, %p) = @_;

	my $where = $self->success_in ? 'user_id = ? OR ip = ?' : 'ip = ?';
	my $ban_info = $self->query(qq| 
		SELECT UNIX_TIMESTAMP(MAX(end)) ban_end
		FROM ban
		WHERE NOW() BETWEEN begin AND end
		AND ($where)
		|,
		$self->success_in ? 
			[$self->{user_data}->{user_id}, $self->{ip}] : 
			[$self->{ip}],
		{error_msg => "В процедурном кабинете бунт!"}
	);
	return ((scalar @$ban_info > 0 and defined $ban_info->[0]->{ban_end})? $ban_info->[0]->{ban_end} - time : 0);
}
#
# Login event
#
sub store_login_event {
	my ($self, $user_id, $event_type) = @_;
	$self->query(q|
		INSERT INTO logins
		SET user_id = ?,
			event_type = ?,
			ip = ?
		|,
		[$user_id, $event_type, $self->{ip}],
		{debug => 0}
	);
}
#
# Look at user agent value for Search Bot identification
#
sub is_spider_bot {
	my ($self) = @_;
	for my $bot_name (q| 
		Googlebot-Mobile 
		Googlebot 
		bingbot 
		Mail.RU_Bot 
		MJ12bot 
		YandexBot 
	|) {
		return $bot_name if index($ENV{HTTP_USER_AGENT}, $bot_name) > -1;
	}

	return 0;
}

1;
