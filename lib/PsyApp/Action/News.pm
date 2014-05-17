package PsyApp::Action::News;

use strict;
use warnings;
use utf8;

use Psy;
use Psy::News;

sub main {
	my ($class, $params) = @_;

	my $psy = Psy->enter;
	my $news = Psy::News->constructor;

	my $news_data = $psy->cache->try_get(
		'news',
		sub { $news->load }
	);

	$news_data = [ map { $_->{god} = 1 if $psy->is_god; $_; } @$news_data ];

	return {
		news => $news_data,
	};

}


1;
