package Psy::Search;

use strict;
use warnings;

sub _convert_string_to_boolean_search {
	my $string = shift;
	return join(" ", map { $_ = "+".$_; } split(/\s+/, $string));
}

sub creo_search {
    my ($self, %p) = @_;

	return [] unless $p{text};

    my $list = $self->query(qq|
        SELECT
            c.id cl_id,
            c.type cl_type,
			CASE c.type WHEN 1 THEN 1 ELSE 0 END cl_quarantine,
            c.user_id cl_user_id,
            IFNULL(u.name, c.alias) cl_alias,
            c.title cl_title,
            CASE DATE_FORMAT(c.post_date, '%Y%m%d') 
				WHEN DATE_FORMAT(NOW(), '%Y%m%d') THEN 'Сегодня'
				WHEN DATE_FORMAT(NOW() - INTERVAL 1 DAY, '%Y%m%d') THEN 'Вчера'
				ELSE DATE_FORMAT(c.post_date, '%Y-%m-%d') 
			END cl_post_date
        FROM creo c
        LEFT JOIN users u ON u.id = c.user_id
		LEFT JOIN user_group ug ON ug.user_id = u.id
        WHERE
            IFNULL(ug.group_id, 0) <> ?
            AND c.type IN (0, 1)
			AND MATCH(c.title, c.body) AGAINST (? IN BOOLEAN MODE)

        GROUP BY
            c.id
        ORDER BY
            c.post_date DESC
		LIMIT 50
		|,
		[Psy::G_PLAGIARIST, _convert_string_to_boolean_search($p{text})],
		{error_msg => "Список анализов утонул в сливном бочке!"}
	);

    return $list;
}

1;
