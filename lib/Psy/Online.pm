package Psy::Online;

use strict;
use warnings;
use utf8;

use List;
use Format::LongNumber;
use Psy::Creo;


my %STATIC_PATH = (
	'/' => [
		'читает доску почета',
		'бродит у парадного входа',
		'раздумывает о лечении',
	],
	'/faq_room/' => [
		'изучает ФАК',
		'присматривается к FUCKу',
		'размышляет как надурить Главврача'
	],
	'/add_creo/' => [
		'сдает анализы',
		'писает в баночку',
		'какает в коробок',
		'мастурбирует в пробирку',
		'сдает кровь'
	],
	'/gb/' => [
		'буянит в палате №6',
		'разговаривает с Иосифом Виссарионовичем',
		'пьет Чайковского',
		'косит от армии',
		'хвастается желтым билетом'
	],
	'/users/' => [
		'изучает других пациэнтов',
		'рисует усы на портрете главврача',
	],
	'/creos/' => [
		'ищет анализы',
		'смотрит истории болезней',
	],
	'/quarantine/' => [
		'ищет анализы в мусорном баке',
		'занят копрофилией',
	],
	'/talks/' => [
		'читает диагнозы',
		'подслушивает других пациэнтов',
	],
	'/user_edit/' => [
		'приводит себя в порядок',
		'редактирует анкету',
		'изменяет личности',
		'перевоплощается'
	],
	'/pm/in/' => [
		'читает СМС-ки',
		'получает записки',
		'отвечает на письма поклонников',
		'пишет на деревню дедушки',
		'шепчется'
	],
	'/wish_room/' => [
		'строчит донос Главврачу',
		'выписывает благодарноcть Главврачу',
		'желает странного',
		'мечтает о новой палате',
		'жалуется на жизнь в психушке',
		'канючит таблетки'
	],
	'/petr_room/' => [
		'читает вслух про поросенка Петра',
		'ищет трактор',
	],
	'/frenizm_room/' => [
		'пускает слюни',
		'брызжет умом',
		'цитирует Капитана Очевидность'
	],
	'/mainshit_room/' => [
		'матертся на санитаров',
		'злобно бранится'
	],
	'/proc_room/' => [
		'бьется головой об стену',
		'проходит процедуры',
		'клизмуется-шприцуется'
	],
	'/neofuturism/' => [
		'думает о нееофутуризме',
		'читает список Шиндлера'
	],
	'/neo_faq_room/' => [
		'изучает ФАК неофутуризма',
	],
	'/news/' => [
		'читает газету',
		'читает твиттер',
		'читает стенгазету'
	],
	'/search/' => [
		'роется в картатеке анализов'
	]
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
				$1 == $self->user_id
					? (
						'разглядывает свою историю болезни',
						'самолюбование'
					)
					: (
						'подглядывает за '. ($self->get_user_name_by_id($1) || 'пациэнтом')
					)
			);
		}
		elsif ($path =~ m{^/(?:creos|print)/(\d+)\.html$}) {
			my $user_id = Psy::Creo->choose($1)->author_id;
			return List::random_element(
				$user_id 
					? (
						'читает анализы '. $self->get_user_name_by_id($user_id) 
					)
					: (
						'пытается читать анализы'
					)
			);
		}
	}
}

1;
