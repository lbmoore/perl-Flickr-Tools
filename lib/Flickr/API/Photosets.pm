package Flickr::API::Photosets;

use warnings;
use strict;
use Carp;

use Flickr::API;
use Flickr::API::Utils;

=head1 NAME

Flickr::API::Photosets - The Perl interface to the Flickr API's flickr.photosets.* methods.

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';

=head1 SYNOPSIS

  use Flickr::API::Photos;

  my $flickrphotosets = Flickr::API::Photosets->new($my_flickr_api_key);

            
  my $photosets = $flickrphotosets->getList($user_id);
  
  my $photoset_id = $photosets->[0]{id};
  my $photos_list = $flickrphotosets->getPhotos($photoset_id);


=head1 DESCRIPTION

This module maps the Flickr API's flickr.photosets.* methods.

Each method from the Flickr API has a counterpart method in this class (the one's I've mapped already, that is).

The mapping is done by placing each unique piece of information (id, owner, title, description, etc) on the main-level hash and everything that may have multiple instances (photos for instance) on a array inside that main hash.

Mainly I've just tried to use common sense when deciding how to map something. Please feel free to send suggestions or insights on this subject.

Under the hood this class uses the Flickr::API class to handle the actual communication with Flickr's servers.

See the flickr API documentation <http://www.flickr.com/services/api> for the full description of each method and it's return values.

=cut

=head1 METHODS

=head2 new

Takes the Flickr API key as the 'key' parameter and sets up the object for further requests.

$flickrphotosets = Flickr::API::Photosets->new($my_flickr_api_key,
                                               $my_flickr_email,
                                               $my_flickr_password});

The 'my_flickr_email' and 'my_flickr_password' parameters are optional. If you wish to retreive pictures which are not public but are acessible to your account you should pass these parameters along and all further communication with Flickr will be authenticated with this data.

=cut

sub new {
  my $class = shift;
  my $api_key = shift;
  my $email = shift;
  my $password = shift;

  my $s = {};
  $s->{api_key} = $api_key;
  $s->{api} = new Flickr::API({key => $s->{api_key}});
  $s->{utils} = new Flickr::API::Utils();

  if ($email && $password) {
    $s->{auth_email} = $email;
    $s->{auth_password} = $password;
  }

  return bless $s, $class;
}

=head2 getList

Mapping for the method flickr.photosets.getList which gets the list of photosets for a given user.

$list = $flickrphotosets->getList($user_id);

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'success' => 1,
  'cancreate' => 1,
  'photosets' => [
                   {
                     'photos' => '12',
                     'id' => '123456',
                     'title' => 'A Great photoset',
                     'description' => 'Fabulous pictures all around!',
                     'secret' => '45ffssd334d',
                     'server' => '11',
                     'primary' => '12345678'
                   },
                   ...
                 ]
}


=cut

sub getList {
  my $s = shift;
  my $user_id = shift;

  croak "I need a User ID to fetch the lists from." unless $user_id;

  my $params = {user_id => $user_id};
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }

  my $list = $s->{api}->execute_method('flickr.photosets.getList',
                                       $params);

  my $result = {};
  if ($s->{utils}->test_return($list, $result)) {

    # Get the basic attributes
    $s->{utils}->get_attributes($list->{tree}{children}[1], $result);

    # What kind of data are we interested in?
    my $interesting = {
      photosets => {
        complex => 'array',
        photoset => {
          complex => 'flatten_array',
          title => 'simple_content',
          description => 'simple_content',
        }
      }
    };

    # Get the photo data
    my $parse_result = $s->{utils}->auto_parse($list->{tree}{children}, $interesting);
    %$result = (%$result, %$parse_result) if $parse_result;


  }

  return $result;
}

=head2 getPhotos

Mapping for the method flickr.photosets.getPhotos which gets the photo list for a given photoset.

$photos = $flickrphotosets->getPhotos($photoset_id);

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'success' => 1,
  'id' => '123456',
  'primary' => '5554323',
  'photos' => [
                {
                  'title' => 'LovelyCat.jpg',
                  'id' => '5554323',
                  'server' => '1',
                  'secret' => 'dsf77sd5f',
                  'isprimary' => '1'
                },
                ...
              ]
}


=cut

sub getPhotos {
  my $s = shift;
  my $photoset_id = shift;

  croak "I need a Photoset ID to fetch the list of photos from." unless $photoset_id;

  my $params = {photoset_id => $photoset_id};
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }

  my $photos = $s->{api}->execute_method('flickr.photosets.getPhotos',
                                       $params);

  my $result = {};
  if ($s->{utils}->test_return($photos, $result)) {

    # Get the basic attributes
    $s->{utils}->get_attributes($photos->{tree}{children}[1], $result);

    # What kind of data are we interested in?
    my $interesting = {
      photoset => {
        complex => 'array',
        photo => 'attributes',
      }
    };

    # Get the photo data
    my $parse_result = $s->{utils}->auto_parse($photos->{tree}{children}, $interesting);
    %$result = (%$result, %$parse_result) if $parse_result;
  }

  # Beautify the resposne somewhat
  $result->{photos} = $result->{photoset};
  delete $result->{photoset};
  
  foreach my $photo (@{$result->{photos}}) {
    foreach my $datum (keys %{$photo->{photo}}) {
      $photo->{$datum} = $photo->{photo}{$datum};
    }
    delete $photo->{photo};
  }

  return $result;
}

=head2 getContext

Mapping for the method flickr.photosets.getContext which gets the previous and next photos for a given photo inside a given photoset.

$photos = $flickrphotosets->getContext($photo_id, $photoset_id);

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'success' => 1
  'count' => '22',
  'nextphoto' => {
                   'title' => 'Finally arrived!',
                   'id' => '12345678',
                   'url' => '/photos/jdoe/12345678/in/set-12345/',
                   'thumb' => 'http://photos7.flickr.com/12345678_b33fa99a70_s.jpg',
                   'secret' => 'b33fa99a70'
                 },
  'previousphoto' => {
                       'title' => 'Nearly there...',
                       'id' => '12345676',
                       'url' => '/photos/jdoe/12345676/in/set-12345/',
                       'thumb' => 'http://photos7.flickr.com/12345676_b33fa93a70_s.jpg',
                       'secret' => 'b33fa93a70'
                     },
}

=cut

sub getContext {
  my $s = shift;
  my $photo_id = shift;
  my $photoset_id = shift;


  croak "I need a Photo ID to fetch the context information on." unless $photo_id;
  croak "I need a Photoset ID to fetch the context information on." unless $photoset_id;

  my $params = {photoset_id => $photoset_id, 
                photo_id => $photo_id};
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }

  my $context = $s->{api}->execute_method('flickr.photosets.getContext',
                                          $params);


  my $result = {};
  if ($s->{utils}->test_return($context, $result)) {

    # What kind of data are we interested in?
    my $interesting = {
      count => 'simple_content',
      prevphoto => 'attributes',
      nextphoto => 'attributes',
    };

    # Get the photo context data
    my $parse_result = $s->{utils}->auto_parse($context->{tree}{children}, $interesting);
    %$result = (%$result, %$parse_result) if $parse_result;
  }

  return $result;
}

=head2 getInfo

Mapping for the method flickr.photosets.getInfo which gets the information on the given photoset.

$photos = $flickrphotosets->getInfo($photoset_id);

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'success' => 1,
  'title' => 'Teste set',
  'owner' => '12345678@N00',
  'description' => 'Testing some features of my new super-duper camera.',
  'photos' => '16',
  'secret' => 'aeb33f3ac0',
  'id' => '123456',
  'primary' => '851835'
}

=cut

sub getInfo {
  my $s = shift;
  my $photoset_id = shift;


  croak "I need a Photoset ID to fetch the context information on." unless $photoset_id;

  my $params = {photoset_id => $photoset_id};
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }

  my $info = $s->{api}->execute_method('flickr.photosets.getInfo',
                                       $params);


  my $result = {};
  if ($s->{utils}->test_return($info, $result)) {
    # Get the basic attributes
    $s->{utils}->get_attributes($info->{tree}{children}[1], $result);

    # What kind of data are we interested in?
    my $interesting = {
      title => 'simple_content',
      description => 'simple_content',
    };

    # Get the photo info data
    my $parse_result = $s->{utils}->auto_parse($info->{tree}{children}[1]{children}, $interesting);
    %$result = (%$result, %$parse_result) if $parse_result;
  }

  return $result;
}

=head1 AUTHOR

Nuno Nunes, C<< <nfmnunes@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-flickr-photoset@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Flickr-Tools>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2005 Nuno Nunes, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Flickr::API::Photosets
