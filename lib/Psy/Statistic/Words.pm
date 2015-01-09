package Psy::Statistic::Words;

use strict;
use warnings;
use utf8;

use constant CLOUD_FONT_SIZE_MIN => 9;
use constant CLOUD_FONT_SIZE_MAX => 109;

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
			next if $word =~ /^(ни|о|со|и|не|что|в|на|а|с|то|это|за|как|но|так|к|по|уже|ну|от|у|бы|вот|до|из|ли|же|про|под|во|об|ко)$/;
			next if $word =~ /^[a-z0-9]+$/;
			next if $word =~ /^[a-zйцкнгшщзхъфвпрлджчсмтьб0-9]+$/;
		
			my $type = 'common';
			$type = 'type_1' if $word =~ /^(я|мой|моя|моим|мою|меня|моего|моему|мое|мной|мне|моих|мои|моей|ты|тебя|твоих|тебе|твоего|твои|твоя|твой|он|его|ему|его|она|ее|ей|мы|вы|нас|наше|нам|оно|они|их|им|них|нем)$/;
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
	my ($value, $max_freq, $freq_count, $count) = @_;

	my $step   = int(100 / $freq_count) || 1;
	my $result = int(CLOUD_FONT_SIZE_MAX * $value / ($max_freq));

	$result -= $result % $step;
	$result  = CLOUD_FONT_SIZE_MIN if $result < CLOUD_FONT_SIZE_MIN;

	return $result;
}

sub words_cloud {
	my ($self, $type) = @_;

	$self->_load;

	my $ignore_border = 0;
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
	#
	# Отсекаем слова с единичным вхождением
	# если не добираем по кол-ву слов в облаке
	#
	if (@result < 100) {
		$ignore_border--;
		@result = grep { $_->{freq} > $ignore_border } @result;
	}
	#
	# Если слов много, отсекаем постепенно по проценту вхождения 
	#
	my $try_count = 30;
	while (@result > 600 and $try_count--) {
		$percent_limit += 0.01;
		@result = 
			grep { $_->{percent} >= $percent_limit } 
			@result;
	}

	my %uniq_freq;
	for my $r (@result) {
		$uniq_freq{$r->{freq}}++;
	}
	my $freq_count = keys %uniq_freq;

	my $min_font_size = 9999;
	for my $r (@result) {
		$r->{font_size} = font_size($r->{freq}, $max, $freq_count, scalar @result);
		$min_font_size = $r->{font_size} if $min_font_size > $r->{font_size};
	}
	
	if ($min_font_size > CLOUD_FONT_SIZE_MIN) {
		foreach my $r (@result) {
			$r->{font_size} *= CLOUD_FONT_SIZE_MIN / $min_font_size;
		}
	}
	
	@result = sort @result;

	return {
		wc_uniq    => $self->total_words($type),
		wc_total   => $self->{total}->{$type},
		wc_visible => scalar @result,
		wc_limit   => $percent_limit,
		wc_uniq_freq  => scalar keys %uniq_freq, 
		wc_title   => $type eq 'type_1' ? 'Эгоцентр' : 'Мыслеворот',
		wc_size    => @result < 40 ? 'small' : 'big',
		wc_perfect => $self->{total}->{$type}
			? int(100 * $self->total_words($type) / $self->{total}->{$type} )
			: 0,
		wc_data  => [ 
			sort { $a->{word} cmp $b->{word} } 
			@result
		]
	};
}

1;
