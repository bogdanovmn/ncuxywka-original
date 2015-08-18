package TextGenerator::Token;

use strict;
use warnings;
use utf8;


sub new {
	my ($class, $value, %attr) = @_;

	my $self = {
		value => $value,
		%attr
	};

	return bless $self, $class;
}

sub value {
	my ($self) = @_;
	return $self->{value};
}

sub position {
	my ($self, $value) = @_;
	
	if ($value) {
		$self->{position} = $value;
	}

	return $self->{position};
}

sub is_word {
	my ($self) = @_;

	return 
		$self->value =~ /^(я|[а-я]{2,})$/i
}

1;
