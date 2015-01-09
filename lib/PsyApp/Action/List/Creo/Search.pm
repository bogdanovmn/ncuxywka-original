package PsyApp::Action::List::Creo::Search;

use strict;
use warnings;
use utf8;


sub main {
	my ($self) = @_;
	
	my $search_text = $self->params->{search_text};
	my $psy         = $self->params->{psy};

	return {
		creo_list   => $psy->creo_search(text => $search_text),
		search_text => $search_text,
		#top_users_by_creos_count => $psy->top_users_by_creos_count,
	};
}

1;
