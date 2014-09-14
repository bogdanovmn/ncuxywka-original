package PsyApp::Action::GB::View;

use strict;
use warnings;
use utf8;

use Psy::GB;
use Paginator;


sub main {
	my ($self) = @_;

	my $page = $self->params->{page} || 1;
	my $psy  = $self->params->{psy};

	my $gb = Psy::GB->enter;
	
	my $pages = Paginator->init(
		total_rows    => $gb->comments_total,
		current       => $page,
		rows_per_page => Psy::OP_RECS_PER_PAGE,
		uri           => '/gb/'
	);
	#
	# Load guest book records
	#
	my $comments = $gb->load_comments( 
		page  => $page,
		reply => 'yeaaah'
	);
	
	return {
		comments            => $comments, 
		multi_page          => 'yes',
		post_button_caption => 'Кря-кря!',
		anti_top_votes      => $psy->is_annonimus ? [] : $psy->anti_top_votes,
		$pages->html_template_params,
	};
}

1;
