package TextGenerator::Result;

use strict;
use warnings;
use utf8;


sub new {
	my ($class, %p) = @_;

	my $self = {
		chunks       => [],
		chunks_count => $p{chunks_count} || 40
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
	my $prev_chunk;

	foreach my $chunk (@{$self->{chunks}}) {
		my $sep = ' --- ';
		if ($prev_chunk and $prev_chunk->last_token->position == ($chunk->first_token->position - 1)) {
			$sep = ' === ';
			$sep = ' ';
		}
		$result .= $sep. $chunk->text;

		$prev_chunk = $chunk;
	}

	return $result;
}

sub is_empty {
	my ($self) = @_;

	return 0 == @{$self->{chunks}};
}

sub is_done {
	my ($self) = @_;

	return @{$self->{chunks}} >= $self->{chunks_count};
}

1;
