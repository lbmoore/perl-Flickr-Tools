package Flickr::Roles::Permissions;
use Carp;

use Flickr::Types::Tools qw ( FlickrPermStr );
use Types::Standard qw( Bool);
use 5.010;
use Moo::Role;

#has permissions => (
#    is => 'ro',
#    isa => FlickrPermStr,
#    required => 1,
#    default => 'none',
#);

has _api_connects => (
    is        => 'ro',
    isa       => Bool,
    required  => 1,
    clearer   => 1,
    lazy      => 1,
    builder   => '_can_connect',
    default => 0,
);

requires qw( _build_api api );


sub connects {
    my $self = shift;

    return $self->_api_connects if $self->_api_connects;

    $self->_can_connect;

    return  $self->_api_connects;
}

# make lazy
#
sub _can_connect {
    my $self   = shift;
    my $temp   = $self->api;
    my $rsp    = $temp->execute_method('flickr.test.echo', { 'tool' => 'can_connect' } );

    $self->{_api_connects} = 0;

    unless ($rsp->rc eq '200') {

        carp "\nConnect attempt to Flickr received " . $rsp->rc . " html response code\n";
        return;

    }

    unless ($rsp->success eq '1') {

        carp "\nConnection was made but received a " .
            $rsp->error_code .
            "\n    " . $rsp->error_message . "\n";
        return;

    }

    my $answer = $rsp->as_hash;

    if ($answer->{'tool'} eq 'can_connect') {
        $self->{_api_connects} = 1;

        return;

    }
    else {

        carp "\nUnexpected data received back from Flickr\n";
        return;

    }
}

no Moo::Role;


1;


__END__

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
