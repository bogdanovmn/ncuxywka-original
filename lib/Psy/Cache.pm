package Psy::Cache;

use strict;
use warnings;
use utf8;

use Utils;
use Cache;

my $__WORKER_CACHE = {};

sub new {
	my ($class, %p) = @_;

	my $self = {
		request_cache       => {}, 
		cross_worker_cache => Cache->constructor(
			fresh_time => 30
		),
	};
    
	return bless $self, $class;
}

sub cache {
	my ($self) = @_;
	return $self->{cross_worker_cache};
}

sub request_cache {
	my ($self, $key, $value) = @_;

	return __PACKAGE__->_local_cache(
		$self->{request_cache},
		$key,
		$value
	);
}

sub worker_cache {
	my ($self, $key, $value) = @_;

	return __PACKAGE__->_local_cache(
		$__WORKER_CACHE,
		$key,
		$value
	);
}

sub _local_cache {
	my ($class, $cache_ref, $key, $value) = @_;

	if (defined $value) {
		$cache_ref->{$key} = ref $value eq 'CODE'
			? &$value()
			: $value;
	}

	return $cache_ref->{$key};
}


1;
