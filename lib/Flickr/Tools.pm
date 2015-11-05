package Flickr::Tools;

use Flickr::API;
use Flickr::Roles::Permissions;


use Flickr::Types::Tools qw( FlickrAPI  FlickrToken FlickrAPIargs HexNum);
use 5.010;
use Carp;
use Moo;
use strictures 2;
use namespace::clean;
use Storable qw( retrieve_fd ) ;

use Data::Dumper;
use Types::Standard qw( Maybe Str HashRef Int InstanceOf Bool);

our $VERSION = '1.21_02';

with ("Flickr::Roles::Permissions");


has _api => (
    is        => 'ro',
    isa       => InstanceOf["Flickr::API"],
    clearer   => 1,
    predicate => 'has_api',
    lazy      => 1,
    builder   => '_build_api',
    required  => 1,
);


has 'api_name' => (
    is       => 'ro',
    isa      => sub { $_[0] =~ m/^Flickr::API$/ },
    required => 1,
    default  => "Flickr::API",
);


has access_token => (
    is => 'ro',
    clearer => 1,
    isa => Maybe[InstanceOf['Net::OAuth::AccessTokenResponse']],
    required => 0,
);


has auth_uri => (
    is => 'ro',
    isa => Maybe[Str],
    clearer => 1,
    required => 0,
    default => 'https://api.flickr.com/services/oauth/authorize',
);


has callback => (
    is => 'ro',
    isa => Maybe[Str],
    clearer => 1,
    required => 0,
);


has config_file => (
    is => 'ro',
    isa => Maybe[Str],
    clearer => 1,
    required => 0,
);


has consumer_key => (
    is => 'ro',
    isa => HexNum,
    required => 1,
);

has consumer_secret => (
    is => 'ro',
    isa => HexNum,
    required => 1,
    );


has local => (
    is => 'ro',
    isa => Maybe[HashRef],
    clearer => 1,
    required => 0,
);


has request_method => (
    is => 'ro',
    clearer => 1,
    isa => Maybe[Str],
    required => 0,
    default => 'GET',
);

has request_token => (
    is => 'ro',
    isa => Maybe[InstanceOf['Net::OAuth::V1_0A::RequestTokenResponse']],
    clearer => 1,
    required => 0,
);

has request_url => (
    is => 'ro',
   isa => Maybe[Str],
    clearer => 1,
    required => 0,
    default => 'https://api.flickr.com/services/rest/',
);

has rest_uri => (
    is => 'ro',
    isa => Maybe[Str],
    clearer => 1,
    required => 0,
    default => 'https://api.flickr.com/services/rest/',
);

has signature_method => (
    is => 'ro',
    isa => Maybe[Str],
    clearer => 1,
    required => 0,
    default => 'HMAC-SHA1',
);

has token => (
    is => 'ro',
    isa => Maybe[FlickrToken],
    clearer => 1,
    required => 0,
);

has token_secret => (
    is => 'ro',
    isa => Maybe[HexNum],
    clearer => 1,
    required => 0,
);

has unicode => (
    is => 'ro',
    isa => sub { $_[0] != 0 ? 1 : 0; },
    clearer => 1,
    required => 0,
    default =>  0,
);

has user => (
    is => 'ro',
    isa => Maybe[Str],
    clearer => 1,
    required => 0,
);

has version => (
    is => 'ro',
    isa => Maybe[Str],
    clearer => 1,
    required => 0,
    default => '1.0',
);



sub dump {
    my $self = shift;
    say "Examine the tool";
    print Dumper($self);
    return;
}


sub BUILDARGS {

    my $class = shift;
    my $args  = shift;

    my $import;

    # args should be either a hashref, or a string containing the path to a config file

    unless (ref($args)) {

        my $config_filename = $args;
        undef $args;
        $args->{config_file} = $config_filename;

    }

    confess "\n\nFlickr::Tools->new() expects a hashref,\n  or at least the name of a config file\n\n" unless ref($args) eq 'HASH';

    if ($args->{config_file}) {

        if (-r $args->{config_file}) {

            my $info = Storable::file_magic($args->{config_file});
            if ($info->{version}) {

                open my $IMPORT, '<', $args->{config_file} or carp "\nCannot open $args->{config_file} for read: $!\n";
                $import = retrieve_fd($IMPORT);
                close $IMPORT;

            }
            else {

                carp $args->{config_file}," is not in storable format, removing from arguments\n";
                delete $args->{config_file};
            }
        }
         else {

            carp $args->{config_file}," is not a readable file, removing from arguments\n";
            delete $args->{config_file};
        }

    }

    my $fullargs = _merge_configs($args,$import);

    unless (exists($fullargs->{consumer_key}) and exists($fullargs->{consumer_secret})) {

        carp "\nMust provide, at least, a consumer_key and consumer_secret. They can be\npassed directly or in a config_file\n";

    }

    return $fullargs;
}


sub api {
    my $self = shift;

    return $self->_api if $self->has_api;

    return  $self->_build_api;
}

sub clear_api {
    my $self=shift;
    $self->_clear_api;
    $self->_clear_api_connects;
    return;
}




sub prepare_method {}

sub validate_method {}

sub call_method {}

sub make_arglist {}

sub auth_method {}

sub switch_underlying_api {}

sub set_method {
    my $self = shift;
    my $args = shift;

    if ($args->{method} =~ m/flickr\.people\./) {

    } else {


    }


}

# then specific tools::person or such operate on the family of methods
# and they can override some of the above.

sub _build_api {

    my $self = shift;
    my $args = shift;
    my $call = {};

    # required args
    $call->{consumer_key}    = $self->consumer_key;
    $call->{consumer_secret} = $self->consumer_secret;
    $call->{auth_type}       = 'oauth';

    $self->{_api} = $self->{api_name}->new($call);


}

#
# make a template configuration and overwrite template values
# with ones passed into new(). Any extra keys get weeded out
# and added to args->{local}->{unused_keys}
#
sub _merge_configs {
    my @hashes   = (@_);
    my $template = _make_config_template();
    my $extrakeys = {};
    my $key;
    my $value;

    foreach my $hashref (@hashes) {

         while (($key,$value) = each %{$hashref}) {

            if (exists($template->{$key})) {

                $template->{$key} = $value;

            } else {

                $extrakeys->{$key} = $value;
            }
        }
    }

    $template->{local}->{unused_args} = $extrakeys;

    return $template;
}

#
# make a shell of a configuration to deal with any random stuff
# that might be sent into new().
#
sub _make_config_template {

    my %empty = (
        access_token       => undef,
        auth_uri           => 'https://api.flickr.com/services/oauth/authorize' ,
        callback           => undef,
        config_file        => undef,
        consumer_key       => undef,
        consumer_secret    => undef,
        local              => undef,
        nonce              => undef,
        request_method     => 'GET',
        request_token      => undef,
        request_url        => 'https://api.flickr.com/services/rest/',
        rest_uri           => 'https://api.flickr.com/services/rest/',
        signature_method   => 'HMAC-SHA1',
        timestanp          => undef,
        token              => undef,
        token_secret       => undef,
        unicode            => 0,
        user               => undef,
        version            => '1.0',
    );

    return \%empty;

}


1;

__END__

=head1 NAME

Flickr::Tools - Tools to assist using the Flickr API

=head1 SYNOPSIS

This is a place holder for some configuration and persistence methods
needed a little bit further down the line.

  my $api  = Flickr::API->import_storable_config($config_file);

  my $tool = Flickr::Tool->new({api => $api});

=head1 METHODS

=over

=item C<new>

Returns a new Tool

=back

=head1 LICENSE AND COPYRIGHT


Copyright (C) 2014-2015 Louis B. Moore <lbmoore@cpan.org>


This program is released under the Artistic License 2.0 by The Perl Foundation.
L<http://www.perlfoundation.org/artistic_license_2_0>

=head1 SEE ALSO

L<Flickr|http://www.flickr.com/>,
L<http://www.flickr.com/services/api/>
L<https://www.flickr.com/services/api/auth.oauth.html>
L<https://github.com/iamcal/perl-Flickr-API>

=cut
