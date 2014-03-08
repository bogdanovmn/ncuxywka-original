#!/usr/bin/perl

use strict;
use warnings;
use lib 'inc';
use CGI;
use PSY;
use PSY::CREO;
use PSY::USER;
use PSY::ERRORS;
use PSY::NAVIGATION;
use PSY::VIEWS_LOG::CREO;
use TEMPLATE;

my $cgi = CGI->new;
my $id = $cgi->param('id');
my $action = $cgi->param('action') || 'read';
my $msg = $cgi->param('msg');
my $alias = $cgi->param('alias');


my $psy = PSY->enter;
my $creo = PSY::CREO->choose($id);
my $tpl = TEMPLATE->new('creo_view');

my $details = $cgi->param("details") || 0;
my $admin_details = ($details and $psy->is_god) ? $psy->creo_votes($id) : [];
#
# Case action
#
if ($action eq 'add') {
	unless ($psy->bot_detected($msg, $alias)) {
		$creo->post_comment( 
			user_id => $psy->user_id, 
			msg => $msg,
			alias => $alias
		);
		$psy->update_post_time;
		goto_back();
	}
}

my ($creo_data, $creo_comments) = $creo->load;
unless ($creo_data) {
	pn_goto(URL_404);
}
my $author = PSY::USER->choose($creo_data->{c_user_id});
my $author_info = $author->info;
my @votes = @{$creo->votes};
#
# Look for vote power =)
#
my $vote_power = $psy->check_vote_power;
#
# Look for user first time vote
#
my $already_voted = 0;
my $votes_rank = $psy->votes_rank(\@votes);
for my $v (@votes) {
	if ($v->{user_id} eq $psy->user_id) {
		$already_voted = 1;
		last;
	}
}
#
# Vote only for auth users
#
my $can_vote = (
	!$psy->is_annonimus and 
	!$already_voted and 
	$creo_data->{c_user_id} ne $psy->user_id and
	$vote_power
);
#
# Select only for auth users
#
my $already_selected = $creo->already_selected_by_user(user_id => $psy->user_id);
my $can_select = (
	!$psy->is_annonimus and
	!$already_selected
);
#
# Load author's creo list
#
my $author_creo_list = $author->creo_list(
	looker_user_id => $psy->user_id,
	type => [PSY::CREO::CT_CREO]
);
$author_creo_list = [ map { $_->{cl_selected} = 1 if $_->{cl_id} eq $id; $_ } @$author_creo_list ];
#
# Load random creo list
#
my $random_creo_list = $psy->random_creo_list(user_id => $creo->{c_user_id}, count => 5);
#
# Increment views counter
#
my $views_log = PSY::VIEWS_LOG::CREO->constructor(
	id => $id,
	viewer_user_id => $psy->user_id
);
if ($psy->user_id ne $author) {
	$views_log->increment;
}

my $show_creo_statistic = ($psy->user_id eq $creo_data->{c_user_id}) || $psy->is_god; 
my $views_total = undef;
my $selections_info = [];

if ($show_creo_statistic) {
	#
	# Views statistic
	#
	$psy->cache->select("creo-$id-views_counter");
	$views_total = $psy->cache->fresh
		? $psy->cache->get
		: $psy->cache->update($views_log->total);
	#
	# Selection statistic
	#
	$psy->cache->select("creo-$id-selection_statistic");
	$selections_info = $psy->cache->fresh
		? $psy->cache->get
		: $psy->cache->update($creo->selections_info);
}
#
# Set template params
#
$tpl->params(
	%$creo_data,
	comments => $creo_comments,
	quarantine => $creo_data->{c_type} eq PSY::CREO::CT_QUARANTINE,
	neofuturism => $creo_data->{c_neofuturism} eq 1,
	deleted => (($creo_data->{c_type} eq PSY::CREO::CT_DELETE) or ($author_info->{u_group_id} eq PSY::G_PLAGIARIST)),
	already_voted => $already_voted,
	can_vote => $can_vote, 
	can_select => $can_select, 
	has_vote_power => $vote_power,
	votes => $#votes == -1 ? 0 : $#votes + 1,
	votes_rank => $votes_rank->{value},
	votes_rank_title => $votes_rank->{title},
	creo_id => $id,
	creo_statistic => $show_creo_statistic, 
	views_total => $views_total,
	selections_total => scalar @$selections_info,
	selections_info => $selections_info,
	avatar => $author->avatar_file_name,
	user_creo_list => $author_creo_list,
	random_creo_list => $random_creo_list,
	creo_edit_menu => ($psy->auditor->can_edit_creo),
	plagiarist => $author_info->{u_group_id} eq PSY::G_PLAGIARIST,
	ad_votes => $admin_details,
	creo_view => 1,
	%{$psy->common_info(skin => ($creo_data->{c_neofuturism} eq 1) ? 'neo' : undef)}
);

$tpl->show;
