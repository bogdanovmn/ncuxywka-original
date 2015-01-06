package Psy::Statistic::Words;

use strict;
use warnings;
use utf8;

#use locale;
#use POSIX qw(setlocale LC_ALL LC_CTYPE);
#setlocale(LC_CTYPE, "ru_RU.CP1251");

use Psy::Errors;

use base 'Psy::DB';
#
# object constructor
#
sub constructor {
	my ($class, %p) = @_;

	my $self = Psy::DB::connect($class);
	$self->{words} = undef;
	$self->{user_id} = $p{user_id} || 0;
	$self->{creo_id} = $p{creo_id} || 0;
	
	return $self;
}

sub _load {
    my ($self) = @_;

	return if defined $self->{words};

	my @params = ();
	my $where_user_id = '';
	my $where_creo_id = '';

	if ($self->{user_id}) {
		$where_user_id = 'AND user_id = ?';
		push @params, $self->{user_id};
	}
	if ($self->{creo_id}) {
		$where_creo_id = 'AND id = ?';
		push @params, $self->{creo_id};
	}

    my $texts = $self->query(qq|
        SELECT LCASE(body) body
		FROM creo
		WHERE type IN (0, 1)
		$where_user_id
		$where_creo_id
		|,
		\@params
	);
	
	$self->{words} = {};
	for my $text (@$texts) {
		$self->process_words($text->{body});
	}
}

sub process_words {
	my ($self, $text) = @_;
	for my $line (split /\n/, $text) {
		for my $word (split /[ .,"':;<>?!(){}\-_]+/,  $line) {
			if (length $word > 2 
			or  $word =~ /(я|он|мы|ты)/
			) {
				$self->{words}->{$word}++;
			}
		}
	}
}

sub total_words {
	my $self = shift;
	$self->_load;

	return scalar keys %{$self->{words}};
}

sub frequency {
	my ($self, %p) = @_;

	$self->_load;

	my $ignore_border = $p{ignore_border} || -1;
	my @result = ();
	while (my ($word, $freq) = each %{$self->{words}}) {
		if ($freq > $ignore_border) {
			push @result, { word => $word, freq => $freq };
		}
	}

	#return [sort { $a->{word} cmp $b->{word} } @result];
	return [sort { ($b->{freq} <=> $a->{freq}) or ($a->{word} cmp $b->{word}) } @result];
}

1;
