#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin.'/../../lib';
use lib $FindBin::Bin.'/../../conf';

use Psy::DB;
use CronLogger;

use constant DAYS_TO_EXPIRE => 14;

my $logger = CronLogger->new(
	file_name => $FindBin::Bin."/../../logs/clear_sessions.log",
	stdout => 1
);

$logger->say("----- Start -----");
$logger->say("Connect to DB...");
my $db = Psy::DB->connect;

my $count = $db->query(
	"SELECT COUNT(1) cnt FROM session WHERE last_active < NOW() - INTERVAL ? DAY",
	[ DAYS_TO_EXPIRE ]
)->[0]->{cnt}; 

$logger->say("Delete $count sessions...");

$db->query(
	"DELETE FROM session WHERE last_active < NOW() - INTERVAL ? DAY",
	[ DAYS_TO_EXPIRE ]
);

$logger->finish;

exit;
