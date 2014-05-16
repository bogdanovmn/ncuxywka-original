package PsyApp::Action::Users;

use strict;
use warnings;
use utf8;


sub main {
	my ($class, $params) = @_;

	my $psy = $params->{psy};

	my $users_by_reg_date = $psy->load_users(order_by_date => 1);
	#
	# Process users by reg date
	#
	my $pre_date = "";
	my $group = 0;
	for (my $i = 0; $i < @$users_by_reg_date; $i++) {
		if ($users_by_reg_date->[$i]->{u_reg_date} ne $pre_date) {
			$users_by_reg_date->[$i]->{u_show_date} = 1;
			$group = 0;
		}
		else {
			$users_by_reg_date->[$i]->{u_show_date} = 0;
			$group = 1;
			$users_by_reg_date->[$i - 1]->{u_group} = $group;
		}
		$users_by_reg_date->[$i]->{u_group} = $group;
		$pre_date = $users_by_reg_date->[$i]->{u_reg_date};
	}
	#
	# Users by letter
	#
	my $users = $psy->load_users;
	my $letter_groups = {};
	my @letters  = ();
	for (my $i = 0; $i < @$users; $i++) {
		my $char = $users->[$i]->{u_letter};
		unless (exists $letter_groups->{$char}) {
			push @letters, $char;
		}
		push @{$letter_groups->{$char}}, $users->[$i];
	}

	my $groups_count = 3;
	my $group_size = int(scalar @$users / $groups_count);
	my @user_list_by_letter_groups = ();
	my $current_group_index = 0;
	my $current_group_size = 0;
	for my $l (@letters) {
		my $letter_size = scalar @{$letter_groups->{$l}};
		if (
			$current_group_size + $letter_size > $group_size and 
			($current_group_index + 1) < $groups_count
		) {
			$current_group_index++;
			$current_group_size = 0;
		}
		push @{$user_list_by_letter_groups[$current_group_index]->{ul_letters}}, {
			ull_letter => $l, ull_users => $letter_groups->{$l} 
		};
		$current_group_size += $letter_size;
	}
	#
	# Some statistic
	#
	my $most_active_users = $psy->cache->try_get(
		'most_active_users', 
		sub { $psy->most_active_users(limit => 10) },
		Cache::FRESH_TIME_DAY
	);

	my $top_users_by_votes = $psy->cache->try_get(
		'top_users_by_votes',
		sub { $psy->top_users_by_votes(count => 10) },
		Cache::FRESH_TIME_DAY
	);
	#
	# Set template params
	#
	return {
		most_active_users => $most_active_users,
		top_users_by_votes => $top_users_by_votes,
		users_by_reg_date => $users_by_reg_date,
		user_list_by_letter_groups => \@user_list_by_letter_groups,
		$psy->users_by_rank,
	};
}

1;
