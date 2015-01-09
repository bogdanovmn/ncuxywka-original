package PsyApp::Action::List::User;

use strict;
use warnings;
use utf8;


sub main {
	my ($self) = @_;

	my $psy = $self->params->{psy};

	my $users_by_reg_date = $psy->cache->try_get(
		'users_by_reg_date',
		sub { $self->_users_by_date },
		Cache::FRESH_TIME_DAY
	);
	
	my $users_by_letter = $psy->cache->try_get(
		'users_by_letter',
		sub { $self->_users_by_letters },
		Cache::FRESH_TIME_DAY
	);
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
		user_list_by_letter_groups => $users_by_letter,
		$psy->users_by_rank,
	};
}

sub _users_by_letters {
	my ($self) = @_;

	my %result = (rus => [], eng => []);
	my $users = $self->params->{psy}->load_users;
	my $letter_groups = {};
	my %letters;
	my %users_count;
	for (my $i = 0; $i < @$users; $i++) {
		my $char = $users->[$i]->{u_letter};
		my $type = $char =~ /[а-я]/i ? 'rus' : 'eng';

		unless (exists $letter_groups->{$type}->{$char}) {
			push @{$letters{$type}}, $char;
		}
		push @{$letter_groups->{$type}->{$char}}, $users->[$i];
		$users_count{$type}++;
	}

	my $groups_count       = 3;
	my $letter_header_size = 3;
	
	foreach my $type (qw| rus eng |) {
		my $group_size = int(($users_count{$type} + $letter_header_size*@{$letters{$type}}) / $groups_count) 
			+ 2*$letter_header_size;
		
		my $current_group_index = 0;
		my $current_group_size  = 0;
		for my $l (@{$letters{$type}}) {
			my $letter_size = scalar @{$letter_groups->{$type}->{$l}} + $letter_header_size;
			if (
				$current_group_size + $letter_size > $group_size and 
				($current_group_index + 1) < $groups_count
			) {
				$current_group_index++;
				$current_group_size = 0;
			}
			push @{$result{$type}->[$current_group_index]->{ul_letters}}, {
				ull_letter => $l, 
				ull_users  => $letter_groups->{$type}->{$l} 
			};
			$current_group_size += $letter_size;
		}
	}
	
	return [
		{ title => 'Местные'    , data  => $result{rus} },
		{ title => 'Иногородние', data  => $result{eng} }
	];
}

sub _users_by_date {
	my ($self) = @_;

	my $users_by_reg_date = $self->params->{psy}->load_users(order_by_date => 1);
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

	return $users_by_reg_date;
}

1;
