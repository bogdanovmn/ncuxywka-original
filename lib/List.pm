package List;

use strict;
use warnings;
use utf8;

sub rand_swap_elements {
	my ($list, $count) = @_;
	$count = $count || 1;

	my @index_list = (0..@$list - 1);
	for (my $i = 0; $i < $count;  $i++) {
		swap_elements($list, random_element(@index_list), random_element(@index_list));
	}
}

sub swap_elements {
	my ($list, $i1, $i2) = @_;
	
	my $element1 = $list->[$i1];
	$list->[$i1] = $list->[$i2];
	$list->[$i2] = $element1;
}

sub random_element {
	return @_[int rand @_];
}

sub random_element_index {
	my $list = shift;
	return int rand @$list;
}

#
# Функция возвращает N случайных неповторяющихся
# элементов списка 
# Параметры:
# source - ссылка на исходный список
# count  - количество элементов в результирующем списке
#
sub rand_list {
	my (%p) = @_;

	my $list_size = @{$p{source}};
	#
	# Если количество результирующих элементов не задано
	# или количество элементов исходного списка меньше чем число 
	# результирующих элементов - возвращаем список такой же длины 
	# что и исходный список
	#
	$p{count} = $list_size if (not defined $p{count} or $list_size < $p{count}); 
	
	my @rand_elements = ();
	for (my $i = 0; $i < $p{count}; $i++) {
		my $rand_element_index = int(rand($list_size - 1));
		push @rand_elements, $p{source}->[$rand_element_index];
		#
		# Меняем местами найденый случайный элемент с последним
		# элементом списка
		#
		swap_elements($p{source}, $rand_element_index, $list_size - 1);
		#
		# Виртуально сокращаем размер списка, чтобы исключить
		# найденый элемент из последующего поиска
		#
		$list_size --;
	}
	return \@rand_elements;
}

sub random_numbers {
	my ($x, $y, $n) = @_;

	my %result;
	my $numbers = 0;
	my $iterations = 0;
	while ($numbers < $n or $iterations > 2*$n) {
		my $number = int(rand($y - $x + 1)) + $x;
		unless (exists $result{$number}) {
			$numbers++;
			$result{$number} = undef;
		}
	}
	return [ keys %result ];
}

#
1; # eof
#
