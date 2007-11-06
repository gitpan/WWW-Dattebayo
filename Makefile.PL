#!/usr/bin/perl -w
# Copyright 2007 Sebastian Stumpf <mail@sebastianstumpf.de>
# vim: set sw=4 ts=4
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME			=> 'WWW::Dattebayo',
	VERSION_FROM	=> 'lib/WWW/Dattebayo.pm',
	PREREQ_PM		=> { 
		'LWP::Simple' => 0, 
		'HTML::TokeParser' => 0
	});


