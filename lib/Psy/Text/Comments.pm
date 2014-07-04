package Psy::Text::Comments;

use strict;
use warnings;
use utf8;

use Psy::Creo;
use List;

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
			if ($line =~ /(?:http:\/\/)?(?:www\.)?(?:m\.)?ncuxywka\.com\/creos\/(\d+)\.html$/) {
				my $creo_id = $1;
				my $creo = Psy::Creo->choose($creo_id);
				my $creo_data = $creo->load_headers;
				if ($creo_data) {
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
