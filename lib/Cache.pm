package Cache;

use strict;
use warnings;
use utf8;

use Utils;
use Format::LongNumber;
#use CHI;

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
	#$self->{chi} = CHI->new(
	#	driver => 'FIle',
	#	root_dir => $self->{storage}
	#);

	return bless $self, $class;
}

sub select {
	my ($self, $id, $current_fresh_time) = @_;
	
	$self->{current_fresh_time} = $current_fresh_time || $self->{fresh_time}; 
	$self->{id} = $id;
}

sub _file_name {
	my ($self) = @_;
	return $self->{storage}. '/'. $self->{id}. '.pd'
}

sub update {
	my ($self, $value) = @_;
	
	my $file_name = $self->_file_name;
	
	open F, '>:utf8', $file_name or die("Can't write cache '$file_name' [ $! ]");
	#$Data::Dumper::Indent = 0;
	print F Utils::_dumper($value);
	#$Data::Dumper::Indent = 1;
	close F;
	
	return $value;
}

sub fresh {
	my ($self) = @_;
	
	my $file_name = $self->_file_name;

	return 0 unless $file_name;
	return 0 unless -e $file_name;

	my $last_modification_delta = time - (stat $file_name)[9];
	
	return (-e $file_name and $last_modification_delta < $self->{current_fresh_time});
}

sub get {
	my ($self) = @_;

	my $data = undef;
	my $file_name = $self->_file_name;
	if (-e $file_name) {
		open F, '<', $file_name or die("Can't read cache '$file_name' [ $! ]");
		my $cache_data = '';
		$cache_data .= $_ while (<F>);
		close F;

		$data = eval $cache_data;
	}

	return $data;
}

sub try_get1 {
	my ($self, $id, $get_value_sub, $fresh_time) = @_;

	return $self->{chi}->compute($id, sprintf("%d sec", $fresh_time || $self->{fresh_time}), $get_value_sub);
}

sub try_get {
	my ($self, $id, $get_value_sub, $fresh_time) = @_;

	return &$get_value_sub();

	$self->select($id, $fresh_time);
	
	return $self->fresh ? $self->get : $self->update(&$get_value_sub());
}	

sub clear {
	my ($self) = shift;
	my $file_name = $self->_file_name;
	if (-e $file_name) {
		unlink $file_name;
	}
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
