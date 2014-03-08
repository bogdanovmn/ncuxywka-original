package PSY::BOT;

use strict;
use warnings;

use PSY::ERRORS;
use PSY::CREO;
use PSY::TEXT::GENERATOR;
use PSY::AUTH;

use Data::Dumper;

use Digest::MD5 qw( md5_hex );

use base 'PSY::DB';
#
# Bot object constructor
#
sub wakeup {
	my ($class) = @_;

	my $self = PSY::DB::connect($class, console => 1);
	$self->{info} = undef;
	
	return $self;
}
#
# Select random role
#
sub choose_role {
	my ($self, %p) = @_;
	
	my $info = $self->query(qq|
		SELECT * 
		FROM bots
		ORDER BY RAND()
		LIMIT 1;
		|, [], {only_first_row => 1}
	);
	print Dumper($info);
	$self->{info} = $info;
}

sub log {
    my ($self, %p) = @_;

    $self->query(qq|
        INSERT INTO bots_log 
        SET
            bot_id = ?,
			action = ?,
			action_id = ?
		|,
		[$self->{info}->{id}, $p{action}, $p{action_id}]
	);
}
#
# Choose creo for comment
#
sub choose_target {
    my ($self, %p) = @_;

    my $creo_id = $self->query(qq|
		SELECT c.id creo_id, COUNT(cm.id) cm_count
		FROM creo c
		LEFT JOIN comments cm ON c.id = cm.creo_id
		WHERE c.post_date < NOW() - INTERVAL 5 MINUTE
		AND c.type <> 2 
		GROUP BY c.id
		HAVING COUNT(cm.id) = 0
		ORDER BY RAND()
		LIMIT 1
		|,
		[],
		{only_field => 'creo_id'}
	);

    return $creo_id;
}
#
# Post creo comment 
#
sub post_creo_comment {
	my ($self, %p) = @_;

	$self->choose_role;

	my $creo_id = $self->choose_target;
	if ($creo_id) {
		my $creo = PSY::CREO->choose($creo_id, console => 1);
		$creo->post_comment(
			user_id => $self->{info}->{user_id},
			msg => PSY::TEXT::GENERATOR::BOT::creo_comment($self->{info}->{type}),
			ip => '0.0.0.0',
			post_date_delta => 3600   
		);
		$self->log(
			bot_id => $self->{info}->{id},
			action => 'creo_comment',
			action_id => $creo_id
		);
	}
}

1;
