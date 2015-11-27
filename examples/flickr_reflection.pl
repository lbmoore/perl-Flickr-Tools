#!/usr/bin/env perl

use warnings;
use strict;

use Data::Dumper;
use Pod::Usage;
use Getopt::Long;

$Data::Dumper::Indent=1;

use Flickr::Tools::Reflection;
use 5.010;

my $cli_args = {};

GetOptions (
            $cli_args,
            'config=s',
            'method=s',
            'list_methods',
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


my $tool = Flickr::Tools::Reflection->new( { config_file => $cli_args->{config} } );

if ( $tool->connects ) {

    my $methods = $tool->getMethods;

    if ( $cli_args->{list_methods} ) {

        print Dumper($methods);

    }

    if ( defined( $methods->{ $cli_args->{method} } )
        and !$cli_args->{list_methods} )
    {

        my $method = $tool->thisMethod( { Method =>, $cli_args->{method} } );
        print Dumper($method);

    }
    else {

        if ( !$cli_args->{list_methods} ) {

            say 'The method: ', $cli_args->{method}, ' was not found.';

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

flickr_reflection.pl - example use of Flickr::Tools::Reflection to query Flickr.

=head1 SYNOPSIS

C<flickr_reflection.pl --config=Config-File_to_use [--list_methods  --method=Methodname]>

=head1 OPTIONS

=head2 Required:
B< >

=over 5

=item  B<--config> points the stored Flickr config file

=back

=head2 Optional:


B< >


=over 5

=item  B<--list_methods>   Data::Dumper dump of the methods Flickr knows about.

B< >

=item  B<--method=Methodname>  Data::Dumper dump of the details of  the Methodname method
       the Flickr knows about.

B< >

=item  B<--help> as expected

=item  B<--usage>

=item  B<--man>

=back


=head1 DESCRIPTION

This example just uses the Flickr::Tools::Reflection module to
display information about methods that Flickr knows about.

=head1 AUTHOR

Louis B. Moore C<< <lbmoore@cpan.org> >>.

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2015, Louis B. Moore C<< <lbmoore@cpan.org> >>.


This program is released under the Artistic License 2.0 by The Perl Foundation.

