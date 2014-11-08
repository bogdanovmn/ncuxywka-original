package Cache;

use strict;
use warnings;
use utf8;

use Utils;
use Format::LongNumber;
use Cache::Memcached;

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

	#return &$get_value_sub();

	my $value = $self->{storage}->get($id);
	
	unless ($value) {
		$value = &$get_value_sub();
		$self->{storage}->set($id, $value, $fresh_time);
	}

	return $value;
}	

sub clear {
	my ($self) = @_;
}

sub total_size {
	my ($self, %p) = @_;
	my @files = glob $self->{storage}. "/*.pd";
	my $total = 0;
	my $max = -1;
	for my $file (@files) {
		my $size = -s $file;
		$total += $size;
		$max = $size if $size > $max;
	}
	return {
		cache_elements_count => scalar @files,
		cache_total_size => short_traffic($total),
		cache_max_size => short_traffic($max)
	}


}

1;
