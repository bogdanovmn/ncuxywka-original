package PsyApp::Action::News;

use strict;
use warnings;
use utf8;

use Psy;
use Psy::News;

sub main {
	my ($class, $params) = @_;

	my $id = $cgi->param('id');
	my $action = $cgi->param('action') || 'read';
	my $msg = $cgi->param('msg');

	my $psy = Psy->enter;
	my $news = Psy::NEWS->constructor;

	$psy->cache->select('news');

	my $common_info = $psy->common_info;
#
# Case action
#
	if ($action eq 'add') {
		error("Врачей не наипешь!") unless $psy->is_god;

		$news->add(
			user_id => $psy->user_id,
			msg => $msg
		);
		$psy->cache->clear;
		
		goto_back();
	}
	elsif ($action eq 'hide') {
		error("Врачей не наипешь!") unless $psy->is_god;

		$news->hide($id);
		$psy->cache->clear;

		goto_back();
	}

	my $news_data = $psy->cache->fresh
		? $psy->cache->get
		: $psy->cache->update($news->load);

	$news_data = [ map { $_->{god} = 1 if $psy->is_god; $_; } @$news_data ];

	return {
		news => $news_data,
	};

}

1;
