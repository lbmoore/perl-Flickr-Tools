package Flickr::Testing;

use strict;
use warnings;
use Carp;

=head1 NAME

Flickr::Testing - Private module for use with the tests.

=head1 VERSION

Version 1.21

=cut

our $VERSION = '1.21';

=head1 SYNOPSIS

    use Flickr::Testing;

    print "\nFlickr::Testing < 1.0 is not compatible with Flickr::Tools >= 1.0\n";

This is an internal module, you don't want to use it and shouldn't depend on its existence.
This module might very well go away in the future.

=cut

=head1 FUNCTIONS

=head2 setup


Don't use this or expect it to exist in the future.

=cut

sub setup {

    croak 'Flickr::Photo < 1.0 is not compatible with Flickr::Tools >= 1.0';

}


1; # End of Flickr::Testing


__END__
