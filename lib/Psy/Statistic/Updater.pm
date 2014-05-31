package Psy::Statistic::Updater;

use strict;
use warnings;
use utf8;

use base 'Psy::DB';
#
# updater constructor
#
sub constructor {
	my ($class, %p) = @_;

	my $self = Psy::DB::connect($class);
	
	$self->{table_name}         = $p{table_name};
	$self->{key_name}           = $p{key_name};
	$self->{key_value}          = $p{key_value};
	$self->{objects_table_name} = $p{objects_table_name};

	return $self;
}

sub add_object {
	my ($self, $key_value) = @_;

	$self->query(
		sprintf(
			'INSERT IGNORE INTO %s SET %s = %s', 
			$self->{table_name},
			$self->{key_name},
			$key_value || $self->{key_value}
		)
	);
};

sub _set_queries {
	my ($self) = @_;
	$self->{queries} = {};
}

sub queries {
	my ($self) = @_;
	$self->_set_queries unless defined $self->{queries};

	return $self->{queries};
}

sub _init_objects {
	my ($self) = @_;
	$self->query(
		sprintf(
			'INSERT IGNORE INTO %s (%s)	SELECT id FROM %s', 
			$self->{table_name},
			$self->{key_name},
			$self->{objects_table_name}
		)
	);
}

sub _set_all {
	my ($self) = @_;

	$self->_init_objects;

	while (my ($var_name, $query) = each %{$self->queries}) {
		$self->query(
			sprintf('UPDATE LOW_PRIORITY %s SET %s = (%s)', 
				$self->{table_name}, 
				$var_name, 
				sprintf($query, $self->{table_name}. '.'. $self->{key_name})
			)
		);
	}
}

sub increment {
	my ($self, $var_name, $value) = @_;

	$self->query(
		sprintf(
			'UPDATE LOW_PRIORITY %s SET %s = %s + %d WHERE %s = %d',
			$self->{table_name},
			$var_name,
			$var_name,
			$value || 1,
			$self->{key_name},
			$self->{key_value}
		)
	);
}

sub set {
	my ($self, $var_name) = @_;
	
	$self->query(
		sprintf(
			'UPDATE LOW_PRIORITY %s SET %s = (%s) WHERE %s = ?', 
			$self->{table_name}, 
			$var_name, 
			sprintf($self->queries->{$var_name}, '?'),
			$self->{key_name}
		),
		[$self->{key_value}, $self->{key_value}]
	);
}

1;
