package Psy::Statistic::Words;

use strict;
use warnings;
use utf8;

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
		$line =~ s/\s+/ /g;
		for my $word (split /[ .,="':;<>?!(){}_&#*-]+/, $line) {
			next if $word =~ /^\s*$/;
			next if $word =~ /^(о|со|и|не|что|в|на|а|с|то|это|за|как|но|так|к|по|уже|ну|от|у|бы|вот|до|из|ли|же|про|под)$/;
			next if $word =~ /^[a-z0-9]+$/;
			next if $word =~ /^[a-zйцкнгшщзхъфвпрлджчсмтьб0-9]+$/;
			
			if (1 or length $word > 2 
			or  $word =~ /(я|он|мы|ты)/
			) {
				$self->{words}->{$word}++;
				$self->{total}++;
			}
		}
	}
}

sub total_words {
	my $self = shift;
	$self->_load;

	return scalar keys %{$self->{words}};
}

sub font_size {
	my ($max, $value) = @_;
	
	my $max_size = 108;
	my $min_size = 8;
	my $result = $max_size * $value / $max;

	$result = $min_size  if $result < $min_size;

	return $result;
}

sub words_cloud {
	my ($self, %p) = @_;

	$self->_load;

	my $ignore_border = $p{ignore_border} || -1;
	my @result;
	my $max = 0;
	while (my ($word, $freq) = each %{$self->{words}}) {
		my $percent = sprintf('%.2f', 100 * $freq / $self->{total});
		if ($freq > $ignore_border and $percent >= 0.1) {
			push @result, { word => $word, freq => $freq, percent => $percent };
			$max = $freq if $max < $freq;
		}
	}

	for my $r (@result) {
		$r->{font_size} = font_size($max, $r->{freq});
	}
	#return [sort { $a->{word} cmp $b->{word} } @result];
	return {
		wc_uniq  => $self->total_words,
		wc_total => $self->{total},
		wc_data  => [ 
			#sort { ($b->{freq} <=> $a->{freq}) or ($a->{word} cmp $b->{word}) } 
			sort { $a->{word} cmp $b->{word} } 
			@result
		]
	};
}

1;
