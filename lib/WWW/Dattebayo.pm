#!/usr/bin/perl -w
# Copyright 2007 Sebastian Stumpf <mail@sebastianstumpf.de>
# vim: set sw=4 ts=4
package WWW::Dattebayo;
use strict;
use warnings;
use base qw(LWP::UserAgent);
use HTML::TokeParser;

our $VERSION = '0.0.2';

sub new
{
	my $class = shift;
	my $self = { @_ };

	$self->{'Agent'}	||= 'Mozilla/5.0';
	$self->{'Torrent'}	||= 'http://www.dattebayo.com/t/';
	bless $self, $class;

	$self->agent($self->{'Agent'});

	return $self;
}

sub getdoc
{
	my $self = shift;
	my $url = shift;
	my $get = $self->get($url);

	unless($get->is_success())
	{
		eval { die $get->status_line() };
		return undef;
	}

	return $get->content();
}

sub list
{
	my $self = shift;
	my $doc = $self->getdoc($self->{'Torrent'}) || die $@;
	my $parser = HTML::TokeParser->new(\$doc);

	my $data = {};
	my ($current, $file, $attr);

	while(my $t = $parser->get_token())
	{
		if($t->[0] eq 'S' && $t->[1] eq 'a' && $t->[2] && $t->[2]->{'name'} && $t->[2]->{'class'} eq 'dummy')
		{
			$current = $t->[2]->{'name'};
		}
		elsif($t->[0] eq 'S' && $t->[1] eq 'a' && $t->[2] && $t->[2]->{'title'} && $t->[2]->{'href'} =~ m#.torrent\z#)
		{
			next unless $current;
			$file = $t->[2]->{'title'};
			$data->{$current}->{$file}->{'href'} = $t->[2]->{'href'};
		}
		elsif($t->[0] eq 'S' && $t->[1] eq 'td' && $t->[2] && $t->[2]->{'class'} && $t->[2]->{'class'} ne 'file')
		{
			$attr = $t->[2]->{'class'};
		}
		elsif($t->[0] eq 'T' && $attr)
		{
			next unless $current && $file;
			$data->{$current}->{$file}->{$attr} = $t->[1];
			$attr = undef;
		}
	}

	return $data;
}

return 1;
__END__

=head1 NAME

WWW::Dattebayo - Perl module for checking the Dattebayo tracker

=head1 SYNOPSIS

  use WWW::Dattebayo;
  use Data::Dumper;
  my $db = WWW::Dattebayo->new();
  my $list = $db->list();
  print Dumper $list;

=head1 DESCRIPTION

This module allows you to check Dattebayos torrent tracker using Perl. Its 
list() method will return the complete list of files and their attributes.

WWW::Dattebayo uses LWP::UserAgent as its base class. So you can use all methods
from LWP::UserAgent on WWW::Dattebayo. This allows you to handle your proxies, etc...
directly via LWP.

PLEASE NOTE: Thou shalt not request the list() method every minute. Dattebayo is a large
fansub group and they take the internet seriously. Their release schedule is really simple.
So it should be fair enough if you call the method only when you B<need> it.

=head1 Methods

=over 4

=item * $db->list()

This method will return the a hashref containing all files and attributes listed on 
http://www.dattebayo.com/t/. Make sure to read the note above.

=back

=head1 AUTHOR

Sebastian Stumpf E<lt>sepp@perlhacker.orgE<gt>

=head1 COPYRIGHT

Copyright 2007 Sebastian Stumpf.   All rights reserved.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

LWP::UserAgent(3), HTML::TokeParser(3).

=cut
