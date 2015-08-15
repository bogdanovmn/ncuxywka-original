package TextGenerator::Result;

use strict;
use warnings;
use utf8;


sub new {
	my ($class) = @_;

	my $self = {
		chunks => [],
	};

	return bless $self, $class;
}

sub add {
	my ($self, $chunk) = @_;

	push @{$self->{chunks}}, $chunk;
}

sub text {
	my ($self) = @_;

	my $result = '';
	foreach my $chunk (@{$self->{chunks}}) {
		$result .= ' --- '. $chunk->text;
	}

	return $result;
}

1;
