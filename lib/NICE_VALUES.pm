#
# нПДХМШ УПДЕТЦЙФ ЖХОЛГЙЙ РТЙЧЕДЕОЙС РТПЙЪЧПМШОЩИ ЪОБЮЕОЙК 
# Ч ВПМЕЕ ЮЙФБВЕМШОЩК ЧЙД
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
# дМС ЙОФЕТРЕТФБГЙЙ ЮЙУМБ УЕЛХОД
#
my %time_grade = (
	3600*24	=> " д.",
	3600	=> " ч.",
	60		=> " м.",
	1		=> " с."
);
#
# дМС ЙОФЕТРТЕФБГЙЙ ЮЙУМБ ВБКФ
#
my %traffic_grade = (
	1024**4	=> "T",
	1024**3	=> "G",
	1024**2	=> "M",
	1024	=> "K",
	1		=> " Bytes"
);
#
# дМС ЙОФЕТРТЕФБГЙЙ ЮЙУМБ
#
my %number_grade = (
	1000**3	=> "B",
	1000**2	=> "M",
	1000	=> "K",
	1		=> ""
);
#
# бВУФТБЛФОБС ЖХОЛГЙС РТЙЧЕДЕОЙС ЪОБЮЕОЙС 
# рБТБНЕФТЩ: 
# * $grade_table - ИЬЫ У ТБЪНЕТОПУФСНЙ, ЗДЕ ЛМАЮ СЧМСЕФУС ЧЕМЙЮЙОПК 
# ТБЪНЕТОПУФЙ, Б ЪОБЮЕОЙЕ СЧМСЕФУС ПВПЪОБЮЕОЙЕН ТБЪНЕТОПУФЙ
# * $total - ЧЕМЙЮЙОБ ДМС РТЙЧЕДЕОЙС Л ОХЦОПНХ ОБН ЧЙДХ
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
# пВЕТФЛБ ДМС full_value РП ЧТЕНЕОЙ
#
sub full_time {
	my $seconds = shift;

	return full_value(\%time_grade, $seconds);
}
#
# пВЕТФЛБ ДМС full_value РП ФТБЖЙЛХ
#
sub full_traffic {
	my $bytes = shift;
	
	return full_value(\%traffic_grade, $bytes);
}
#
# рТЙЧПДЙФ ЪБДБООПЕ ЪОБЮЕОЙЕ ФПМШЛП Л ОБЙВПМШЫЕК ЧЕМЙЮЙОЕ
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
# пВЕТФЛБ ДМС short_value РП ЧТЕНЕОЙ
#
sub short_time {
	my $seconds = shift;

	return short_value(\%time_grade, $seconds);
}
#
# пВЕТФЛБ ДМС short_value РП ФТБЖЙЛХ
#
sub short_traffic {
	my $bytes = shift;
	
	return short_value(\%traffic_grade, $bytes);
}
#
# пВЕТФЛБ ДМС short_value РП ЮЙУМБН
#
sub short_number {
	my $number = shift;
	
	return short_value(\%number_grade, $number);
}
#
# The End
#
1;

