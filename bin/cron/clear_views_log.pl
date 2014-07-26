#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin.'/../../lib';
use lib $FindBin::Bin.'/../../conf';

use Psy::DB;
use CronLogger;

my $logger = CronLogger->new(
	file_name => $FindBin::Bin."/../../logs/clear_views_log.log",
	stdout => 1
);

$logger->say("----- Start -----");
$logger->say("Connect to DB...");
my $db = Psy::DB->connect;

$logger->say("Get Bot ip...");

my $bot_ips = $db->query(q|
	SELECT DISTINCT ip FROM views_log WHERE user_agent LIKE '%bot%' OR user_agent LIKE '%spider%'
|);

$logger->say("Total ips: ". scalar @$bot_ips);
foreach my $ip_data (@$bot_ips) {
	my $ip = $ip_data->{ip};
	my $count = $db->query("SELECT COUNT(1) cnt FROM views_log WHERE ip = '$ip'")->[0]->{cnt}; 
	$logger->say("Delete $count views from '$ip'...");
	$db->query(qq|
		DELETE FROM views_log WHERE ip = ?
		|,
		[ $ip ]
	);
}

$logger->finish;

exit;
