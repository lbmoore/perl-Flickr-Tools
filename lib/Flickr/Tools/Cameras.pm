package Flickr::Tools::Cameras;

use Flickr::API::Cameras;
use Types::Standard qw ( InstanceOf );
use Carp;
use CHI;
use Moo;
use strictures 2;
use namespace::clean;
use 5.010;

with qw(Flickr::Roles::Caching);

our $VERSION = '1.21_03';

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
    my $pre_expire = 0;

    $self->cache_hit(1);

    if (defined($args->{clear_cache}) and $args->{clear_cache}) { $pre_expire = 1; }

    if (defined($args->{list_type}) and $args->{list_type} =~ m/list/i) {

        $self->cache_key('brands_list');

        $brands = $self->_cache->get($self->cache_key, expire_if => sub { $pre_expire } );
        if (!defined $brands) {
            $brands = $self->{_api}->brands_list;
            $self->cache_hit(0);
            $self->_cache->set( $self->cache_key, $brands, $self->cache_duration);
        }
    }
    else {

        $self->cache_key('brands_hash');

        $brands = $self->_cache->get($self->cache_key, expire_if => sub { $pre_expire } );
        if (!defined $brands) {
            $brands = $self->{_api}->brands_hash;
            $self->cache_hit(0);
            $self->_cache->set( $self->cache_key, $brands, $self->cache_duration);
        }
    }
    return  $brands;
}



sub getBrandModels {
    my ($self, $args) = @_;
    my $models = {};
    my $pre_expire = 0;

    $self->cache_hit(1);

    if (defined($args->{clear_cache}) and $args->{clear_cache}) { $pre_expire = 1; }

    if (exists($args->{Brand})) {

        $self->cache_key('Models ' . $args->{Brand});

        $models = $self->_cache->get($self->cache_key, expire_if => sub { $pre_expire } );
        if (!defined $models) {
            $models = $self->{_api}->get_cameras($args->{Brand});
            $self->cache_hit(0);
            $self->_cache->set( $self->cache_key, $models, $self->cache_duration);
        }
    }
    else {

        carp "\nCannot return models unless a required argument: Brand is passed in\n";

    }

    return $models;

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

