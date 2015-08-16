package TextGenerator::Source;

use strict;
use warnings;
use utf8;

use Utils;
use List;
use TextGenerator::Token;
use TextGenerator::Chunk;
use TextGenerator::Result;

sub new {
	my ($class, $text) = @_;

	my $self = {
		text => $text,
	};

	return bless $self, $class;
}

sub add {
	my ($self, $text) = @_;

	$self->{text} .= "\n". $text;
}

sub _prepare_tokens {
	my ($self) = @_;

	return if exists $self->{tokens};

	$self->{text} =~ s/([!;:?+=.,])/ $1/g;
	#$self->{text} =~ s/([\w-])(\W)/$1 $2/g;
	#$self->{text} =~ s/(\W)([\w-])/$1 $2/g;
	$self->{text} =~ s/ {2,}/ /g;
	$self->{text} =~ s/\r//g;

	my $position    = 0;
	my $new_line    = 0;
	my $is_prev_dot = 1;
	foreach my $line (split /\n/, $self->{text}) {
		$line =~ s/(^\s+)|(\s+$)//g;
		$line =~ s/^\W+//g;

		$new_line = 1;
		foreach my $t (split / /, $line) {
			my $token = TextGenerator::Token->new($t);
			$token->position($position);

			#_verbose('new token "%s", position #%d', $token->value, $token->position);

			push @{$self->{tokens}}, $token;
			push @{$self->{token_index}->{$token->value}}, $position;
			
			if ($new_line or $is_prev_dot) {
				#_verbose('token is first');
				push @{$self->{first_token_index}}, $position;
			}

			$position++;
			$new_line = 0;
			
			$is_prev_dot = ($token->value =~ /[.?!]/);
		}

		#_verbose('add new line token, position #%d', $position);

		my $new_line_token = TextGenerator::Token->new("\n");
		$new_line_token->position($position++);
		push @{$self->{tokens}}, $new_line_token;
	}
	#debug $self->{token_index};
	#debug $self->{first_token_index};
}

sub _get_first_chunk {
	my ($self) = @_;

	my $token_index = List::random_element @{ $self->{first_token_index} };	

	_verbose('first token index=%d; value=%s', 
		$token_index, 
		$self->{tokens}->[$token_index]->value
	);

	return $self->_get_chunk($token_index);	
}

sub _get_next_chunk {
	my ($self, $chunk) = @_;

	return undef unless $chunk;

	my $last_token = $chunk->last_token;
	my $last_token_all_positions = $self->{token_index}->{$last_token->value};
	my ($alt_position) =
		(@$last_token_all_positions > 1)
			? List::random_element(grep { $_ ne $last_token->position } @$last_token_all_positions)
			: $last_token_all_positions->[0];


	return @{$self->{tokens}} <= $alt_position
		? undef
		: $self->_get_chunk($alt_position + 1);
}

sub _get_chunk {
	my ($self, $position) = @_;

	_verbose("\tget new chunk, start position=%d (total=%d)", $position, scalar @{$self->{tokens}});

	my $chunk = TextGenerator::Chunk->new;
	my $words_count = 0;
	while ($words_count < $self->{chunk_length}) {
		my $token = $self->{tokens}->[$position++];
		
		unless ($token) {
			_verbose('no more tokens');
			return undef;
		}

		$chunk->add($token);
		if ($token->is_word) {
			$words_count++;
		}
	}
	return $chunk;
}

sub create {
	my ($self, %p) = @_;

	$self->{chunk_length} = $p{chunk_length} || 5;

	$self->_prepare_tokens;
	
	my $chunk = $self->_get_first_chunk;
	if ($chunk) {
		my $result = TextGenerator::Result->new(chunks_count => 250 / $self->{chunk_length});
		$result->add($chunk);
		while (my $next_chunk = $self->_get_next_chunk($chunk) and not $result->is_done) {
			$result->add($next_chunk);
			$chunk = $next_chunk;
		}

		return $result->text;
	}
}

sub _verbose {
	my ($msg, @format_params) = @_;

	my $str = sprintf '[verbose] '. $msg."\n", @format_params;
	utf8::encode($str);
	#print $str;
}

1;
