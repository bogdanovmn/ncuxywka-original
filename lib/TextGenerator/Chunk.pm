package TextGenerator::Chunk;

use strict;
use warnings;
use utf8;


sub new {
	my ($class, $tokens) = @_;

	my $self = {
		tokens => ref $tokens eq 'ARRAY' ? $tokens : [ $tokens || () ],
	};

	return bless $self, $class;
}

sub add {
	my ($self, $token) = @_;

	push @{$self->{tokens}}, $token;
}

sub last_token {
	my ($self) = @_;

	return $self->{tokens}->[-1];
}

sub text {
	my ($self) = @_;
use Utils;debug $self;
	return join ' ', map { $_->value } @{$self->{tokens}};
}

1;
