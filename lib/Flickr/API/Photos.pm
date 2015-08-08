package Flickr::API::Photos;

use warnings;
use strict;
use Carp;

use Flickr::API;
use Flickr::API::Utils;

=head1 NAME

Flickr::API::Photos - The Perl interface to the Flickr API's flickr.photos.* methods.

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';
my $DEBUG;

=head1 SYNOPSIS

    use Flickr::API::Photos;

    my $flickrphotos = Flickr::API::Photos->new($my_flickr_api_key);
    
    my $photoshash = $flickrphotos->getInfo($photo_id);
    print $photohash->{'title'};
    print $photohash->{'description'};


=head1 DESCRIPTION

NOTE: You probably don't want to use this module directly. Please see the Flickr::Photo module for a nice, clean interface to the Flickr photos. Having said that, if this is realy what you want, do go ahead and use it.

This module maps the Flickr API's flickr.photos.* methods.

Each method from the Flickr API has a counterpart method in this class (the one's I've mapped already, that is).

The mapping is done by placing each unique piece of information (id, server, title, description, etc) on the main-level hash and everything that may have multiple instances (tags and notes, for instance) on a array inside that main hash.

Mainly I've just tried to use common sense when deciding how to map something. Please feel free to send suggestions or insights on this subject.

Under the hood this class uses the Flickr::API class to handle the actual communication with Flickr's servers.

See the flickr API documentation <http://www.flickr.com/services/api> for the full description of each method and it's return values.


=cut

=head1 METHODS

=head2 new

Takes the Flickr API key as the 'key' parameter and sets up the object for further requests.

$flickrphotos = Flickr::API::Photos->new($my_flickr_api_key,
                                         $my_flickr_email,
                                         $my_flickr_password});

The 'my_flickr_email' and 'my_flickr_password' parameters are optional. If you wish to retreive pictures which are not public but are acessible to your account you should pass these parameters along and all further communication with Flickr will be authenticated with this data.

=cut

sub new {
  my $class = shift;
  my $api_key = shift;
  my $email = shift;
  my $password = shift;

  croak "I really really need your Flickr API key." unless $api_key;

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

=head2 getExif

Mapping for the method flickr.photos.getExif which gets the EXIF information for a given photo.

$exif = $flickrphotos->getExif($photo_id, $secret);

The 'secret' parameter is optional.

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'success' => 1,
  'photo_data' => {
                    'id' => '342213',
                    'secret' => 'ddf44221d',
                    'server' => '1'
                  },
  'tags' => [
              {
                'tagspaceid' => '0',
                'tag' => '271',
                'tagspace' => 'EXIF',
                'label' => 'Make',
                'raw' => 'Canon'
              },
              {
                'tagspaceid' => '0',
                'tag' => '272',
                'tagspace' => 'EXIF',
                'label' => 'Model',
                'raw' => 'Canon EOS 10D'
              },
              ...
            ]
};


=cut

sub getExif {
  my $s = shift;
  my $photo_id = shift;
  my $secret = shift;


  croak "I need a Photo ID to fetch the EXIF information on." unless $photo_id;

  my $params = {photo_id => $photo_id};
  $params->{secret} = $secret if $secret;
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }
  
  my $exif = $s->{api}->execute_method('flickr.photos.getExif',
                                       $params);


  my $result = {};
  if ($s->{utils}->test_return($exif, $result)) {
  
    # Get the basic attributes
    $result->{photo_data} = {};
    $s->{utils}->get_attributes($exif->{tree}{children}[1], $result->{photo_data});

    # What kind of data are we interested in?
    my $interesting = {
      photo => {
        complex => 'array',
        exif => {
          complex => 'flatten_array',
          raw => 'simple_content',
          clean => 'simple_content',
        }
      }
    };
    
    # Get the photo data
    my $parse_result = $s->{utils}->auto_parse($exif->{tree}{children}, $interesting);
    %$result = (%$result, %$parse_result) if $parse_result;
  }

  # Beautify the result a little
  $result->{tags} = $result->{photo};
  delete $result->{photo};

  return $result;
}

=head2 getInfo

Mapping for the method flickr.photos.getInfo which gets the stored information for a given photo.

$photoinfo = $flickrphotos->getInfo($photo_id, $secret);

The 'secret' parameter is optional.

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'success' => 1,
  'id' => 123456,
  'server' => 2,
  'title' => 'My beautifull photo',
  'rotation' => 0,
  'comments' => 2,
  'isfavorite' => 0,
  'license' => 0,
  'description' => 'A Test photo. Please disregard',
  'secret' => 'as3ddf442d',
  'owner' => {
               'username' => 'John Doe',
               'nsid' => '12345678@N00',
               ...
             },
  'permissions' => {
                     'permcomment' => 1,
                     'permaddmeta' => 0,
                   },
  'editability' => {
                     'cancomment' => 0,
                     'canaddmeta => 0,
                   },
  'visibility' => {
                    'ispublic' => 1,
                    'isfamily' => 0,
                    'isfriend' => 0
                  },
  'dates' => {
               'posted' => '1097663727',
               'taken' => ,2004-10-05 16:08:12',
               ''takengranularity' => '0'
             },
  'notes' => [
               {
                 'h' => 50,
                 'w' => 100,
                 'authorname' => 'Some One',
                 'value' => 'Some interesting remark',
                 ...
               },
               ...
             ],
  'tags' => [
              {
                'author' => '21345678@N00',
                'id' => 1234546,
                'raw' => 'My Vacation Photos',
                'value' => 'myvacationphotos'
              },
              ...
            ],
}

=cut

sub getInfo {
  my $s = shift;
  my $photo_id = shift;
  my $secret = shift;


  croak "I need a Photo ID to fetch information on." unless $photo_id;

  my $params = {photo_id => $photo_id};
  $params->{secret} = $secret if $secret;
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }
  
  my $info = $s->{api}->execute_method('flickr.photos.getInfo',
                                       $params);


  my $result = {};
  if ($s->{utils}->test_return($info, $result)) {
  
    # Get the basic attributes
    $s->{utils}->get_attributes($info->{tree}{children}[1], $result);

    # What kind of data are we interested in?
    my $interesting = {
      owner => 'attributes',
      visibility => 'attributes',
      dates => 'attributes',
      title => 'simple_content',
      description => 'simple_content',
      permissions => 'attributes',
      editability => 'attributes',
      comments => 'simple_content',
      notes => {
        complex => 'array',
        note => 'attributes&simple_content',
      },
      tags => {
        complex => 'array',
        tag => 'attributes&simple_content',
      },
    };
    
    # Get the photo data
    my $parse_result = $s->{utils}->auto_parse($info->{tree}{children}[1]{children}, $interesting);
    %$result = (%$result, %$parse_result) if $parse_result;

    # Clean up some sections a little
    foreach my $note (@{$result->{notes}}) {
      foreach my $datum (keys %{$note->{note}}) {
        $note->{$datum} = $note->{note}{$datum};
      }
      delete $note->{note};
    }
    foreach my $tag (@{$result->{tags}}) {
      foreach my $datum (keys %{$tag->{tag}}) {
        $tag->{$datum} = $tag->{tag}{$datum};
      }
      delete $tag->{tag};
    }
  }
  return $result;
}

=head2 getContext

Mapping for the method flickr.photos.getContext which gets the previous and next photo for a photo in a photostream.

$photocontext = $flickrphotos->getContext($photo_id);

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'success' => 1,
  'count' => '154',
  'nextphoto' => {
                   'secret' => 'df435fa33',
                   'title' => 'Great next photo!',
                   'url' => '/photos/janedoe/1234567/in/photostream/',
                   'id' => '1234567',
                   'thumb' => 'http://photos5.flickr.com/1234567_df435fa33_s.jpg'
                 },
  'prevphoto' => {
                   'secret' => 'eabf1db33f',
                   'title' => 'Awsome previous photo',
                   'url' => '/photos/johndoe/1234568/in/photostream/',
                   'id' => '1234568',
                   'thumb' => 'http://photos5.flickr.com/1234568_eabf1db33f_s.jpg'
  }
}

=cut

sub getContext {
  my $s = shift;
  my $photo_id = shift;


  croak "I need a Photo ID to fetch the context information on." unless $photo_id;

  my $params = {photo_id => $photo_id};
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }
  
  my $context = $s->{api}->execute_method('flickr.photos.getContext',
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

=head2 getSizes

Mapping for the method flickr.photos.getSizes which gets the available sizes for a photo.

$photosizes = $flickrphotos->getSizes($photo_id);

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'success' => 1,
  'sizes' => [
               {
                 'source' => 'http://photos5.flickr.com/7698342_d3473121ce_s.jpg',
                 'width' => '75',
                 'url' => 'http://www.flickr.com/photo_zoom.gne?id=7698342&amp;size=sq',
                 'label' => 'Square',
                 'height' => '75'
               },
               {
                 'source' => 'http://photos5.flickr.com/1234567_db33f181ce_t.jpg',
                 'width' => '100',
                 'url' => 'http://www.flickr.com/photo_zoom.gne?id=1234567&amp;size=t',
                 'label' => 'Thumbnail',
                 'height' => '67'
               },
               {
                 'source' => 'http://photos5.flickr.com/1234568_db33f181ce_m.jpg',
                 'width' => '240',
                 'url' => 'http://www.flickr.com/photo_zoom.gne?id=1234568&amp;size=s',
                 'label' => 'Small',
                 'height' => '160'
               },
               {
                 'source' => 'http://photos5.flickr.com/1234569_d29b33f1ce.jpg',
                 'width' => '500',
                 'url' => 'http://www.flickr.com/photo_zoom.gne?id=1234569&amp;size=m',
                 'label' => 'Medium',
                 'height' => '334'
               },
               {
                 'source' => 'http://photos5.flickr.com/7654321_d29031b33f_o.jpg',
                 'width' => '640',
                 'url' => 'http://www.flickr.com/photo_zoom.gne?id=7654321&amp;size=o',
                 'label' => 'Original',
                 'height' => '427'
               }
  ]
}

=cut

sub getSizes {
  my $s = shift;
  my $photo_id = shift;


  croak "I need a Photo ID to fetch the size information on." unless $photo_id;

  my $params = {photo_id => $photo_id};
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }
  
  my $sizes = $s->{api}->execute_method('flickr.photos.getSizes',
                                       $params);


  my $result = {};
  if ($s->{utils}->test_return($sizes, $result)) {
  
    # What kind of data are we interested in?
    my $interesting = {
      sizes => {
                 complex => 'array',
		 size => 'attributes',
      }
    };
    
    # Get the photo size data
    my $parse_result = $s->{utils}->auto_parse($sizes->{tree}{children}, $interesting);
    %$result = (%$result, %$parse_result) if $parse_result;

    # Beautify the results somewhat
    foreach my $size (@{$result->{sizes}}) {
      foreach my $datum (keys %{$size->{size}}) {
        $size->{$datum} = $size->{size}{$datum};
      }
      delete $size->{size};
  }

  }
  return $result;

}

=head2 getPerms

Mapping for the method flickr.photos.getPerms which gets the permissions for a given photo.

$photoperms = $flickrphotos->getPerms($photo_id);

This method requires the user to be authenticated (see 'new');

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'success' => 1,
  'perms' => {
               'isfriend' => '0',
               'isfamily' => '0',
               'permcomment' => '0',
               'id' => '851195',
               'ispublic' => '1',
               'permaddmeta' => '0'
  }
}

=cut

sub getPerms {
  my $s = shift;
  my $photo_id = shift;


  croak "I need a Photo ID to fetch the permissions of." unless $photo_id;

  my $params = {photo_id => $photo_id};
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }
  else {
    my $result = {
      success => 0,
      error_message => 'Method requires authentication'
    };
    return $result;
  }
  
  my $perms = $s->{api}->execute_method('flickr.photos.getPerms',
                                       $params);


  my $result = {};
  if ($s->{utils}->test_return($perms, $result)) {
  
    # What kind of data are we interested in?
    my $interesting = {
      perms => 'attributes'
    };
    
    # Get the photo perms data
    my $parse_result = $s->{utils}->auto_parse($perms->{tree}{children}, $interesting);
    %$result = (%$result, %$parse_result) if $parse_result;
  }

  return $result;
}


=head1 AUTHOR

Nuno Nunes, C<< <nfmnunes@cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2005 Nuno Nunes, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

Flickr::API, <http://www.flickr.com/>, <http://www.flickr.com/services/api>

=cut

1; # End of Flickr::API::Photos
