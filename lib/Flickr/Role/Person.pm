package Flickr::Role::Person;

use Flickr::Types::Person qw( GroupsArgList );
use Types::Standard qw( Object HashRef CodeRef );
use Type::Params qw( compile );
use 5.010;

use Moo::Role;
use strictures 2;

our $VERSION = '1.21_01';

around 'getGroups' => sub {

    state $check = compile( CodeRef, Object, GroupsArgList );
    my ($orig,$self,$args) = $check->(@_);

    my $groups = $orig->($self, $args);

    return $groups;

};



1;
