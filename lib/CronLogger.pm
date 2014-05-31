package CronLogger;

use strict;
use warnings;
use utf8;

use Date;
use Data::Dumper;


sub new {
	my ($class, %p) = @_;

	die "log file name expected!" unless $p{file_name};

	my $self = {
		start_time => time,
		file_name  => $p{file_name},
		stdout     => $p{stdout} || 0
	};

	open LOG, '>>', $self->{file_name} or die $self->{file_name}.": ". $!;
	$self->{file_handle} = *LOG;

	return bless $self, $class;
}

sub say {
	my ($self, $msg) = @_;

	$msg = sprintf("[%s] %s\n", Date::unix_time_to_ymdhms(), $msg);

	print { $self->{file_handle} } $msg;
}

sub error {
	my ($self, $msg) = @_;
	
	$self->say("[ERROR] $msg");
	exit;
}

sub start {
	my ($self) = @_;
	
	$self->{start_time} = time;
}

sub finish {
	my ($self) = @_;
	
	my $duration = time - $self->{start_time};
	$self->say("Done. Total time: ". $duration. " sec");
}

sub DESTROY {
	my ($self) = @_;

	close($self->{file_handle})
}

1;
