package Psy::Search;

use strict;
use warnings;
use utf8;


sub _convert_string_to_boolean_search {
	my ($string) = @_;

	return join(" ", map { $_ = "+".$_; } split(/\s+/, $string));
}

sub creo_search {
    my ($self, %p) = @_;

	return [] unless $p{text};

	my $users_to_exclude = $self->users_to_exclude;
	my $where_users_to_exclude = $users_to_exclude
		? sprintf('AND c.user_id NOT IN (%s)', join ',', @$users_to_exclude)
		: '';

	my $where_creo_type = sprintf(
		'AND c.type IN (%s)', 
			join ',', @{$p{type} || [Psy::Creo::CT_CREO, Psy::Creo::CT_QUARANTINE]}
	);
	
	my $id_list = $self->query(qq|
        SELECT ct.creo_id
        FROM   creo_text ct
		JOIN   creo c ON c.id = ct.creo_id
        WHERE  MATCH(ct.title, ct.body) AGAINST (? IN BOOLEAN MODE)
		$where_creo_type
		$where_users_to_exclude
		LIMIT  25
		|,
		[_convert_string_to_boolean_search($p{text})],
		{ list_field => 'creo_id' }
	);
	
	my $where = sprintf 'WHERE c.id IN (%s)', join(',', @$id_list);
    return $id_list
		? $self->query(qq|
			SELECT
				c.id      cl_id,
				c.user_id cl_user_id,
				u.name    cl_alias,
				c.title   cl_title,
				
				CASE c.type WHEN 1 THEN 1 ELSE 0 END cl_quarantine,
				
				CASE DATE_FORMAT(c.post_date, '%Y%m%d') 
					WHEN DATE_FORMAT(NOW(), '%Y%m%d') THEN 'Сегодня'
					WHEN DATE_FORMAT(NOW() - INTERVAL 1 DAY, '%Y%m%d') THEN 'Вчера'
					ELSE DATE_FORMAT(c.post_date, '%Y-%m-%d') 
				END cl_post_date

			FROM creo c
			JOIN users u ON u.id = c.user_id
			
			$where

			ORDER BY c.post_date DESC
			|,
		)
		: [];
}

1;
