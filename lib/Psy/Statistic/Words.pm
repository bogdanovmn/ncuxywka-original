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
		$line =~ s/_+/ /g;
		$line =~ s/\s+/ /g;
		$line =~ s/ё/е/g;
		for my $word (split /\W+/, $line) {
			next if $word =~ /^\s*$/;
			next if $word =~ /^(ни|о|со|и|не|что|в|на|а|с|то|это|за|как|но|так|к|по|уже|ну|от|у|бы|вот|до|из|ли|же|про|под)$/;
			next if $word =~ /^[a-z0-9]+$/;
			next if $word =~ /^[a-zйцкнгшщзхъфвпрлджчсмтьб0-9]+$/;
		
			my $type = 'common';
			$type = 'type_1' if $word =~ /^(я|мой|меня|моего|моему|мое|мной|мне|моих|ты|тебя|твоих|тебе|твоего|твои|твоя|твой|он|его|ему|его|она|ее|ей|мы|нас|наше|нам|оно|они|их)$/;
			$self->{words}->{$type}->{$word}++;
			$self->{total}->{$type}++;
		}
	}
}

sub total_words {
	my ($self, $type) = @_;

	$self->_load;

	return scalar keys %{$self->{words}->{$type}};
}

sub font_size {
	my ($max, $value, $step) = @_;

	$step ||= 1;

	my $max_size = 108;
	my $min_size = 8;
	my $result   = int($max_size * $value / ($step*$max));

	$result -= $result % $step;
	$result  = $min_size if $result < $min_size;

	return $result;
}

sub words_cloud {
	my ($self, $type) = @_;

	$self->_load;

	my $ignore_border = 1;
	my $percent_limit = 0.01;
	my @result;
	my $max = 0;
	my $min = 99999;
	while (my ($word, $freq) = each %{$self->{words}->{$type}}) {
		my $percent = sprintf('%.2f', 100 * $freq / $self->{total}->{$type});

		if ($freq > $ignore_border and $percent > $percent_limit) {
			push @result, { word => $word, freq => $freq, percent => $percent };
			$max = $freq if $max < $freq;
			$min = $freq if $min > $freq;
		}
	}

	my $try_count = 20;
	while (@result > 300 and $try_count--) {
		$percent_limit += 0.01;
		@result = grep { $_->{percent} >= $percent_limit } @result;
	}


	my $font_size_step = int 100 / $#result;
	for my $r (@result) {
		$r->{font_size} = font_size($max, $r->{freq}, $font_size_step);
	}
	
	@result = sort @result;

	return {
		wc_uniq    => $self->total_words($type),
		wc_total   => $self->{total}->{$type},
		wc_visible => scalar @result,
		wc_limit   => $percent_limit,
		wc_title   => $type eq 'type_1' ? 'Обещение' : 'Кругозор',
		wc_data  => [ 
			sort { $a->{word} cmp $b->{word} } 
			@result
		]
	};
}

1;
