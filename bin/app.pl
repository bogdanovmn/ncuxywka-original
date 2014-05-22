#!/usr/bin/env perl
use Dancer;
use PsyApp;

sub Carp::shortmess_heavy {}
sub Carp::longmess_heavy {}

dance;
