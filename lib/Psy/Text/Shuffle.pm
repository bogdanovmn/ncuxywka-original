package Psy::Text::SHUFFLE;

use strict;
use warnings;

use LIST;


#
# Shuffle words in text
#
sub text {
	my ($text, %p) = @_;

	return $text unless $text;
	return $text if (!$p{words_power} and !$p{chars_power});

	my @words = split(/ /, $text);
	
	if ($p{words_power}) {
		words(\@words, power => $p{words_power});
	}

	if ($p{chars_power}) {
		for (my $i = 0; $i < @words; $i++) {
			$words[$i] = chars($words[$i], power => $p{chars_power});
		}
	}

	return join(" ", @words);
}
#
# Shuffle comment (ignore quote strings)
#
sub comment {
	my ($text, %p) = @_;

	my @lines = split(/\n/, $text);
	my $result = "";
	my $current_text = "";
	for my $line (@lines) {
		if ($line =~ /-->/) {
			$result .= text($current_text, %p);
			$result .= $line. "\n";
			$current_text = "";
		}
		else {
			$current_text .= $line. "\n";
		}
	}

	return $result. text($current_text, %p);
}
#
# Pretty shuffle word
#
sub chars {
	my ($word, %p) = @_;	
	
	my $power = $p{power} || 0;
	$power = 100 if ($power > 100);
	$power = 0 if ($power < 0);

	my @chars = split(//, $word);
	if (@chars > 5) {
		my $chars_count = int(@chars * $power / 100);
		for (my $i = 0; $i < $chars_count; $i++) {
			my $index_1 = LIST::random_element_index(\@chars);
			my $index_2 = LIST::random_element_index(\@chars);
			
			next if $index_1 eq $index_2;
			next if ($index_1 eq 0 or $index_2 eq 0);
			next if $chars[$index_1] =~ /\s|\d|[!,.'"?]|[A-Z�-�]/;
			next if $chars[$index_2] =~ /\s|\d|[!,.'"?]|[A-Z�-�]/;

			LIST::swap_elements(\@chars, $index_1, $index_2);
		}
	}

	return join("", @chars);
}
#
# Pretty shuffle words
#
sub words {
	my ($words, %p) = @_;
	
	my $power = $p{power} || 0;
	$power = 100 if ($power > 100);
	$power = 0 if ($power < 0);
	
	my $words_count = int(@$words * $power / 100);
	for (my $i = 0; $i < $words_count; $i++) {
		my $index_1 = LIST::random_element_index($words);
		my $index_2 = LIST::random_element_index($words);
		
		next if $index_1 eq $index_2;
		next if $index_1 eq 0;
		next if $words->[$index_1] =~ /^[A-Z�-�]/;
		next if $words->[$index_2] =~ /^[A-Z�-�]/;
		next if $words->[$index_1] =~ /[!;,.:'")(?\-]/;
		next if $words->[$index_2] =~ /[!;,.:'")(?\-]/;

		LIST::swap_elements($words, $index_1, $index_2);
	}
}


1;
