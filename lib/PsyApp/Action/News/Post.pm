package PsyApp::Action::News::Post;

use strict;
use warnings;
use utf8;


sub main {
	my ($self) = @_;

	my $msg = $self->params->{msg};
	
	unless ($self->psy->is_god) {
		return $self->psy->error("Врачей не наипешь!");
	}

	$self->schema->resultset('News')->create({
		user_id => $self->psy->user_id,
		msg     => $msg
	});

	return not $self->psy->error;
}

sub _can_add {
	my ($self, $user_id) = @_;

	#my $last_post_date = $self->query(q|
	#	SELECT MAX(post_date) last_post_date 
	#	FROM news
	#	WHERE user_id = ?
	#	|,
	#	[$user_id],
	#	{only_field => 'last_post_date'}
	#);

	#return (
	#	not defined $last_post_date or 
	#	(time - $last_post_date) > 60*60*24
	#);
}	


1;
