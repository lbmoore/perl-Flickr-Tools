package Flickr::Tools::Cameras;

use Flickr::API::Cameras;
use Types::Standard qw ( InstanceOf );
use Carp;
use Moo;
use strictures 2;
use namespace::clean;
use 5.010;


our $VERSION = '1.21_02';

extends 'Flickr::Tools';

has '+_api_name' => (
    is       => 'ro',
    isa      => sub { $_[0] =~ m/^Flickr::API::Cameras$/ },
    required => 1,
    default  => "Flickr::API::Cameras",
);


sub getBrands {
    my ($self, $args) = @_;
    my $brands;

    if (defined($args->{list_type}) and $args->{list_type} =~ m/list/i) {

        $brands = $self->{_api}->brands_list;

    }
    else {

        $brands = $self->{_api}->brands_hash;

    }

    return $brands;
}



sub getBrandModels {
    my ($self, $args) = @_;

    my $rsp = {};

    if (exists($args->{Brand})) {

        $rsp = $self->{_api}->get_cameras($args->{Brand});

    }

    return $rsp;

}




1;

__END__

=head1 NAME

Flickr::Tools::Cameras - Perl interface to the Flickr::API for cameras

=head1 SYNOPSIS

 use strict;
 use warnings;
 use Flickr::Tools::Cameras;
 use 5.010;

 my $config = "~/my_config.st";  # config in Storable format from L<Flickr::API>

 my $camera_tool = Flickr::Tools::Cameras->new({config_file => $config});

 my $arrayref = $camera_tool->getBrands({list_type => 'List'});
 my $hashref  = $camera_tool->getBrands;  #hashref is the default

 if (exists($hashref->{mybrand}) {

    $camera_tool->getBrandModels({Brand => 'mybrand'});

 }

