package PsyApp::Action::News::View;

use strict;
use warnings;
use utf8;

use Psy::News;
use Utils;

sub main {
	my ($self) = @_;

	my $news_data = $self->psy->cache->try_get(
		'news',
		sub { 
			$self->schema->resultset('News')->search(
				{ visible  => 1    },
				{ order_by => { -desc => 'id' } }
			);
		},
		1
	);

	while (my $n = $news_data->next) {
	}
	#$news_data = [ map { $_->{god} = 1 if $self->psy->is_god; $_; } @$news_data ];

	return {
	#	news => $news_data,
	};

}

sub main111 {
	my ($self) = @_;

	my $psy  = $self->params->{psy};
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
