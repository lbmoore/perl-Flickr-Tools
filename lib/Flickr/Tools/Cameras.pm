package Flickr::Tools::Cameras;

use Flickr::API::Cameras;
use Types::Standard qw ( InstanceOf );
use Carp;
use CHI;
use Moo;
use strictures 2;
use namespace::clean;
use 5.010;


our $VERSION = '1.21_03';

extends 'Flickr::Tools';

has '+_api_name' => (
    is       => 'ro',
    isa      => sub { $_[0] =~ m/^Flickr::API::Cameras$/ },
    required => 1,
    default  => "Flickr::API::Cameras",
);

has '_brands_cache' => (
    is => 'rw',
    isa => InstanceOf['CHI::Driver'],
    default => sub {CHI->new(driver => 'Memory',
                             global => 1
                         )},
    predicate => 1,
);

has '_models_cache' => (
    is => 'rw',
    isa => InstanceOf['CHI::Driver'],
    default => sub {CHI->new(driver => 'Memory',
                             global => 1
                         )},
    predicate => 1,

);

use Data::Dumper::Simple;

sub getBrands {
    my ($self, $args) = @_;
    my $brands;

        if (defined($args->{list_type}) and $args->{list_type} =~ m/list/i) {

            $brands = $self->_brands_cache->get('brands_list');
            if (!defined $brands) {
                $brands = $self->{_api}->brands_list;
                $self->_brands_cache->set( 'brands_list', $brands, "15 Minutes");
            }
        }
        else {

            $brands = $self->_brands_cache->get('brands_hash');
            if (!defined $brands) {
                $brands = $self->{_api}->brands_hash;
                $self->_brands_cache->set( 'brands_hash', $brands, "15 Minutes");
            }

        }

    warn Dumper($brands);
    return  $brands;
    }



sub getBrandModels {
    my ($self, $args) = @_;

    my $models = {};

    if (exists($args->{Brand})) {

        $models = $self->_models_cache->get($args->{Brand});
        if (!defined $models) {
            $models = $self->{_api}->get_cameras($args->{Brand});
            $self->_models_cache->set( $args->{Brand}, $models, "15 Minutes");
        }
    }
    else {

        carp "\nCannot return models unless a required argument: Brand is passed in\n";

    }
    warn Dumper($self->_models_cache);
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

