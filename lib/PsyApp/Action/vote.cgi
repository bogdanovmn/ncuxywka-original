#!/usr/bin/perl

use strict;
use warnings;

use lib 'inc';

use Psy;
use Psy::Errors;
use Psy::Navigation;

use CGI;

my $cgi = CGI->new;

error("Совсем охуели? =)") if $ENV{REQUEST_METHOD} ne 'POST';

my $action = $cgi->param('action') || 'bot';
my $creo_id = $cgi->param('creo_id');
my $vote_id = $cgi->param('vote_id');

my $psy = Psy->enter;

error("Может вы заблудились?") if (!$creo_id or !$vote_id);
$psy->vote(creo_id => $creo_id, vote_id => $vote_id);

goto_back();
