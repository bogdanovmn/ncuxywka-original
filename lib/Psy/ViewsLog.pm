package Psy::ViewsLog;

use strict;
use warnings;
use utf8;

use Psy::Errors;

use constant OBJECT_TYPE_CREO => 'creo';
use constant OBJECT_TYPE_USER => 'user';

use base 'Psy::DB';
#
# object constructor
#
sub constructor {
	my ($class, %p) = @_;

	my $self = Psy::DB::connect($class);
	$self->{id} = $p{id};
	$self->{ip} = $p{ip};
	$self->{user_agent} = $p{user_agent};
	$self->{type} = $p{type};
	$self->{viewer_user_id} = $p{viewer_user_id};
	
	return $self;
}

sub increment {
	my ($self) = @_;

	$self->_log;
	$self->_increment_statistic;
}

sub _log {
    my ($self, %p) = @_;
    
	$self->query(qq|
        INSERT LOW_PRIORITY INTO views_log 
        SET
            object_type = ?,
            object_id = ?,
            user_id = ?,
            ip = ?,
			user_agent = ?
		|,
		[$self->{type}, $self->{id}, $self->{viewer_user_id} || undef, $self->{ip}, $self->{user_agent}],
        {error_msg => "Писарь не поспевает за Вами..."}
	);
}


sub _increment_statistic {
	my ($self) = @_;
}

sub total {
    my ($self, %p) = @_;

    my $total = $self->query(qq|
        SELECT COUNT(id) total
		FROM views_log
		WHERE object_type = ?
		AND object_id = ?
		|,
		[$self->{type}, $self->{id}],
		{only_field => 'total'}
	);
    
	return $total || 0;
}

1;
