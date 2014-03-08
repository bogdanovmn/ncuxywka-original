package Psy::Text::Generator;

use strict;
use warnings;

use Psy::Text::LEXICON;

sub attention_phrase {	
	my $phrase = random_element(@ATTENTION_TEMPLATE);

	return process_template(text => $phrase, up_first => 1);
}

sub user_rang {
	my $rang = random_element(@USER_RANG_TEMPLATE);
	
	return process_template(text => $rang, up_first => 1);
}

sub process_template {
	my %p = @_;

	my $source_text = $p{text};
	my @words = split(/#/, $source_text);
	my $text = '';
	my $first_word = 1;
	my $template_words_keys = join("|", keys %TEMPLATE_WORDS);
	for my $w (@words) {
		if ($w =~ /^($template_words_keys)$/) {
			my $rand_word = random_element(@{$TEMPLATE_WORDS{$1}}) || '???';
			$text .= $rand_word;
		}
		else {
			$text .= $w;
		}

		if ($p{up_first} and $first_word and $w ne '') {
			my @letters = split(//, $text);
			$letters[0] =~ tr/�-�/�-�/;
			$text = join("", @letters);
			$first_word = 0;
		}
	}

	return $text;
}
#
# Modify anonimous name
#
sub modify_alias {
	my ($alias) = @_;

	return "�����-�������" if $alias =~ m|\.\w+|;

	my $rang = user_rang();
	
	$alias = "" if $alias =~ /^\s*$/;
	return $rang. " ". $alias;
}

sub random_element {
	return @_[int rand @_];
}

1;
