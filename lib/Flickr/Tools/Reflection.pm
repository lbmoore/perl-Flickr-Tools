package Flickr::Tools::Reflection;

use Flickr::API::Reflection;
use Types::Standard qw ( InstanceOf );
use Carp;
use Moo;
use strictures 2;
use namespace::clean;
use 5.010;


our $VERSION = '1.21_04';

extends 'Flickr::Tools';

has '+_api_name' => (
    is       => 'ro',
    isa      => sub { $_[0] =~ m/^Flickr::API::Reflection$/ },
    required => 1,
    default  => 'Flickr::API::Reflection',
);

sub getMethods {
    my ($self, $args) = @_;
    my $methods;

    if (defined($args->{list_type}) and $args->{list_type} =~ m/list/i) {

        $methods = $self->{_api}->methods_list;

    }
    else {

        $methods = $self->{_api}->methods_hash;

    }

    return $methods;
}


sub thisMethod {
   my ($self, $args) = @_;

   my $rsp = {};

   if (ref($args) eq 'HASH') {

       if (exists($args->{Method})) {

           $rsp = $self->{_api}->get_method($args->{Method});

       }
       elsif ($args =~ m/flickr\.[a-z]+\.*/) {

           $rsp = $self->{_api}->get_method($args);

       }
       else {

           carp "argument neither a hashref pointing to a method, or the name of a method";

       }
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

