#!/usr/bin/env perl

use warnings;
use strict;

use Data::Dumper;
use Pod::Usage;
use Getopt::Long;

use Flickr::Tools::Cameras;
use 5.010;

my $cli_args = {};

GetOptions (
            $cli_args,
            'config=s',
            'brand=s',
            'list_brands',
            'help',
            'man',
            'usage',
           );

if (   $cli_args->{'help'}
    or $cli_args->{'usage'}
    or $cli_args->{'man'}
    or !$cli_args->{'config'} )
{

    pod2usage( { -verbose => 2 } );

}


my $tool = Flickr::Tools::Cameras->new( { config_file => $cli_args->{config} } );

if ( $tool->connects ) {

    my $makers = $tool->getBrands;

    if ( $cli_args->{list_brands} ) {

        print Dumper($makers);

    }

    if ( defined( $makers->{ $cli_args->{brand} } )
        and !$cli_args->{list_brands} )
    {

        my $models = $tool->getBrandModels( { Brand =>, $cli_args->{brand} } );
        print Dumper($models);

    }
    else {

        if ( !$cli_args->{list_brands} ) {

            say 'The brand: ', $cli_args->{brand}, ' was not found.';

        }

    }
}
else {

    say 'The tool failed to connect';

}

exit;

__END__

=pod

=head1 NAME

flickr_cameras.pl - example use of Flickr::Tools::Cameras to query Flickr.

=head1 SYNOPSIS

C<flickr_cameras.pl --config=Config-File_to_use [--list_brands  --brand=Brandname]>

=head1 OPTIONS

=head2 Required:
B< >

=over 5

=item  B<--config> points the stored Flickr config file

=back

=head2 Optional:


B< >


=over 5

=item  B<--list_brands>   Data::Dumper dump of the brands Flickr knows about.

B< >

=item  B<--brand=Brandname>  Data::Dumper dump of the models of Brandname cameras
       the Flickr knows about.

B< >

=item  B<--help> as expected

=item  B<--usage>

=item  B<--man>

=back


=head1 DESCRIPTION

This example just uses the Flickr::Tools::Cameras module to
display information about cameras and camera brands that
Flickr knows about.

=head1 AUTHOR

Louis B. Moore C<< <lbmoore@cpan.org> >>.

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2015, Louis B. Moore C<< <lbmoore@cpan.org> >>.


This program is released under the Artistic License 2.0 by The Perl Foundation.

