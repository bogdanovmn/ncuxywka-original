package Psy::Auditor;

use strict;
use warnings;

#
# Moderator's scope
#
use constant MODERATOR_SCOPE_CREO_EDIT	=> "creo_edit";
use constant MODERATOR_SCOPE_USER_BAN	=> "user_ban";
use constant MODERATOR_SCOPE_QUARANTINE => "quarantine";
use constant MODERATOR_SCOPE_CREO_DELETE=> "creo_delete";
use constant MODERATOR_SCOPE_PLAGIARISM => "plagiarism";
use constant MODERATOR_SCOPE_NEOFUTURISM=> "neofuturism";
use constant MODERATOR_SCOPE_PROFILER	=> "profiler";
#
# Moderator's scope
#
use constant EVENT_CREO_EDIT		=> "creo_edit";
use constant EVENT_USER_BAN			=> "user_ban";
use constant EVENT_TO_QUARANTINE	=> "to_quarantine";
use constant EVENT_FROM_QUARANTINE	=> "from_quarantine";
use constant EVENT_CREO_DELETE		=> "creo_delete";
use constant EVENT_TO_PLAGIARISM	=> "to_plagiarism";
use constant EVENT_FROM_PLAGIARISM	=> "from_plagiarism";
use constant EVENT_TO_NEOFUTURISM	=> "to_neofuturism";
use constant EVENT_FROM_NEOFUTURISM	=> "from_neofuturism";

use base 'Psy::DB';
#
# User object constructor
#
sub constructor {
	my ($class, %p) = @_;

	return undef if (not defined $p{user_id});
	
	my $self = Psy::DB::connect($class);
	$self->{user_id} = $p{user_id};
	$self->{moderator_scopes} = undef;
	
	return $self;
}

sub get_moderator_id {
	my ($self) = @_;
	return $self->query(
		q| SELECT moderator_id FROM moderator WHERE user_id = ? |,
		[$self->{user_id}],
		{only_field => 'moderator_id'}
	);
}

sub log {
    my ($self, %p) = @_;

    $self->query(qq|
        INSERT INTO moderation_log 
        SET
            moderator_id = (SELECT id FROM moderator WHERE user_id = ?),
            event_type = ?,
            object_id = ?,
			ip = ?
		|,
		[$self->{user_id}, $p{event_type}, $p{object_id}, $self->{ip}],
        {error_msg => "Аудитор - кровавая Гэбня!"}
	);
}
#
# Is curreent user can do it?
#
sub is_moderator_scope {
	my ($self, @check_scopes) = @_;
	
	my $all_scopes = $self->load_moderator_scopes;
	for my $scope (@check_scopes) {
		return 1 if exists $all_scopes->{$scope};
	}
	return 0;
}
#
# Load moderator scopes
#
sub load_moderator_scopes {
	my ($self) = @_;

	return $self->{moderator_scopes} if defined $self->{moderator_scopes}; 
	
	my $result = $self->query(q|
		SELECT scope
		FROM moderator_scope ms
		JOIN moderator m ON m.id = ms.moderator_id
		WHERE m.user_id = ?
		|,
		[$self->{user_id}],
		{error_msg => "scope info"}
	);

	$self->{moderator_scopes} = {};
	for my $row (@$result) {
		$self->{moderator_scopes}->{$row->{scope}} = 1;
	}

	return $self->{moderator_scopes};
}
#
# Can edit creo
#
sub can_edit_creo {
	my $self = shift;
	return $self->is_moderator_scope(
		MODERATOR_SCOPE_CREO_EDIT,
		MODERATOR_SCOPE_PLAGIARISM,
		MODERATOR_SCOPE_CREO_DELETE,
		MODERATOR_SCOPE_QUARANTINE,
		MODERATOR_SCOPE_NEOFUTURISM
	);
}

1;
