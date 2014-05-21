package PsyApp::Action::Creo::Print;

use strict;
use warnings;
use utf8;

use Psy::Creo;


sub main {
	my ($class, $params) = @_;

	my $id  = $params->{id};
	my $psy = $params->{psy};

	my $creo      = Psy::Creo->choose($id);
	my $creo_data = $creo->load(with_comments => 0);
	
	return undef unless $creo_data;

	return {	
		%$creo_data,
		comments => [], #$comments || [],
		quarantine => $creo_data->{c_type} eq Psy::Creo::CT_QUARANTINE,
		deleted => $creo_data->{c_type} eq Psy::Creo::CT_DELETE,
		creo_id => $id,
	};
}

1;
