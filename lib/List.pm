package LIST;

use strict;
use warnings;


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
1; # eof
#
