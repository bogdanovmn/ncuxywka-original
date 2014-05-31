#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin.'/../../lib';
use lib $FindBin::Bin.'/../../conf';

use Psy::Bot;
use CronLogger;
use Data::Dumper;

my $logger = CronLogger->new(
	file_name => $FindBin::Bin. "/../../logs/cron_bot_creo_comment.log",
	stdout => 1
);

$logger->say("----- Start -----");
$logger->say("Wake up bot...");
my $bot = Psy::Bot->wakeup;

$logger->say("Post creo comment...");
$bot->post_creo_comment;

$logger->finish;

exit;
