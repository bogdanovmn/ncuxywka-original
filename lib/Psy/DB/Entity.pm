package Psy::DB::Entity;

use strict;
use warnings;
use utf8;

use SQL::Abstract;
use Date;
use Utils;

use base 'Psy::DB';


sub _table_name {}
sub _relations  {
	my ($self) = @_;

	return {};
}

sub list_by_id {
	my ($self, $id_list, %params) = @_;

	$id_list = [$id_list] unless ref $id_list;
	die 'id list must be array ref' unless ref $id_list eq 'ARRAY';
	die 'wrong id list' if grep {/\D/} @$id_list;

	my $select = '*';
	my $from   = '';
	my %post_process;

	if ($params{fields}) {
		$select = '';
		my $field_prefix = $params{field_prefix} || '';
		my @fields;
		my $rel = $self->_relations;
		while (my ($key, $value) = each %{$params{fields}}) {
			my $table;
			if (exists $rel->{$key}) {
				$table = $key;
				$from .= sprintf 'LEFT JOIN %s ON %s.%s = %s.id', 
					$table, $table, $rel->{$table}->{key}, $self->_table_name;
			}
			else {
				$table = $self->_table_name;
				$from = 'FROM '. $table;
			}

			foreach my $field (@$value) {
				my $alias = $field;
				if (ref $field eq 'HASH') {
					($alias) = values %$field;
					my ($field_name) = keys   %$field;
					die 'alias not defined'      unless $alias;
					die 'field_name not defined' unless $alias;

					if (ref $alias eq 'HASH') {
						my ($post_process_sub) = values %$alias;
						die 'post process sub not defined' unless $post_process_sub;
						
						($alias) = keys %$alias;
						die 'alias not defined' unless $alias;
						
						$post_process{$field_prefix.$alias} = $post_process_sub;
					}
				}
				push @fields, sprintf('%s.%s %s', $table, $field, $field_prefix. $alias);
			}
		}
		$select = join ', ', @fields;
	}
	
	my $result = $self->query(
		'SELECT '. $select. $from. 
		' WHERE '. $self->_table_name.'.id IN ('. join(', ', @$id_list). ')'
	);
	if (keys %post_process) {
		foreach my $r (@$result) {
			while (my ($field, $sub) = each %post_process) {
				$r->{$field} = $sub->($r->{$field});
			}
		}
	}
	return $result;
}

sub get_id_by_cond {
	my ($self, $cond) = @_;

	my $q = $self->_construct_sql($cond);
	return $self->query(
		'SELECT '. $self->_table_name. '.id '. $q->{sql}->{from}. $q->{sql}->{where},
		$q->{params},
		{ list_field => 'id', debug => 0 } 
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
				' %sJOIN %s ON %s.%s = %s.%s', 
				$join_filter ? '' : 'LEFT ',
				$key, $key, $relations->{$key}->{pkey} || 'id', $self->_table_name, $relations->{$key}->{fkey};
		}
		else {
			$where{$key} = $value
		}
	}
	my $sqla = SQL::Abstract->new;
	my ($where_sql, @where_params) = $sqla->where(\%where);
	return {
		sql    => { from => $join, where => $where_sql },
		params => \@where_params
	};
}

sub nice_date {
	my ($timestamp) = @_;

	return unix_time_to_ymdhms($timestamp, '%Y-%m-%d'); 
}

1;
