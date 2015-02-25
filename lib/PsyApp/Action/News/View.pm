package PsyApp::Action::News::View;

use strict;
use warnings;
use utf8;


sub main {
	my ($self) = @_;

	my $news_data = $self->psy->cache->try_get(
		'news',
		sub { $self->last },
	);
	return {
		news => $news_data
	};

}

sub last {
	my ($self, $count) = @_;

	$self->schema_select(
		'News',
		{ visible  => 1 },
		{ 
			order_by => { -desc => 'id' },
			$count 
				? ( rows => $count )
				: ()
		},
		[qw/ id msg user_id post_date /],
		'n_',
		{
			date_field => 'post_date',
			user_id    => 'user_name'
		}
	);
}

1;
