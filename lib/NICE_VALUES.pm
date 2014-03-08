#
# Модуль содержит функции приведения произвольных значений 
# в более читабельный вид
#
package NICE_VALUES;

use strict;
use warnings;

require Exporter;
our @ISA = qw| Exporter |;
our @EXPORT = (qw|
	full_time
	full_traffic
	full_value
	short_time
	short_traffic
	short_value
	short_number
|);
#
# Для интерпертации числа секунд
#
my %time_grade = (
	3600*24	=> " Д.",
	3600	=> " В.",
	60		=> " Л.",
	1		=> " Я."
);
#
# Для интерпретации числа байт
#
my %traffic_grade = (
	1024**4	=> "T",
	1024**3	=> "G",
	1024**2	=> "M",
	1024	=> "K",
	1		=> " Bytes"
);
#
# Для интерпретации числа
#
my %number_grade = (
	1000**3	=> "B",
	1000**2	=> "M",
	1000	=> "K",
	1		=> ""
);
#
# Абстрактная функция приведения значения 
# Параметры: 
# * $grade_table - хэш с размерностями, где ключ является величиной 
# размерности, а значение является обозначением размерности
# * $total - величина для приведения к нужному нам виду
#
sub full_value {
	my ($grade_table, $total) = @_;
	$total ||= 0;
	my $result = "";
	my @grades = sort { $b <=> $a } keys %$grade_table;
	for my $grade (@grades) {
		my $value = int($total / $grade);
		if ($value) {
			$total = $total % $grade;
			$result .= $value. $grade_table->{$grade}. " ";
		}
	}

	unless ($result) {
		$result = "0". $grade_table->{$grades[$#grades]};
	} 
	else {
		chop $result;
	}

	return $result;
}
#
# Обертка для full_value по времени
#
sub full_time {
	my $seconds = shift;

	return full_value(\%time_grade, $seconds);
}
#
# Обертка для full_value по трафику
#
sub full_traffic {
	my $bytes = shift;
	
	return full_value(\%traffic_grade, $bytes);
}
#
# Приводит заданное значение только к наибольшей величине
#
sub short_value {
	my ($grade_table, $total) = @_;
	$total ||= 0;
	my $result = "";
	my @grades = sort { $b <=> $a } keys %$grade_table;
	for my $grade (@grades) {
		my $value = sprintf("%.2f", $total / $grade);
		my $fraction = $total % $grade;
		if (int $value) {
			$value = int $value if ($fraction == 0);
			$result = $value. $grade_table->{$grade};
			last;
		}
	}

	unless ($result) {
		$result = "0". $grade_table->{$grades[$#grades]};
	} 

	return $result;
}	
#
# Обертка для short_value по времени
#
sub short_time {
	my $seconds = shift;

	return short_value(\%time_grade, $seconds);
}
#
# Обертка для short_value по трафику
#
sub short_traffic {
	my $bytes = shift;
	
	return short_value(\%traffic_grade, $bytes);
}
#
# Обертка для short_value по числам
#
sub short_number {
	my $number = shift;
	
	return short_value(\%number_grade, $number);
}
#
# The End
#
1;

