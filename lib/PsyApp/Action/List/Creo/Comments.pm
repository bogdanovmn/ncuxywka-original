package PsyApp::Action::List::Creo::Comments;

use strict;
use warnings;
use utf8;

use Psy;
use Psy::Creo;
use Paginator;


sub main {
	my ($self) = @_;

	my $page    = $self->params->{page} || 1;
	my $from_id = $self->params->{from};
	my $for_id  = $self->params->{for};
	my $psy     = $self->params->{psy};

	#
	# Load last comments 
	#
	my $last_comments = $psy->comments(
		cut  => 1,
		page => $page,
		from => $from_id,
		for  => $for_id,
		creo_types => [Psy::Creo::CT_CREO, Psy::Creo::CT_QUARANTINE]
	);

	my $get_params = '';
	$get_params    = 'from/'.$from_id."/" if $from_id;
	$get_params    = 'for/'.$for_id."/"   if $for_id;
	$get_params    = sprintf('for/%d/from/%d/', $for_id, $from_id) if ($for_id and $from_id);

	my $pages = Paginator->init(
		total_rows => $psy->get_comments_total( from => $from_id, for => $for_id),
		current => $page,
		rows_per_page => Psy::OP_RECS_PER_PAGE,
		uri => '/talks/'.$get_params
	);
	#
	# Some statistic
	#
	my $most_commented_creo_list = $psy->cache->try_get(
		'most_commented_creo_list',
		sub { $psy->most_commented_creo_list(count => 15) },
		Cache::FRESH_TIME_HOUR
	);

	my $most_commented_creo_list_revert = $psy->cache->try_get(
		'most_commented_creo_list_revert', 
		sub { $psy->most_commented_creo_list(count => 15, sort_order => 'asc') },
		Cache::FRESH_TIME_HOUR
	);
	#
	#Set template params
	#
	return {
		last_comments => $last_comments, 
		multi_page => 'yes',
		most_commented_creo_list => $most_commented_creo_list,
		most_commented_creo_list_revert => $most_commented_creo_list_revert,
		$pages->html_template_params,
	};
}

1;
