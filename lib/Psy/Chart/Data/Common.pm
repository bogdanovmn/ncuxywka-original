package Psy::Chart::Data::Common;

use strict;
use warnings;
use utf8;

use Psy::Errors;

#
# Result data type
#
use constant RESULT_TYPE_JSON => 1;
use constant RESULT_TYPE_HASH => 2;
#
# Intervals
#
use constant INTERVAL_TYPE_TOTAL => 0;
use constant INTERVAL_TYPE_MONTH => 1;
use constant INTERVAL_TYPE_LAST_MONTH => 2;
use constant INTERVAL_TYPE_YEAR => 3;

use constant BEGIN_DATE => "'2010-03-01'";

use base 'Psy::DB';
#
# User object constructor
#
sub constructor {
	my ($class, %p) = @_;

	my $self = Psy::DB::connect($class);
	$self->{date_format} = "'%Y-%m'";
	$self->{interval_begin} = BEGIN_DATE;
	$self->{interval_end} = "NOW()";
	$self->{result_type} = $p{result_type} || RESULT_TYPE_JSON;
	
	return $self;
}

sub _group_to_json {
	my $list = shift;
	my $result = '[';
	for my $l (@$list) {
		$result .= sprintf('[%d000, %d], ', $l->{k}, $l->{v});
	}
	$result .= ']';

	return $result;
}

sub _group_to_hash {
	my $list = shift;
	my $result = {};
	for my $l (@$list) {
		$result->{$l->{k}} = $l->{v};
	}
	return $result;
}

sub _group {
	my ($self, $list) = @_;

	if ($self->{result_type} eq RESULT_TYPE_HASH) {
		return _group_to_hash($list);
	}
	elsif ($self->{result_type} eq RESULT_TYPE_JSON) {
		return _group_to_json($list);
	}
}

sub set_result_type {
	my ($self, $type) = @_;
	$self->{result_type} = $type;
}

sub _main_sql {
    my ($self, $sub_sql, $params, $settings) = @_;

    my $list = $self->query(qq|
        SELECT UNIX_TIMESTAMP(CONCAT(cal.str_value, '-01')) k, IFNULL(data.v, 0) v 
		FROM ($sub_sql) data
		RIGHT JOIN ( 
			SELECT DISTINCT DATE_FORMAT(value, $self->{date_format}) str_value 
			FROM calendar 
			WHERE value BETWEEN $self->{interval_begin} AND $self->{interval_end}
		) cal ON cal.str_value = data.str_date
		|,
		$params,
		$settings
	);
	return $self->_group($list);
}

sub new_users {
    my ($self, %p) = @_;

	return $self->_main_sql(qq|
		SELECT
			DATE_FORMAT(u.reg_date, $self->{date_format}) str_date, COUNT(*) v
		FROM 
			users u
		GROUP BY 
			DATE_FORMAT(u.reg_date, $self->{date_format})
		|,
		[],
		{error_msg => "users chart"}
	);
}

sub creos {
    my ($self, %p) = @_;

	my $where_user_id = "";
	my @params = ();
	if (defined $p{user_id}) {
		$where_user_id = 'AND user_id = ?';
		push @params, $p{user_id};
	}

	return $self->_main_sql(qq|
		SELECT DATE_FORMAT(post_date, $self->{date_format}) str_date, COUNT(id) v
		FROM creo
		WHERE type IN (0, 1)
		$where_user_id
		GROUP BY DATE_FORMAT(post_date, $self->{date_format})
		|,
		\@params,
		{error_msg => "creos chart"}
	);
}

sub comments {
    my ($self, %p) = @_;

	my $where_user_id = "";
	my @params = ();
	if (defined $p{user_id}) {
		$where_user_id = 'WHERE user_id = ?';
		push @params, $p{user_id};
	}

	return $self->_main_sql(qq|
		SELECT DATE_FORMAT(post_date, $self->{date_format}) str_date, COUNT(*) v
		FROM comments
		$where_user_id
		GROUP BY DATE_FORMAT(post_date, $self->{date_format})
		|,
		\@params,
		{error_msg => "comments chart"}
	);
}

sub spec_comments {
    my ($self, %p) = @_;

	my $where_user_id = "";
	my @params = ();
	if (defined $p{user_id}) {
		$where_user_id = 'WHERE user_id = ?';
		push @params, $p{user_id};
	}

	return $self->_main_sql(qq|
		SELECT DATE_FORMAT(post_date, $self->{date_format}) str_date, COUNT(*) v
		FROM spec_comments
		$where_user_id
		GROUP BY DATE_FORMAT(post_date, $self->{date_format})
		|,
		\@params,
		{error_msg => "spec_comments chart"}
	);
}

sub gb_comments {
    my ($self, %p) = @_;

	my $where_user_id = "";
	my @params = ();
	if (defined $p{user_id}) {
		$where_user_id = 'WHERE user_id = ?';
		push @params, $p{user_id};
	}

	return $self->_main_sql(qq|
		SELECT DATE_FORMAT(post_date, $self->{date_format}) str_date, COUNT(*) v
		FROM gb
		$where_user_id
		GROUP BY DATE_FORMAT(post_date, $self->{date_format})
		|,
		\@params,
		{error_msg => "gb chart"}
	);
}
sub votes {
    my ($self, %p) = @_;

	my $where_user_id = "";
	my @params = ();
	if (defined $p{user_id}) {
		$where_user_id = 'WHERE user_id = ?';
		push @params, $p{user_id};
	}

	return $self->_main_sql(qq|
		SELECT DATE_FORMAT(date, $self->{date_format}) str_date, COUNT(*) v
		FROM vote
		$where_user_id
		GROUP BY DATE_FORMAT(date, $self->{date_format})
		|,
		\@params,
		{error_msg => "votes chart"}
	);
}

sub user_activity {
    my ($self, $user_id) = @_;

	$self->set_result_type(RESULT_TYPE_HASH);
	my $creos         = $self->creos(user_id => $user_id);
	my $comments      = $self->comments(user_id => $user_id);
	my $spec_comments = $self->spec_comments(user_id => $user_id);
	my $gb_comments   = $self->gb_comments(user_id => $user_id);
	my $votes         = $self->votes(user_id => $user_id);

	my $total = [];
	while (my ($k, $v) = each %$creos) {
		my $value = $v*8 + $comments->{$k}*3 + ($gb_comments->{$k} + $spec_comments->{$k})*2 + $votes->{$k};
		push @$total, {k => $k, v => $value};
	}

	$total = [sort { $a->{k} <=> $b->{k} } @$total];

	$self->set_result_type(RESULT_TYPE_JSON);
	return $self->_group($total);
}

1;
