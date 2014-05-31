#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin.'/../../lib';
use lib $FindBin::Bin.'/../../conf';

use Psy::Statistic::User;
use Psy::Statistic::Creo;

Psy::Statistic::User->constructor->_set_all;
Psy::Statistic::Creo->constructor->_set_all;
