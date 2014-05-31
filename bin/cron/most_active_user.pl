#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin.'/../../lib';
use lib $FindBin::Bin.'/../../conf';

use Psy::DB;
use Psy::Statistic;
use Psy::Auth;
use CronLogger;
use Data::Dumper;

my $logger = CronLogger->new(
	file_name => $FindBin::Bin."/../../logs/cron_most_active_user.log",
	stdout => 1
);

$logger->say("----- Start -----");
$logger->say("Connect to DB...");
my $db = Psy::DB->connect;

$logger->say("Get data about users...");

my $most_active_users          = Psy::Statistic::most_active_users($db, limit => 3);
my $most_active_user_id        = $most_active_users->[0]->{au_id};
my $second_most_active_user_id = $most_active_users->[1]->{au_id};

$logger->say("UserId = ". $most_active_user_id);
$logger->say("Second UserId = ". $second_most_active_user_id);

$logger->say("Get prev UserId...");
my $prev_user = $db->query(qq|
	SELECT user_id id FROM user_group 
	WHERE group_id = 3
	AND update_time > NOW() - INTERVAL 140 DAY
	|,
	[],
	{ only_field => "id" }
);
$logger->say("Prev UserId = ". $prev_user);


if (5 eq $most_active_user_id) {
	$logger->say("User id Gogi...! Change with Second UserId :)");
	$most_active_user_id = $second_most_active_user_id;
}
elsif ($prev_user eq $most_active_user_id) {
	$logger->say("Prev UserId == UserId! Change with Second UserId :)");
	$most_active_user_id = $second_most_active_user_id;
}

$logger->say("Delete old records...");
$db->query(qq|
	DELETE FROM user_group 
	WHERE group_id = 3
	AND update_time > NOW() - INTERVAL 140 DAY
|);

$logger->say("Insert group link for user #". $most_active_user_id. "...");
$db->query(qq|
	INSERT INTO user_group
	SET user_id = ?,
		group_id = 3
	|,
	[$most_active_user_id], {console => 1}
);

$logger->finish;

exit;
