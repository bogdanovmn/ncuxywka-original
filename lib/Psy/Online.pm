package Psy::Online;

use strict;
use warnings;
use utf8;

use List;
use Format::LongNumber;


my %STATIC_PATH = (
	'/faq_room/' => [
		'изучает ФАК'
	],
	'/add_creo/' => [
		'сдает анализы'
	],
	'/gb/' => [
		'буянит в палате №6',
	],
	'/users/' => [
		'изучает других пациэнтов',
	],
	'/creos/' => [
		'ищет анализы',
	],
	'/quarantine/' => [
		'ищет анализы в мусорном баке',
	],
	'/talks/' => [
		'читает диагнозы',
	],
	'/user_edit/' => [
		'приводит себя в порядок',
	],
	'/pm/in/' => [
		'читает СМС-ки',
	],
	'/wish_room/' => [
		'строчит донос Главврачу',
		'выписывает благодарноcть Главврачу'
	],
	'/petr_room/' => [
		'читает вслух про поросенка Петра',
	],
	'/frenizm_room/' => [
		'',
	],
	'/mainshit_room/' => [
		'матертся на санитаров',
	],
	'/proc_room/' => [
		'',
	],
	'/neofuturism/' => [
		'думает о нееофутуризме',
	],
	'/neo_faq_room/' => [
		'изучает ФАК неофутуризма',
	],
);

#
# Get all sessions 
#
sub online_list {
	my ($self) = @_;

	my @sessions = ();
	my $current_time = time;

	my $data = $self->query(qq|
		SELECT session_data, last_active
		FROM session
		WHERE last_active > NOW() - INTERVAL 12 HOUR
		ORDER BY last_active DESC
	|);

	return undef unless $data;

	my %already_in;
	foreach my $d (@$data) {
		my $ses = JSON::XS->new->decode($d->{session_data});
		
		next unless $ses->{user_id};
		next if exists $already_in{$ses->{user_id}};

		push @sessions, { 
			o_user_id     => $ses->{user_id},
			o_user_name   => $self->get_user_name_by_id($ses->{user_id}),
			o_path_descr  => $self->_get_descr_by_path($ses->{path}) || undef,
			o_action_time => full_time($current_time - Date::ymdhms_to_unix_time($d->{last_active}))
		};
		undef $already_in{$ses->{user_id}};
	}
	
	return \@sessions;
}

sub _get_descr_by_path {
	my ($self, $path) = @_;

	if (exists $STATIC_PATH{$path}) {
		return List::random_element(@{$STATIC_PATH{$path}});
	}
	else {
		if ($path =~ m{^/talks/(?:for|from)/}) {
			return List::random_element(
				'читает диагнозы',
				'ищет свои диагнозы'
			);
		}
		elsif ($path =~ m{^/users/(\d+)\.html$}) {
			return List::random_element(
				'подглядывает за пациэнтом'
			);
		}
		elsif ($path =~ m{^/(?:creos|print)/(\d+)\.html$}) {
			return List::random_element(
				'читает анализы'
			);
		}
		elsif ($path =~ m{^/(main/)?$}) {
			return List::random_element(
				'читает доску почета'
			);
		}
	}
}

1;
