#!/usr/bin/perl -w
# Copyright 2007 Sebastian Stumpf <mail@sebastianstumpf.de>
# vim: set sw=4 ts=4
use strict;
use warnings;
use lib qw(lib);
use Test::Simple tests => 1;
use WWW::Dattebayo;

my $db = WWW::Dattebayo->new();
ok(defined($db));
