package Flickr::Roles::Caching;

use Carp;
use Types::Standard qw( Maybe Bool Str Int InstanceOf HashRef );
use 5.010;
use Moo::Role;


our $VERSION = '1.21_03';


has cache_duration => (
    is       => 'rw',
    isa      => Int,
    required => 1,
    default  => 900,
);

has '_cache' => (
    is => 'ro',
    isa => InstanceOf['CHI::Driver'],
    default => sub {CHI->new(driver => 'Memory',
                             global => 1
                         )},
);

has 'cache_key' => (
    is  => 'rw',
);

has cache_hit => (
    is => 'rw',
);

no Moo::Role;

1;

__END__


