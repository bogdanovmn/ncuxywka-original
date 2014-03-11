package Psy::Admin::Info;

use strict;
use warnings;

use NICE_VALUES;

#
# Votes rank titles
#
my %VOTES_RANK_TITLES = (
	1 => 'Психоз!',
	2 => 'Шизофрения',
	3 => 'паФрейду',
	4 => 'Параноя',
	5 => 'Лоботомию!'
);

sub creo_votes {
    my ($self, $creo_id) = @_;

    my $votes = $self->query(qq|
		SELECT 
			u.id cv_user_id,
			u.name cv_user_name,
			v.vote cv_vote,
			v.date cv_date,
			UNIX_TIMESTAMP(v.date) cv_timestamp,
			v.ip cv_ip
		FROM vote v
		JOIN users u ON v.user_id = u.id
		WHERE v.creo_id = ?
		ORDER BY v.date
		|,
        [$creo_id],
		{error_msg => "Oops!"}
	);

    for (my $i = 0; $i < scalar @$votes; $i++) {
		$votes->[$i]->{cv_vote} = $VOTES_RANK_TITLES{$votes->[$i]->{cv_vote}}; 
		$votes->[$i]->{cv_delta} = ($i eq 0) 
			? 0 
			: full_time($votes->[$i]->{cv_timestamp} - $votes->[$i - 1]->{cv_timestamp});
    }
	

    return $votes; 
}

sub user_votes {
    my ($self, $user_id) = @_;

    my $votes = $self->query(qq|
		SELECT 
			c.id uv_creo_id,
			c.title uv_creo_title,
			u.name uv_user_name,
			v.vote uv_vote,
			v.date uv_date,
			UNIX_TIMESTAMP(v.date) uv_timestamp,
			v.ip uv_ip
		FROM vote v
		JOIN creo c ON v.creo_id = c.id
		JOIN users u ON u.id = c.user_id
		WHERE v.user_id = ?
		ORDER BY v.date
		|,
        [$user_id],
		{error_msg => "Oops!"}
	);

    for (my $i = 0; $i < scalar @$votes; $i++) {
		$votes->[$i]->{uv_vote} = $VOTES_RANK_TITLES{$votes->[$i]->{uv_vote}}; 
		$votes->[$i]->{uv_delta} = ($i eq 0) 
			? 0 
			: full_time($votes->[$i]->{uv_timestamp} - $votes->[$i - 1]->{uv_timestamp});
    }
	
    return $votes; 
}

1;
