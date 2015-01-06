package Psy::Text::Generator;

use strict;
use warnings;
use utf8;

use Psy::Text::Lexicon;
use List;


sub attention_phrase {	
	my $phrase = List::random_element(@Psy::Text::Lexicon::ATTENTION_TEMPLATE);

	return process_template(text => $phrase, up_first => 1);
}

sub user_rang {
	my $rang = List::random_element(@Psy::Text::Lexicon::USER_RANG_TEMPLATE);
	
	return process_template(text => $rang, up_first => 1);
}

sub process_template {
	my (%p) = @_;

	my @words = split(/#/, $p{text});
	my $text = '';
	my $first_word = 1;
	my $template_words_keys = join("|", keys %Psy::Text::Lexicon::TEMPLATE_WORDS);
	for my $w (@words) {
		my $first_up = 0;
		if (substr($w, 0, 1) eq '^') {
			$first_up = 1;
			$w = substr($w, 1);
		}

		if ($w =~ /^($template_words_keys)$/) {
			my $rand_word = List::random_element(@{$Psy::Text::Lexicon::TEMPLATE_WORDS{$1}}) || '???';
			$text .= $first_up ? ucfirst $rand_word : $rand_word;
		}
		else {
			$text .= $w;
		}

		if ($p{up_first} and $first_word and $w ne '') {
			my @letters = split(//, $text);
			$letters[0] =~ tr/а-я/А-Я/;
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

	return "Робот-спаммер" if $alias =~ m|\.\w+|;

	my $rang = user_rang();
	
	$alias = "" if $alias =~ /^\s*$/;
	return $rang. " ". $alias;
}


1;
