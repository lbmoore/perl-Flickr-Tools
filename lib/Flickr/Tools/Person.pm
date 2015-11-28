package Flickr::Tools::Person;
use 5.010;

use Flickr::Types::Person qw( FlickrAPIPeople FlickrToolsPerson PersonSearchDict GroupsArgList );
use Types::Standard -types;
use Type::Params qw( compile );
use Carp;
use Moo;
use strictures;
use namespace::clean;

our $VERSION = '1.21_04';

has api => (
    is  => 'ro',
    isa => FlickrAPIPeople,
    required => 1,

);

has searchkey => (
    is   => 'rw',
    isa  => PersonSearchDict,
    required => 1,
);

has user => (
    is => 'rwp',
    isa => HashRef,
);

has success => (
    is      => 'rwp',
    isa     =>  sub { $_[0] != 0 ? 1 : 0; },
    default =>  0,
);

has exists  => (
    is      => 'rwp',
    isa     =>  sub { $_[0] != 0 ? 1 : 0; },
    default =>  0,
);



sub BUILD {
    my ($self) = @_;

    my $key = $self->searchkey;
    my $api = $self->api;

    if ( defined ($key->{email})) {

        $api->findByEmail($key->{email});

    }
    elsif (defined ($key->{username})) {

        $api->findByUsername($key->{username});

    }
    else {

        $self->_set_exists(0);
        confess "Person->new was handed a non-person key to search for. Understandably upset";
    }

    if (($api->api_success) == 0 ) {

        carp 'Person->new failed. Flickr::API::People reports "',$api->api_message,'"';
        $self->_set_exists(0);

    } else {

        $self->_set_exists(1);
        $self->_set_user($api->user());
    }

    return;
}


sub getGroups {

    state $check = compile( FlickrToolsPerson, GroupsArgList );
    my ($self,$args) = $check->(@_);

    my $api  = $self->api;
#    my $call = {};
    my $groups = {};

#    $call->{user_id} = $api->nsid;

#    if (defined($args->{user_id})) { $call->{user_id} = $args->{user_id}; }
#    if (defined($args->{extras}))  { $call->{extras}  = $args->{extras}; }

    if ($api->perms() =~ /^(read|write|delete)$/) {

        my $rsp = $api->execute_method('flickr.people.getGroups',$args);

        if ($rsp->success == 1) {

            $groups = $rsp->as_hash();
            $self->_set_success(1);

        }
        else {

            carp 'Person->getGroups failed with ',$rsp->message;
            $self->_set_success(0);

        }
    }
    else {

        carp 'Person->getGroups failed. Method needs read permission and api has ',$api->perms();
        $self->_set_success(0);

    }

    return $groups;

}

sub getInfo {

    my ($self) = @_;
    my $api  = $self->api;
    my $call = {};
    my $info = {};

    $call->{user_id} = $api->nsid;

    my $rsp = $api->execute_method('flickr.people.getInfo',$call);

    if ($rsp->success == 1) {

        $info = $rsp->as_hash();
        $self->_set_success(1);

    }
    else {

        carp 'Person->getInfo failed with ',$rsp->message;
        $self->_set_success(0);

    }
    return $info;
}


sub getLimits {
    my ($self,$args) = @_;

    my $api  = $self->api;
    my $limits = {};

    if ($api->perms() =~ /^(read|write|delete)$/) {

        my $rsp = $api->execute_method('flickr.people.getLimits');

        if ($rsp->success == 1) {

            $limits = $rsp->as_hash();
            $self->_set_success(1);

        }
        else {

            carp 'Person->getLimits failed with ',$rsp->message;
            $self->_set_success(0);

        }
    }
    else {

        carp 'Person->getLimits failed. Method needs read permission and api has ',$api->perms();
        $self->_set_success(0);

    }

    return $limits;

}
#
#  with roles flickr::tools == role box
#  in tools
#  around baz == {sub }
#
# role would have the type and validation
#
# this class would use flickr::tools
#
# then with role
#
# and/or my sub baz  would in essence be role::baz { this baz { } }
#
#
sub getPhotos {

    my ($self,$args) = @_;

    my $api  = $self->api;
    my $call = {};

    $call->{user_id} = $api->nsid;

    if (defined($args->{user_id})) { $call->{user_id} = $args->{user_id}; }

}

sub getPhotosOf {
    my ($self,$args) = @_;

    my $api  = $self->api;
    my $call = {};

    $call->{user_id} = $api->nsid;

    if (defined($args->{user_id})) { $call->{user_id} = $args->{user_id}; }

}

sub getPublicGroups {
    my ($self,$args) = @_;

    my $api  = $self->api;
    my $call = {};

    $call->{user_id} = $api->nsid;

    if (defined($args->{user_id})) { $call->{user_id} = $args->{user_id}; }

}

sub getPublicPhotos {
    my ($self,$args) = @_;

    my $api  = $self->api;
    my $call = {};

    $call->{user_id} = $api->nsid;

    if (defined($args->{user_id})) { $call->{user_id} = $args->{user_id}; }

}

sub getUploadStatus {
    my ($self,$args) = @_;

    my $api  = $self->api;
    my $status = {};

 
}

1;

__END__

=head1 NAME

Flickr::Person - Perl interface to the Flickr API for people

=head1 SYNOPSIS

Person role

flickr.people.findByEmail         No   Perms
flickr.people.findByUsername      No   Perms
flickr.people.getGroups           Read Perms
flickr.people.getInfo             No   Perms
flickr.people.getLimits           Read Perms
flickr.people.getPhotos           No   Perms or Read+ for private ones
flickr.people.getPhotosOf         No   Perms
flickr.people.getPublicGroups     No   Perms
flickr.people.getPublicPhotos     No   Perms
flickr.people.getUploadStatus     Read  Perms
