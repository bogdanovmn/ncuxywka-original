#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use Psy;
use Psy::Errors;
use Psy::User;
use Psy::Navigation;
use Psy::Chart::DATA::COMMON;
use Psy::Statistic::Words;
use TEMPLATE;
use NICE_VALUES;
use CGI;

my $cgi = CGI->new;
my $id = $cgi->param('id') || error("Этот псих уже давно вылечился!");
error("Вы совершили ошибку...") if ($id =~ /\D/);

my $psy = Psy->enter;
my $user = Psy::User->choose($id);
my $tpl = TEMPLATE->new('user_view');

my $details = $cgi->param("details") || 0;
my $admin_details = ($details and $psy->is_god) ? $psy->user_votes($id) : [];

my $common_info = $psy->common_info;
#
# Load user info
#
my $user_info = $user->info;
unless ($user_info) {
	pn_goto(URL_404);
}

my $user_creos = $user->creo_list(
	looker_user_id => $psy->user_id,
	type => [Psy::Creo::CT_CREO, Psy::Creo::CT_QUARANTINE]
);

my $user_selected_creos = $user->selected_creo_list(looker_user_id => $common_info->{user_id});

$psy->cache->select("user-$id-favorites");
my $user_favorites = $psy->cache->fresh
	? $psy->cache->get
	: $psy->cache->update($user->favorites);
#
# User statistic
#
my $chart_data = Psy::Chart::DATA::COMMON->constructor;
$psy->cache->select("user-$id-activity", CACHE::FRESH_TIME_DAY);
my $user_activity_chart_data = $psy->cache->fresh
	? $psy->cache->get
	: $psy->cache->update($chart_data->user_activity($id));

$psy->cache->select("user-$id-votes_out_rank", CACHE::FRESH_TIME_DAY);
my $user_votes_out_rank = $psy->cache->fresh
	? $psy->cache->get
	: $psy->cache->update($user->votes_out_rank);
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
my $can_delete = (
	$common_info->{user_auth} eq 1 and
	$id eq $common_info->{user_id}
);
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
	$psy->cache->select("user-$id-words_freq", CACHE::FRESH_TIME_DAY);
	$words_frequency = $psy->cache->fresh
		? $psy->cache->get
		: $psy->cache->update($words_statistic->frequency(ignore_border => 4));
}
#
# Set template params
#
$tpl->params(
	creo_list => $user_creos,
	can_delete => $can_delete,
	selected_creo_list => $user_selected_creos,
	user_favorites => $user_favorites,
	user_votes_out_rank_title => $user_votes_out_rank_title,
	user_ban_left_time => $user_ban_left_time ? full_time($user_ban_left_time) : undef, 
	user_edit_menu => $psy->auditor->is_moderator_scope(Psy::Auditor::MODERATOR_SCOPE_USER_BAN),
	avatar => $user->avatar_file_name,
	u_from_comments_count => $user_info->{u_comments_out},
	u_for_comments_count => $user_info->{u_comments_in},
	u_activity_chart_data => $user_activity_chart_data,
	jquery_flot_required => 1,
	jquery_required => 1,
	ad_votes => $admin_details,
	words_statistic => $words_frequency,
	%$user_info,
	%$common_info
);

#debug_sql_explain($Psy::DB::__STATISTIC->{queries_details});
$tpl->show;
