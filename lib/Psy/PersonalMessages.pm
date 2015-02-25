package Psy::PersonalMessages;

use strict;
use warnings;
use utf8;

use Psy::Text;

use constant PM_RECS_PER_PAGE => 10;

use base "Psy::DB";

sub constructor {
	my ($class, %p) = @_;

	my $self = Psy::DB::connect($class);
	$self->{user_id} = $p{user_id};

	return $self;
}

sub news_count {
	my ($self, %p) = @_;

	my $result = $self->query(qq|
		SELECT COUNT(id) cnt FROM personal_messages 
		WHERE to_user_id = ?
		AND is_new = 1
		|,
		[$self->{user_id}],
        {
			error_msg => "Почтовый голубь улетел, но обещал вернуться!",
			only_first_row => 1
		}
	);

	return $result->{cnt};
}

sub mark_as_read {
    my ($self, %p) = @_;

    $self->query(qq|
        UPDATE personal_messages
		SET is_new = 0
        WHERE to_user_id = ?
		|,
		[$self->{user_id}],
        {error_msg => "Почтовый голубь улетел, но обещал вернуться!"}
	);
}

sub post {
	my ($self, %p) = @_;

	$self->query(qq|
		INSERT INTO personal_messages
		SET	from_user_id = ?,
			to_user_id = ?,
			msg = ?
		|,
		[$self->{user_id}, $p{to_user_id}, $p{msg}],
        {error_msg => "Почтовый голубь отказался доставлять письма!"}
	);
}

sub load {
	my ($self, %p) = @_;

	my $where = $p{direct} eq 'in' ? 'pm.to_user_id = ?' : 'pm.from_user_id = ?';

	my $page = $p{page} || 1;
	my $offset = ($page - 1) * PM_RECS_PER_PAGE;	
	
	my $messages = $self->query(qq|
		SELECT 
			pm.msg lm_msg,
			u.name lm_user_name,
			tu.name lm_to_user_name,
			pm.from_user_id lm_user_id,
			pm.to_user_id lm_to_user_id,
			pm.post_date lm_date,
			pm.is_new lm_new
		FROM personal_messages pm
		LEFT JOIN users u ON u.id = pm.from_user_id
		LEFT JOIN users tu ON tu.id = pm.to_user_id
		WHERE $where
		ORDER BY pm.post_date DESC
		LIMIT ?, ?
		|,
		[$self->{user_id}, $offset, PM_RECS_PER_PAGE],
        {error_msg => "Почтовый голубь улетел, но обещал вернуться!"}
	);
	
	for my $row (@$messages) {
		$row->{lm_is_in_message} = 1 if $p{direct} eq 'in';
		$row->{lm_new} = 0 if $p{direct} eq 'out';
		$row->{lm_msg} = Psy::Text::convert_to_html($row->{lm_msg});
	}

	return $messages;
}

sub rows_count {
	my ($self, %p) = @_;

	my $where = $p{direct} eq 'in' ? 'pm.to_user_id = ?' : 'pm.from_user_id = ?';
	
	my $result = $self->query(qq|
		SELECT COUNT(pm.id) cnt
		FROM personal_messages pm
		WHERE $where
		|,
		[$self->{user_id}],
        {
			error_msg => "Почтовый голубь улетел, но обещал вернуться!!!",
			only_first_row => 1	
		}
	);

	return $result->{cnt};
}

sub load_dialog {
	my ($self, %p) = @_;
	
	my $page = $p{page} || 1;
	my $offset = ($page - 1) * PM_RECS_PER_PAGE;	
	
	my $messages = $self->query(qq|
		SELECT 
			pm.msg dm_msg,
			u.name dm_user_name,
			pm.from_user_id dm_user_id,
			pm.post_date dm_date,
			pm.is_new dm_new
		FROM personal_messages pm
		LEFT JOIN users u ON u.id = pm.from_user_id
		WHERE (pm.to_user_id = ? AND pm.from_user_id = ?)
		OR (pm.to_user_id = ? AND pm.from_user_id = ?)
		ORDER BY pm.post_date DESC
		LIMIT ?, ?
		|,
		[$p{to_user_id}, $p{from_user_id}, $p{from_user_id}, $p{to_user_id}, $offset, PM_RECS_PER_PAGE],
        {error_msg => "Почтовый голубь улетел, но обещал вернуться!"}
	);

	for my $row (@$messages) {
		$row->{dm_msg} = Psy::Text::convert_to_html($row->{dm_msg});
	}

	return $messages;
}

sub dialog_rows_count {
	my ($self, %p) = @_;
	
	my $result = $self->query(qq|
		SELECT COUNT(pm.id) cnt
		FROM personal_messages pm
		WHERE (pm.to_user_id = ? AND pm.from_user_id = ?)
		OR (pm.to_user_id = ? AND pm.from_user_id = ?)
		|,
		[$p{to_user_id}, $p{from_user_id}, $p{from_user_id}, $p{to_user_id}],
        {
			error_msg => "Почтовый голубь улетел, но обещал вернуться!!",
			only_first_row => 1
		}
	);

	return $result->{cnt};
}

sub load_contact_list {
    my ($self, %p) = @_;

    my $contacts = $self->query(qq|
        SELECT
            cl.user cl_user_id,
			u.name cl_user_name,
			SUM(cl.cnt) cl_cnt	
        FROM (
			SELECT
				from_user_id user,
				COUNT(to_user_id) cnt
			FROM personal_messages
			WHERE to_user_id = ?
			GROUP BY from_user_id
		
			UNION
		
			SELECT
				to_user_id user,
				COUNT(from_user_id) cnt
			FROM personal_messages
			WHERE from_user_id = ?
			GROUP BY to_user_id
		) cl 
        LEFT JOIN users u ON u.id = cl.user
        GROUP BY cl.user
		ORDER BY cl_cnt DESC
		|,
		[$self->{user_id}, $self->{user_id}],
        {error_msg => "Почтовый голубь улетел, но обещал вернуться!"}
	);
    
	return $contacts;
}

1;
