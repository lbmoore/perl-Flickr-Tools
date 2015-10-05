package Flickr::Photoset;

use warnings;
use strict;
use Carp;

#use Flickr::API::Photosets;
use Flickr::Person;
use Flickr::Photo;

=head1 NAME

Flickr::Photoset - Represents a photoset on Flickr.

=head1 VERSION

Version 1.19

=cut

our $VERSION = '1.19';

=head1 SYNOPSIS

    use Flickr::Photoset;

    my $photoset = Flickr::Photoset->new($flickr_api_key);
    
    if ($photoset->id({id => 12345678})) {
      my $title = $photoset->title;
      my $owner = $photoset->owner;
    }


=head1 DESCRIPTION

This class represents a photoset on Flickr. It uses the Flickr::API::Photosets class (and other's it finds necessary) in order to retrieve and send information to/from Flickr regarding a photoset.

The class tries to be well behaved and Flickr-server-friendly by using lazy data fetching and caching techniques.

The methods that are available are read/write when the item is alterable via the Flickr API. What that means is that if you call a method with an argument it will set that value while if you call it without any arguments it will give you the current value.

Nevertheless do read on the descriptions of each method for more information on it's usage.

IMPORTANT NOTE: So far the above statement about the methods being read/write is wishfull thinking as I've only implemented the read funcionality. Write is coming soon.

=head1 METHODS

=head2 new

Sets up the structure for usage.

$photoset = Flickr::Photoset->new($my_flickr_api_key,
                              $my_flickr_email,
                              $my_flickr_password);

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
    $me->{data}{id} = $pl->{id} if exists $pl->{id};
    $me->{data}{title} = $pl->{title} if exists $pl->{title};
    $me->{data}{server} = $pl->{server} if exists $pl->{server};
    $me->{data}{secret} = $pl->{secret} if exists $pl->{secret};
    $me->{data}{num_photos} = $pl->{photos} if exists $pl->{photos};
    $me->{data}{description} = $pl->{description} if exists $pl->{description};
    $me->{data}{primary} = $pl->{primary} if exists $pl->{primary};
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

If you call it without any params it just gives you back the ID of the photoset it is currently representing (assuming there is one photoset being represented at this time).

$id = $p->id;

On the other hand, if you call it with a parameter it assumes you wish to represent the photoset whose ID you just passed in and resets itself accordingly, deleting any data it might have had from a previous photoset, and gets the basic information on the photoset you requested.

$ok = $p->id($photoset_id);

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
  $s->_setup_photosets_api;

  return $s->_do_getInfo($params->{id});
}

=head2 title

Returns the title of the photoset.

$title = $p->title;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub title {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{title})) && ($s->{data}{id})) {
    $s->_setup_photosets_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{title};
}

=head2 description

Returns the description of the photoset.

$description = $p->description;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub description {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{description})) && ($s->{data}{id})) {
    $s->_setup_photosets_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{description};
}

=head2 secret

Returns the secret of the photoset (if you have access to it).

$secret = $p->secret;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub secret {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{secret})) && ($s->{data}{id})) {
    $s->_setup_photosets_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{secret};
}

=head2 primary

Returns the ID of the primary photo in this photoset.

$primary = $p->primary;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub primary {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{primary})) && ($s->{data}{id})) {
    $s->_setup_photosets_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{primary};
}

=head2 num_photos

Returns the number of photos in this photoset.

$num_photos = $p->num_photos;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub num_photos {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!exists($s->{data}{num_photos})) && ($s->{data}{id})) {
    $s->_setup_photosets_api;
    $s->_do_getInfo($s->{data}{id});
  }
  
  return $s->{data}{num_photos};
}

=head2 owner

Returns a Flickr::Person object representing the owner of this photoset.

$person = $p->owner;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub owner {
  my $s = shift;
  
  $s->_reset_error;
 
  return $s->{owner} if $s->{owner};
 
  if ((!exists($s->{data}{owner})) && ($s->{data}{id})) {
    $s->_setup_photosets_api;
    $s->_do_getInfo($s->{data}{id});
  }

  if ($s->{data}{owner}) {
    my $owner_params = {api_key => $s->{api_key}};
    if (exists $s->{auth_email}) {
      $owner_params->{email} = $s->{auth_email};
      $owner_params->{password} = $s->{auth_password};
    }
    $owner_params->{pre_load} = $s->{data}{owner};
    $s->{owner} = Flickr::Person->new($owner_params);
  }

  return $s->{owner};
}

=head2 photos

Returns as array of Flickr::Photo objects, representing the photos that belong to this photoset.

$photos = $p->photos;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub photos {
  my $s = shift;
  
  $s->_reset_error;
 
  return $s->{photos} if $s->{photos};
 
  if ((!exists($s->{data}{photos})) && ($s->{data}{id})) {
    $s->_setup_photosets_api;
    $s->_do_getPhotos($s->{data}{id});
  }

  my $photos_params = {api_key => $s->{api_key}};
  if (exists $s->{auth_email}) {
    $photos_params->{email} = $s->{auth_email};
    $photos_params->{password} = $s->{auth_password};
  }
  foreach my $photo_data (@{$s->{data}{photos}}) {
    $photos_params->{pre_load} = $photo_data;
    push (@{$s->{photos}}, Flickr::Photo->new($photos_params));
  }

  return $s->{photos};
}



=head2 _reset_data

Internal method used for reseting the data on the user currently instantiated photoset.

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

=head2 _setup_photosets_api

Internal method used to setup the Flickr::API::Photosets object.

=cut

sub _setup_photosets_api {
  my $s = shift;
  
  if (!exists $s->{photosets_api}) {
    if ($s->{auth_email}) {
      $s->{photosets_api} = Flickr::API::Photosets->new($s->{api_key},
                                                  $s->{auth_email},
                                                  $s->{auth_password});
    }
    else {
      $s->{photosets_api} = Flickr::API::Photosets->new($s->{api_key});
    }
  }
}

=head2 _do_getInfo

Internal method used to parse the result from the Flickr::API::Photosets::getInfo method and fill in our data with it's results.

=cut

sub _do_getInfo {
  my $s = shift;
  my $id = shift;
  
  my $resp = $s->{photosets_api}->getInfo($id);
  if ($resp->{success}) {
    $s->{data}{id} = $resp->{id};
    $s->{data}{title} = $resp->{title};
    $s->{data}{owner}{id} = $resp->{owner};
    $s->{data}{description} = $resp->{description};
    $s->{data}{num_photos} = $resp->{photos};
    $s->{data}{secret} = $resp->{secret};
    $s->{data}{primary} = $resp->{primary};
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

Internal method used to parse the result from the Flickr::API::Photosets::getContext method and fill in our data with it's results.

=cut

sub _do_getContext {
  my $s = shift;
  my $id = shift;
  
  my $resp = $s->{photosets_api}->getContext($id);
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

=head2 _do_getPhotos

Internal method used to parse the result from the Flickr::API::Photosets::getPhotos method and fill in our data with it's results.

=cut

sub _do_getPhotos {
  my $s = shift;
  my $id = shift;
  
  my $resp = $s->{photosets_api}->getPhotos($id);
  if ($resp->{success}) {
    foreach my $photo_data (@{$resp->{photos}}) {
      push (@{$s->{data}{photos}}, $photo_data);
    }
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

<http://www.flickr.com/>, Flickr::Person, Flickr::Photo

=cut

1; # End of Flickr::Photoset
