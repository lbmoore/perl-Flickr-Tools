package Flickr::Tools;

use strict;

=head1 NAME

Flickr::Tools - Private module to aid in migration into Flickr::API.

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';

=head1 SYNOPSIS

This is an internal module, you don't want to use it and shouldn't depend on its existance.

=cut

=head1 FUNCTIONS

=head2 new

Don't use this or expect it to exist in the future.

=cut

sub new {

    my $class = shift;
    my $params = shift;

    my $self = $params;
    bless $self, $class;

 return $self;

}

1;
