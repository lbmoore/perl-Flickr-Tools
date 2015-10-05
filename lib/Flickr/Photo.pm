package Flickr::Photo;

use warnings;
use strict;
use Carp;

#use Flickr::API::Photos;
use Flickr::Person;

=head1 NAME

Flickr::Photo - Represents a photo on Flickr.

=head1 VERSION

Version 1.19

=cut

our $VERSION = '1.19';

=head1 SYNOPSIS

    use Flickr::Photo;

    my $photo = Flickr::Photo->new($flickr_api_key);

    if ($photo->id({id => 12345678}) {
      my $owner = $photo->owner;
      my $title = $photo->title;
    }


=head1 DESCRIPTION

This class represents a photo on Flickr. It uses the Flickr::API::Photos class (and other's it finds necessary) in order to retrieve and send information to/from Flickr regarding a single photo.

The class tries to be well behaved and Flickr-server-friendly by using lazy data fetching and caching techniques.

The methods that are available are read/write when the item is alterable via the Flickr API. What that means is that if you call a method with an argument it will set that value while if you call it without any arguments it will give you the current value.

Nevertheless do read on the descriptions of each method for more information on it's usage.

IMPORTANT NOTE: So far the above statement about the methods being read/write is wishfull thinking as I've only implemented the read funcionality. Write is coming soon.

=head1 METHODS

=head2 new

Sets up the structure for usage.

$photo = Flickr::Photo->new({ api_key => $my_flickr_api_key,
                              email => $my_flickr_email,
                              password => $my_flickr_password});

The 'my_flickr_email' and 'my_flickr_password' are optional. See the method 'authenticate' for further explanation.

=cut

sub new {
  my $class = shift;
  my $params = shift;

  croak "I really really need your Flickr API key." unless $params->{api_key};

  my $me = { api_key => $params->{api_key} };
  if (exists $params->{email} && exists $params->{password}) {
    $me->{auth_email} = $params->{email};
    $me->{auth_password} = $params->{password};
  }

  if (exists $params->{pre_load}) {
    my $pl = $params->{pre_load};
    $me->{data}{title} = $pl->{title} if exists $pl->{title};
    $me->{data}{id} = $pl->{id} if exists $pl->{id};
    $me->{data}{server} = $pl->{server} if exists $pl->{server};
    $me->{data}{secret} = $pl->{secret} if exists $pl->{secret};
  }

  return bless $me, $class;
}

=head2 authenticate

Some interactions with flickr do require an authenticated user and some information is only accessible in this way and for those calls to be successfull you must provide these parameters. For everything else you really don't need them.

This method provides a way for the user to authenticate on all future calls.

This authentication data may also be provided via the new method.

$person->authenticate({ email => $my_flickr_email,
                        password => $my_flickr_password});


=cut

sub authenticate {
  my $s = shift;
  my $params = shift;

  croak "Missing the email parameter." unless exists $params->{email};
  croak "Missing the password parameter." unless exists $params->{password};

  $s->{auth_email} = $params->{email};
  $s->{auth_password} = $params->{password};

}

=head2 id

This method has two distinct behaviours depending on whether you call it with or without a parameter.

If you call it without any params it just gives you back the ID of the photo it is currently representing (assuming there is one photo being represented at this time).

$id = $p->id;

On the other hand, if you call it with a parameter it assumes you wish to represent the photo whose ID you just passed in and resets itself accordingly, deleting any data it might have had from a previous photo, and gets the basic information on the photo you requested.

$ok = $p->id($photo_id);

Always returns undef on error.
Also on error the $p->{error} structure will be defined.


=cut

sub id {
  my $s = shift;
  my $params = shift;

  $s->_reset_error;

  if (!exists $params->{id}) {
    return $s->{data}{id};
  }

  $s->_reset_data;
  $s->_setup_photos_api;

  return $s->_do_getInfo($params->{id});
}

=head2 server

Returns the server that stores the photo.

$server = $p->server;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub server {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{server})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{server};
}

=head2 title

Returns the title of the photo.

$title = $p->title;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub title {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{title})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{title};
}

=head2 rotation

Returns the rotation of the photo.

$rotation = $p->rotation;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub rotation {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{rotation})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{rotation};
}

=head2 comments

Returns the number of comments that where made on the photo.

$comments = $p->comments;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub comments {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{comments})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{comments};
}

=head2 notes

Returns the notes pertaining to this photo.

$notes = $p->notes;

The return value is pointer to an array with the following structure:

[
  {
    'h' => 50,
    'w' => 100,
    'x' => 10,
    'y' => 10,
    'authorname' => 'Some One',
    'author' => '12345678@N00',
    'value' => 'Some interesting remark',
  },
  ...
]

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub notes {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{notes})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{notes};
}

=head2 tags

Returns the tags pertaining to this photo.

$tags = $p->tags;

The return value is pointer to an array with the following structure:

[
  {
    'author' => '12345678@N00',
    'id' => 123456,
    'raw' => 'Wild Geese',
    'value' => 'wildgeese',
  },
  ...
]

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub tags {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{tags})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{tags};
}

=head2 is_favorite

If you are using authentication (see 'new') it indicates wether you count this photo as a favorite of yours.
If you are not authenticated this method doesn't realy make sense and always returns 0.

$is_favorite = $p->is_favorite;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub is_favorite {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{isfavorite})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{isfavorite};
}

=head2 license

Returns the type of license that the photo is under.

$license = $p->license;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub license {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{license})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{license};
}

=head2 description

Returns the description of the photo.

$description = $p->description;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub description {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{description})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{description};
}

=head2 secret

Returns the secret of the photo (if you have access to it).

$secret = $p->secret;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub secret {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{secret})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{secret};
}

=head2 is_family

Indicates wether this photo is visible to contacts marked as family.

$is_family = $p->is_family;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub is_family {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{visibility}{isfamily})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{visibility}{isfamily};
}

=head2 is_friend

Indicates wether this photo is visible to contacts marked as friends.

$is_friend = $p->is_friend;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub is_friend {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{visibility}{isfriend})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{visibility}{isfriend};
}

=head2 is_public

Indicates wether this photo is public (visible to anyone).

$is_public= $p->is_public;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub is_public {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{visibility}{ispublic})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{visibility}{ispublic};
}

=head2 perm_comment

Only exists if the currently authenticated user is the owner of the photo.

$perm_comment = $p->perm_comment;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub perm_comment {
  my $s = shift;
  
  $s->_reset_error;
  
  return unless ($s->{auth_email} && $s->{auth_password});
  if ((!exists($s->{data}{permissions}{permcomment})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{permissions}{permcomment};
}

=head2 perm_add_meta

Only exists if the currently authenticated user is the owner of the photo.

$perm_add_meta = $p->perm_add_meta;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub perm_add_meta {
  my $s = shift;
  
  $s->_reset_error;
  
  return unless ($s->{auth_email} && $s->{auth_password});
  if ((!exists($s->{data}{permissions}{permaddmeta})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{permissions}{permaddmeta};
}

=head2 can_comment

Indicates whether the user who is requesting the information can comment on this photo.

$can_comment = $p->can_comment;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub can_comment {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{editability}{cancomment})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{editability}{cancomment};
}

=head2 can_add_meta

Indicates whether the user who is requesting the information can add meta-information to this photo.

$can_add_meta= $p->can_add_meta;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub can_add_meta{
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{editability}{canaddmeta})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{editability}{canaddmeta};
}

=head2 date_posted

Returns the date that this photo was posted on.

$date_posted = $p->date_posted;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub date_posted {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{dates}{posted})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{dates}{posted};
}

=head2 date_taken

Returns the date that this photo was taken on.

$date_taken = $p->date_taken;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub date_taken {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{dates}{taken})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{dates}{taken};
}

=head2 date_taken_granularity

Returns the granularity of the dateken information.
According to the documentation (<http://www.flickr.com/services/api/misc.dates.html>) this value may have three different meanings (at the time of this writing at least):
0: 'Y-m-d H:i:s'
4: 'Y-m'
6: 'Y'

$date_taken_granularity = $p->date_taken_granularity;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub date_taken_granularity {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{dates}{takengranularity})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{dates}{takengranularity};
}

=head2 owner

Returns a Flickr::Person object representing the owner of this photo.

$person = $p->owner;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub owner {
  my $s = shift;
  
  $s->_reset_error;
 
  return $s->{owner} if $s->{owner};
 
  if ((!exists($s->{data}{owner})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getInfo($s->{data}{id});
  }

  if ($s->{data}{owner}) {
    my $owner_params = {api_key => $s->{api_key}};
    if ($s->{auth_email}) {
      $owner_params->{email} = $s->{auth_email};
      $owner_params->{password} = $s->{auth_password};
    }
    $owner_params->{pre_load} = $s->{data}{owner};
    $s->{owner} = Flickr::Person->new($owner_params);
  }
  
  return $s->{owner};
}

=head2 exif

Returns the EXIF information associated with the photo (if there is any).

$exif = $p->exif;

The return value is pointer to an array with the following structure:

[
  {
    'tagspaceid' => '0',
    'tag' => '271',
    'tagspace' => 'EXIF',
    'label' => 'Make',
    'raw' => 'Canon'
  },
  ...
]

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub exif {
  my $s = shift;
  
  $s->_reset_error;
 
  if ((!exists($s->{data}{exif})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getExif($s->{data}{id});
  }
  
  return $s->{data}{exif};
}

=head2 sizes

Returns information on the various available sizes of the photo.

$sizes = $p->sizes;

At the time of this writing existing sizes are:
- Square;
- Thumbnail;
- Small;
- Medium;
- Original.

The return value is pointer to an array with the following structure:

[
  {
    'source' => 'http://photos5.flickr.com/7698342_d3473121ce_s.jpg',
    'width' => '75',
    'url' =>
    'http://www.flickr.com/photo_zoom.gne?id=7698342&amp;size=sq',
    'label' => 'Square',
    'height' => '75'
  },
  ...
]

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub sizes {
  my $s = shift;
  
  $s->_reset_error;
 
  if ((!exists($s->{data}{sizes})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getSizes($s->{data}{id});
  }
  
  return $s->{data}{sizes};
}

=head2 next_photo_info

Returns information on the next photo in the photostream.

$next_photo_info = $p->next_photo_info;

The return value is pointer to a hash with the following structure:

{
  'secret' => 'df435fa33',
  'title' => 'Great next photo!',
  'url' => '/photos/janedoe/1234567/in/photostream/',
  'id' => '1234567',
  'thumb' => 'http://photos5.flickr.com/1234567_df435fa33_s.jpg'
}

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub next_photo_info {
  my $s = shift;
  
  $s->_reset_error;
 
  if ((!exists($s->{data}{context}{nextphoto})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getContext($s->{data}{id});
  }
  
  return $s->{data}{context}{nextphoto};
}

=head2 prev_photo_info

Returns information on the previous photo in the photostream.

$prev_photo_info = $p->prev_photo_info;

The return value is pointer to a hash with the following structure:

{
  'secret' => 'df43eca33',
  'title' => 'Cool previous photo!',
  'url' => '/photos/janedoe/1234565/in/photostream/',
  'id' => '1234565',
  'thumb' => 'http://photos5.flickr.com/1234565_df43eca33_s.jpg'
}

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub prev_photo_info {
  my $s = shift;
  
  $s->_reset_error;
 
  if ((!exists($s->{data}{context}{prevphoto})) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_getContext($s->{data}{id});
  }
  
  return $s->{data}{context}{prevphoto};
}



=head2 _reset_data

Internal method used for reseting the data on the currently instantiated photo.

=cut

sub _reset_data {
  my $s = shift;

  delete $s->{data};
}

=head2 _reset_error

Internal method used for reseting the error information on the last method call.

=cut

sub _reset_error {
  my $s = shift;

  delete $s->{error};
}

=head2 _setup_photos_api

Internal method used to setup the Flickr::API::Photos object.

=cut

sub _setup_photos_api {
  my $s = shift;
  
  if (!exists $s->{photos_api}) {
    if ($s->{auth_email}) {
      $s->{photos_api} = Flickr::API::Photos->new($s->{api_key},
                                                  $s->{auth_email},
                                                  $s->{auth_password});
    }
    else {
      $s->{photos_api} = Flickr::API::Photos->new($s->{api_key});
    }
  }
}

=head2 _do_getInfo

Internal method used to parse the result from the Flickr::Photos::getInfo method and fill in our data with it's results.

=cut

sub _do_getInfo {
  my $s = shift;
  my $id = shift;
  
  my $resp = $s->{photos_api}->getInfo($id);
  if ($resp->{success}) {
    $s->{data}{id} = $resp->{id};
    $s->{data}{server} = $resp->{server};
    $s->{data}{title} = $resp->{title};
    $s->{data}{rotation} = $resp->{rotation};
    $s->{data}{comments} = $resp->{comments};
    $s->{data}{isfavorite} = $resp->{isfavorite};
    $s->{data}{license} = $resp->{license};
    $s->{data}{description} = $resp->{description};
    $s->{data}{secret} = $resp->{secret};
    $s->{data}{dateuploaded} = $resp->{dateuploaded};
    $s->{data}{owner} = $resp->{owner};
    $s->{data}{editability} = $resp->{editability};
    $s->{data}{visibility} = $resp->{visibility};
    $s->{data}{permissions} = $resp->{permissions};
    $s->{data}{dates} = $resp->{dates};
    $s->{data}{notes} = $resp->{notes};
    $s->{data}{tags} = $resp->{tags};
  }
  else {
    carp "Got an error from Flickr: ".$resp->{error_message}." (".$resp->{error_code}.")";
    $s->{error}{code} = $resp->{error_code};
    $s->{error}{message} = $resp->{error_message};
    return undef;
  }

  return $resp->{success};
}

=head2 _do_getExif

Internal method used to parse the result from the Flickr::Photos::getExif method and fill in our data with it's results.

=cut

sub _do_getExif {
  my $s = shift;
  my $id = shift;
  
  my $resp = $s->{photos_api}->getExif($id);
  if ($resp->{success}) {
    $s->{data}{exif} = $resp->{tags};
  }
  else {
    carp "Got an error from Flickr: ".$resp->{error_message}." (".$resp->{error_code}.")";
    $s->{error}{code} = $resp->{error_code};
    $s->{error}{message} = $resp->{error_message};
    return undef;
  }

  return $resp->{success};
}

=head2 _do_getSizes

Internal method used to parse the result from the Flickr::Photos::getSizes method and fill in our data with it's results.

=cut

sub _do_getSizes {
  my $s = shift;
  my $id = shift;
  
  my $resp = $s->{photos_api}->getSizes($id);
  if ($resp->{success}) {
    $s->{data}{sizes} = $resp->{sizes};
  }
  else {
    carp "Got an error from Flickr: ".$resp->{error_message}." (".$resp->{error_code}.")";
    $s->{error}{code} = $resp->{error_code};
    $s->{error}{message} = $resp->{error_message};
    return undef;
  }

  return $resp->{success};
}

=head2 _do_getContext

Internal method used to parse the result from the Flickr::Photos::getContext method and fill in our data with it's results.

=cut

sub _do_getContext {
  my $s = shift;
  my $id = shift;
  
  my $resp = $s->{photos_api}->getContext($id);
  if ($resp->{success}) {
    $s->{data}{context}{nextphoto} = $resp->{nextphoto};
    $s->{data}{context}{prevphoto} = $resp->{prevphoto};
  }
  else {
    carp "Got an error from Flickr: ".$resp->{error_message}." (".$resp->{error_code}.")";
    $s->{error}{code} = $resp->{error_code};
    $s->{error}{message} = $resp->{error_message};
    return undef;
  }

  return $resp->{success};
}



=head1 AUTHOR

Nuno Nunes, C<< <nfmnunes@cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2005 Nuno Nunes, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

<http://www.flickr.com/>, Flickr::Person, Flickr::Photoset

=cut

1; # End of Flickr::Photo
