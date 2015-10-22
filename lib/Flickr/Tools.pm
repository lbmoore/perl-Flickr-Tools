package Flickr::Tools;

use Flickr::Types::Tools qw( FlickrAPI FlickrToken FlickrAPIargs HexNum);
use 5.010;
use Carp;
use Moo;
use strictures 2;
use namespace::clean;
use Storable qw( retrieve_fd ) ;
use Config::General;
use Data::Dumper::Simple;
use Types::Standard qw( Maybe Str HashRef Int InstanceOf );

our $VERSION = '1.21_02';


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

has api => (
    is => 'rwp',
    isa => Maybe[InstanceOf['Flickr::API']],
    clearer => 1,
    predicate => 1,
	required => 0,
)


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

has local => (
	is => 'ro',
    isa => Maybe[HashRef],
    clearer => 1,
	required => 0,
);

has method_family => (
    is => 'rwp',
    isa => Maybe[Str],
    clearer => 1,
    predicate => 1,
	required => 0,
    default => 'generic',
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
);

sub dump {
    my $self = shift;
    warn Dumper($self);
    return;
}




sub BUILDARGS {

    my $class = shift;
    my $args  = shift;

    my $temp_ref;

    confess "\n\nFlickr::Tools->new() expects a hashref" unless ref($args) eq 'HASH';

    if ($args->{config_file}) {

        if (-r $args->{config_file}) {

            my $info = Storable::file_magic($args->{config_file});
            if ($info->{version}) {

                open my $IMPORT, '<', $args->{config_file} or carp "\nCannot open $args->{config_file} for read: $!\n";
                $temp_ref = retrieve_fd($IMPORT);
                close $IMPORT;

            }

        }
         else {

            carp $args->{config_file}," is not a readable file, removing from arguments\n";
            delete $args->{config_file};
        }

    }

    my $fullargs = _merge_configs($args,$temp_ref);

    return $fullargs;

}

sub prepare_method {}

sub validate_method {}

sub call_method {}

sub make_arglist {}

sub auth_method {}

sub switch_underlying_api {}

# then specific tools::person or such operate on the family of methods
# and they can override some of the above.

sub _get_api {

    my $self = shift;
    my $args = shift;
    my $call = {};

    # required args
    $call->{consumer_key}    = $self->consumer_key;
    $call->{consumer_secret} = $self->consumer_secret;
    $call->{auth_type}       = 'oauth';

    my $api = Flickr::API->new($call);

    warn Dumper($api);


}


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


#    warn Dumper($template);
    $template->{local}->{unused_args} = $extrakeys;

    return $template;
}




sub _make_config_template {

    my %empty = (
        access_token       => undef,
        auth_uri           => undef,
        callback           => undef,
        config_file        => undef,
        consumer_key       => undef,
        consumer_secret    => undef,
        local              => undef,
        request_method     => undef,
        request_token      => undef,
        request_url        => undef,
        rest_uri           => undef,
        signature_method   => undef,
        token              => undef,
        token_secret       => undef,
        unicode            => undef,
        user               => undef,
        version            => undef,
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
