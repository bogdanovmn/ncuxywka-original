package PsyApp::Action::User::View;

use strict;
use warnings;
use utf8;

use Psy;
use Psy::User;
use Psy::Chart::Data::Common;
use Psy::Statistic::Words;
use Utils;

sub main {
	my ($self) = @_;

	my $id      = $self->params->{id}; 
	my $details = $self->params->{details} || 0;
	my $psy     = $self->params->{psy};

	my $user = Psy::User->choose($id);
	my $admin_details = ($details and $psy->is_god) ? $psy->user_votes($id) : [];
	#
	# Load user info
	#
	my $user_info = $user->info;
	return unless $user_info;

	my $user_creos = $user->creo_list(
		looker_user_id => $psy->user_id,
		type => [Psy::Creo::CT_CREO, Psy::Creo::CT_QUARANTINE]
	);

	my $user_selected_creos = $user->selected_creo_list(looker_user_id => $psy->user_id);

	my $user_favorites = $psy->cache->try_get(
		"user-$id-favorites",
		sub { $user->favorites }
	);
	#
	# User statistic
	#
	my $chart_data = Psy::Chart::Data::Common->constructor;
	my $user_activity_chart_data = $psy->cache->try_get(
		"user-$id-activity",
		sub { $chart_data->user_activity($id) },
		Cache::FRESH_TIME_DAY
	);

	my $user_votes_out_rank = $psy->cache->try_get(
		"user-$id-votes_out_rank",
		sub { $user->votes_out_rank },
		Cache::FRESH_TIME_DAY
	);
	
	my $user_votes_out_rank_title = {
		0 => 'Еще не определился',
		1 => 'Солидарен с окружающими пациэнтами',
		2 => 'Кругом одни шизики!',
		3 => 'Этим животным только и нужно что спариваться и размножаться!',
		4 => 'Кругом одни параноики...',
		5 => 'Будь моя воля, сделал бы всем лоботомию!'
	}->{$user_votes_out_rank};
	#
	# Only owner of selects can del his selects =)
	#
	my $can_delete = $id eq $psy->user_id;
	#
	# Format user info for HTML
	#
	$user_info->{u_about} = Psy::Text::convert_to_html($user_info->{u_about});
	$user_info->{u_hates} = Psy::Text::convert_to_html($user_info->{u_hates});
	$user_info->{u_loves} = Psy::Text::convert_to_html($user_info->{u_loves});
	#
	# User ban left time
	#
	my $user_ban_left_time = $user->ban_left_time;
	#
	#
	#
	my $words_statistic = Psy::Statistic::Words->constructor(user_id => $id);

	my $words_frequency = [];
	if (0 and $psy->is_god) {
		my $words_frequency = $psy->cache->try_get(
			"user-$id-words_freq",
			sub { $words_statistic->frequency(ignore_border => 4) },
			Cache::FRESH_TIME_DAY
		);
	}
	#
	# Set template params
	#
	return {
		creo_list                 => $user_creos,
		can_delete                => $can_delete,
		selected_creo_list        => $user_selected_creos,
		user_favorites            => $user_favorites,
		user_votes_out_rank_title => $user_votes_out_rank_title,
		user_ban_left_time        => $user_ban_left_time ? full_time($user_ban_left_time) : undef, 
		user_edit_menu            => $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_USER_BAN),
		avatar                    => $user->avatar_file_name,
		u_from_comments_count     => $user_info->{u_comments_out},
		u_for_comments_count      => $user_info->{u_comments_in},
		u_activity_chart_data     => $user_activity_chart_data,
		jquery_flot_required      => 1,
		jquery_required           => 1,
		ad_votes                  => $admin_details,
		words_statistic           => $words_frequency,
		%$user_info,
	};
}

1;
