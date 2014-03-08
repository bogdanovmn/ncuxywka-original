package Psy::Text;

use strict;
use warnings;

use Psy::Creo;
use Psy::Errors; 

use LIST;

use locale;
use POSIX qw(setlocale LC_ALL LC_CTYPE);
setlocale(LC_CTYPE, "ru_RU.CP1251");

#
# Fuck filter words
#
my @FUCK_FILTER_TEMPLATE = (
	{ word => ['блять', 'бля'], alt => ['кхы-кхе', 'хру', 'буэ', 'блин'] },
	{ word => ['нахуй'], alt => ['нафих', 'к черту'] },
	{ word => ['мудак'], alt => [qw| чудак весельчак пупсик косяк |] },
	{ word => ['ебаный', 'еблан'], alt => [qw| другой дурацкий кривой |] },
	{ word => [qw| ебать выебываться выебнуться |],	alt => ['мастурбировать', 'гонять лысого', 'душить змея'] },
	{ word => [qw| ебнула ебанула |], alt => [qw| ударила шлепнула брызнула плеснула упала |] },
	{ word => [qw| выеб |],	alt => ['прям как'] },
	{ word => ['сучка'], alt => ['собачка', 'кошка ревнивая'] },
	{ word => ['пиздец'], alt => ['трындец', 'капец', 'полная кастрюля тухлых щей'] },
	{ word => ['пизда'], alt => ['шляпа'] },
	{ word => ['пизд'], alt => ['пинд'] },
	{ word => ['хуйня'], alt => ['ерунда', 'фигня'] },
	{ word => ['хуй'], alt => ['болт', 'фаллоc', 'фаллоимитатор'] },
	{ word => ['долбоеб'], alt => ['баобаб'] }
);

#
# Replace new lines with <br>
#
sub convert_to_html {
	my ($text) = @_;
	
	$text = replace($text, 'Машинист', 'Трубочист');
	$text = replace($text, 'teplovoz', 'unitaz');
	$text = replace($text, 'тепловоз', 'унитаз');
	$text = cut_long_words($text, 65);
	$text = replace_multi_spaces($text);
	$text = replace_html_direct_symbols($text);
	$text =~ s/\r\n/<br>/g;

	return $text;
}
#
# Replace some symbols for inserting into HTML
#
sub replace_html_direct_symbols {
	my ($text) = @_;
	
	$text =~ s/"/&quot;/g;
	$text =~ s/'/&#39;/g;
	$text =~ s/</&lt;/g;
	$text =~ s/>/&gt;/g;
	
	return $text;
}
#
# Replace some words =)
#
sub replace {
	my ($text, $from, $to) = @_;
	
	$text =~ s/$from/$to/sg;

	return $text;
}
#
# Cut text for preview
#
sub cut_top_lines { 
    my ($text, $show_lines) = @_;

    my @tmp = split(/<br>/, $text);
    if (scalar @tmp > $show_lines) {
        @tmp = @tmp[0..$show_lines - 1];
        return join("<br>", @tmp);
    }
    else {
        return $text;
    }
}
#
# Cut text by max chars length
#
sub cut_first_chars {
	my ($text, $show_chars) = @_;
	
	return $text if length($text) <= $show_chars;
	
	my @new_text = ();
	
	my @lines = split(/<br>/, $text);
	for my $line (@lines) {
		my $new_line = '';
		my $new_text_current_length = length join("", @new_text);
		my @words = split(/ /, $line);
		for my $word (@words) {
			if ( ($new_text_current_length + length($new_line .' '. $word) ) >= $show_chars) {
				push(@new_text, $new_line);
				return join("<br>", @new_text);
			}
			else {
				$new_line .= ' '. $word;
			}
		}
		push(@new_text, $new_line);
	}
	
	return $text;
}
#
# Format long words in line
#
sub long_words_format {
	my ($line, $max_word_len) = @_;

	my $new_line = '';
	for my $word (split(/ /, $line)) {
		if (length $word > $max_word_len) {
			$new_line .= substr($word, 0, $max_word_len). "-\n". substr($word, $max_word_len, length $word);
		}
		else {
			$new_line .= $word;
		}
		$new_line .= " ";
	}

	chop $new_line;

	return $new_line;
}
#
# Cut long words in the text
#
sub cut_long_words {
	my ($text, $max_word_length) = @_;
	
	my @lines = split(/\n/, $text);
	my $lines_count = @lines;
	for (my $i = 0; $i < $lines_count; $i++) {
		my @words = split(/ /, $lines[$i]);
		my $words_count = @words;
		for (my $j = 0; $j < $words_count; $j++) {
			$words[$j] = substr($words[$j], 0, $max_word_length).' ["в следующий раз отрежу тебе пипирку!" (c) Главврач]' if (length $words[$j] > $max_word_length);
		}
		$lines[$i] = join(" ", @words);
	}
	
	return join("\n", @lines);
}
#
# Replace multi-spaces with &nbsp;
#
sub replace_multi_spaces {
	my ($text) = @_;
	
	my @lines = split(/\n/, $text);
	my $lines_count = @lines;
	for (my $i = 0; $i < $lines_count; $i++) {
		my @chars = split(//, $lines[$i]);
		my $chars_count = @chars;
		my $already_spaces = 0;
		for (my $j = 0; $j < $chars_count; $j++) {
			if ($chars[$j] eq ' ') {
				if ($already_spaces or $j == 0) {
					$chars[$j] = '&nbsp;';
				}
				else {
					$already_spaces = 1;
				}
			}
			else {
				$already_spaces = 0;
			}
		}
		$lines[$i] = join("", @chars);
	}
	
	return join("\n", @lines);
}
#
# Make regexp for word
#
sub make_word_regexp {
	my ($text) = @_;
	
	my @chars = split(//, $text);
	my $regexp = join('+\s?', @chars);
	
	return $regexp. '+';
}
#
# Fuck-filter
#
sub fuck_filter {
	my ($text) = @_;
	
	for my $template (@FUCK_FILTER_TEMPLATE) {
		for my $word (@{$template->{word}}) {
			my $word_regexp = make_word_regexp($word);
			my $random_alt_word = LIST::random_element(@{$template->{alt}});
			while ($text =~ s/$word_regexp/$random_alt_word/i) {
				$random_alt_word = LIST::random_element(@{$template->{alt}});
			}
		}
	}
	
	return $text;
}
#
# Check bot-name like 'BEZlVZZrhEdhFitcT' or 'GeUrebaIkdvneZOcUtU'
#
sub check_bot_name {
	my ($string) = @_;
	my $total_chars = length $string;
	my @chars = split(//, $string);
	my $uppers = 0;
	for my $c (@chars) {
		if (grep {/^$c$/} ('A'..'Z')) {
			$uppers++;
		}
	}
}
#
# Activate inside links
#
sub activate_inside_links {
	my ($text) = @_;
	
	my @words = split(/ /, $text);
	my $words_count = @words;
	for (my $i = 0; $i < $words_count; $i++) {
		my @lines = split(/<br>/, $words[$i]);
		my @tmp_lines = ();
		for my $line (@lines) {
			if ($line =~ /(.*)ncuxywka\.com\/creos\/(\d+)\.html$/) {
				my $creo_id = $2;
				my $creo = Psy::Creo->choose($creo_id);
				my $creo_data = $creo->load_headers;
				my $link_prefix = $1;
				if ($creo_data and $link_prefix =~ /^(http:\/\/)?(www\.)?$/) {
					push(@tmp_lines, sprintf(
						"<a href='/creos/%d.html'>[<b>Анализ:</b> %s - %s]</a>", 
						$creo_id, $creo_data->{c_alias}, $creo_data->{c_title})
					);
				}
				else {
					push(@tmp_lines, $line);
				}
			}
			else {
				push(@tmp_lines, $line);
			}
		}
		if (@lines > 1) {
			$words[$i] = join("<br>", @tmp_lines);
		}
		else {
			$words[$i] = $tmp_lines[0];
		}
	}
	return join(" ", @words);
}

1;
