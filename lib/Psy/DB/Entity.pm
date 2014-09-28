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

sub _order_by {
	my ($self, $params, $prefix) = @_;

	$params = [$params] unless ref $params eq 'ARRAY';

	my @fields;
	foreach my $p (@$params) {
		if (ref $p eq 'HASH') {
			my ($direct) = keys %$p;
			my ($field)  = values %$p;
			unless ($field =~ /\w\.\w/) {
				$field = $self->_table_name. '.'. $field;
			}
			push @fields, sprintf('%s%s %s', $prefix || '', $field, uc($direct));
		}
		else {
			push @fields, $p;
		}
	}
	return ' ORDER BY '. join ', ', @fields;
}

sub list_by_id {
	my ($self, $id_list, %params) = @_;

	$id_list = [$id_list] unless ref $id_list;
	die 'id list must be array ref' unless ref $id_list eq 'ARRAY';
	die 'wrong id list' if grep {/\D/} @$id_list;

	my $select = '*';
	my $from   = 'FROM '. $self->_table_name;
	my $order  = $params{order_by} 
		? $self->_order_by($params{order_by}) 
		: '';

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
				$from .= sprintf ' LEFT JOIN %s ON %s.%s = %s.%s', 
					$table, $table, $rel->{$table}->{pkey} || 'id', $self->_table_name, $rel->{$table}->{fkey};
			}
			elsif ($key eq 'me') {
				$table = $self->_table_name;
			}
			else {
				die 'wrong table name: '. $key;
			}

			foreach my $field (@$value) {
				my $alias;
				my $field_name;
				if (ref $field eq 'HASH') {
					($field_name) = keys   %$field;
					($alias)      = values %$field;
					die 'alias not defined'      unless $alias;
					die 'field_name not defined' unless $field_name;

					if (ref $alias eq 'HASH') {
						my ($post_process_sub) = values %$alias;
						die 'post process sub not defined' unless $post_process_sub;
						
						($alias) = keys %$alias;
						die 'alias not defined' unless $alias;
						
						$post_process{$field_prefix.$alias} = $post_process_sub;
					}
				}
				else {
					$alias = $field;
					$field_name = $field;
				}
				#webug [ $field, $field_name ];
				push @fields, sprintf('%s.%s %s', $table, $field_name, $field_prefix. $alias);
			}
		}
		$select = join ', ', @fields;
	}
	
	my $result = $self->query(
		'SELECT '. $select. ' '. $from. 
		' WHERE '. $self->_table_name.'.id IN ('. join(', ', @$id_list). ')'.
		$order,
		[],
		{ debug => 0 }
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
	my ($self, $cond, %p) = @_;

	my $q = $self->_construct_sql($cond, %p);
	
	my $order = $p{order_by} 
		? $self->_order_by($p{order_by}) 
		: '';
	
	return $self->query(
		'SELECT '. $self->_table_name. '.id '
			. $q->{sql}->{from}
			. $q->{sql}->{where}
			. $order
			. $q->{sql}->{limit},
		
		$q->{params},
		
		{ 
			list_field => 'id', 
			debug      => 0 
		} 
	);
}

sub list_by_cond {
	my ($self, $cond, %params) = @_;

	my $id_list = $self->get_id_by_cond($cond, %params);
	return scalar @$id_list
		? $self->list_by_id($id_list, %params)
		: [];
}

sub _construct_sql {
	my ($self, $cond, %p) = @_;

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

	my $limit = '';
	if ($p{limit}) {
		if (ref $p{limit} ne 'ARRAY') {
			$p{limit} = [ $p{limit} ];
		}
		$limit = ' LIMIT '. join ', ', @{$p{limit}};
	}
	return {
		sql => { 
			from  => $join, 
			where => $where_sql,
			limit => $limit
		},
		params => \@where_params
	};
}

sub nice_date {
	my ($timestamp) = @_;

	return Date::unix_time_to_ymdhms(
		Date::ymdhms_to_unix_time($timestamp), 
		'%Y-%m-%d'
	); 
}

1;
