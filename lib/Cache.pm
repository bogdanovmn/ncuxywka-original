package Cache;

use strict;
use warnings;
use utf8;

use Utils;
use Format::LongNumber;
use Cache::Memcached;
use Time::HiRes;

use constant FRESH_TIME_MINUTE => 60;
use constant FRESH_TIME_HOUR   => 60*60;
use constant FRESH_TIME_DAY    => 60*60*24;


sub constructor {
	my ($class, %p) = @_;
	
	my $self = {
		storage => $p{storage},
		fresh_time => $p{fresh_time} || 5 * FRESH_TIME_MINUTE
	};

	$self->{current_fresh_time} = $self->{fresh_time};
	$self->{storage} = Cache::Memcached->new(
		servers => ['127.0.0.1:11211']
	);

	return bless $self, $class;
}

sub try_get {
	my ($self, $id, $get_value_sub, $fresh_time) = @_;

	return &$get_value_sub();
	my $t = Time::HiRes::time;
	my $value = $self->{storage}->get($id);
	$self->{statistic}->{get_total_time} += Time::HiRes::time - $t;
	$self->{statistic}->{get_count}++;
	
	if ($value) {
		$self->{statistic}->{from_cache}++;
	}
	else {
		$value = &$get_value_sub();
		$t = Time::HiRes::time;
		$self->{storage}->set($id, $value, $fresh_time);
		$self->{statistic}->{set_total_time} += Time::HiRes::time - $t;
		$self->{statistic}->{set_count}++;
	}

	return $value;
}	

sub clear {
	my ($self, @params) = @_;

	$self->{storage}->delete(@params);
}

sub total_size {
	my ($self, %p) = @_;

	my $stat = $self->{storage}->stats(['misc']);
	#debug($stat);#
	return {
		cache_elements_count => $stat->{total}->{curr_items},
		cache_total_size     => short_traffic($stat->{total}->{bytes}),
		cache_uptime         => full_time((values %{$stat->{hosts}})[0]->{misc}->{uptime})
	}
}

sub statistic {
	my ($self) = @_;
	
	my %s = %{$self->{statistic} || {}};
	$s{total_time}     = sprintf('%.3f', ($s{set_total_time} || 0) + ($s{get_total_time} || 0));
	$s{set_total_time} = sprintf('%.3f', $s{set_total_time} || 0);
	$s{get_total_time} = sprintf('%.3f', $s{get_total_time} || 0);

	return \%s;
}

sub clear_statistic {
	my ($self) = @_;
	$self->{statistic} = {};
}

1;
