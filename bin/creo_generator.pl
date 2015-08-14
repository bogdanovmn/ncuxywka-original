#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin.'/../lib';
use lib $FindBin::Bin.'/../conf';

use Psy::Text::Generator::Creo;
use Utils;


my $gen = Psy::Text::Generator::Creo->new(
	user_id => 32
);

debug $gen->create;
