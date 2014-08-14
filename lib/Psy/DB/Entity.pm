package Psy::DB::Entity;

use strict;
use warnings;
use utf8;

use SQL::Abstract;
use Date;

use base 'Psy::DB';


sub _table_name {}
sub _relations  {
	my ($self) = @_;

	return {};
}

sub list_by_id {
	my ($self, $id_list) = @_;
}

sub get_id_by_cond {
	my ($self, $cond) = @_;

	my $q = $self->_construct_sql($cond);
	$self->query(
		'SELECT id '. $q->{sql}->{from}. $q->{sql}->{where},
		$q->{params},
		{ list_field => 'id' } 
	);

}

sub _construct_sql {
	my ($self, $cond) = @_;

	my $relations = $self->_relations;
	my $join = sprintf 'FROM %s', $self->_table_name;
	my %where;
	while (my ($key, $value) = each %$cond) {
		if (exists $relations->{$key}) {
			my $join_filter = 0;
			if (ref $value eq 'HASH') {
				while (my ($f, $v) = each %$value) {
					$where{ $key. '.'. $f } = $v;
				}
			}
			else {
				$join_filter = 1;
			}

			$join .= sprintf 
				' %sJOIN %s ON %s.id = %s.%s', 
				$join_filter ? '' : 'LEFT ',
				$key, $key, $self->_table_name, $relations->{$key};
		}
		else {
			$where{$key} = $value
		}
	}
	my $sqla = SQL::Abstract->new;
	my ($where_sql, $where_params) = $sqla->where(\%where);
	return {
		sql    => $join. $where_sql,
		params => $where_params
	};
}

sub nice_date {
	my ($timestamp) = @_;

	return unix_time_to_ymdhms($timestamp, '%Y-%m-%d'); 
}

1;
