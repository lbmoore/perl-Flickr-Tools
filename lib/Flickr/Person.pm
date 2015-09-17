package Flickr::Person;

use warnings;
use strict;
use Carp;

use Flickr::API::People;
use Flickr::API::Photosets;
use Flickr::Photoset;

=head1 NAME

Flickr::Person - Represents a person of Flickr.

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';

=head1 SYNOPSIS

    use Flickr::Person;

    my $flickrperson = Flickr::Person->new($flickr_api_key);

    my $found_person = $flickrperson->find({email => 'john.doe@somewhere.net'});
    if ($found_person) {
      my $username = $flickrperson->username;
      my $userid = $flickrperson->id;
      my $usernsid = $flickrperson->nsid;
      my $real_name = $flickrperson->real_name;
      my $photos_uplodaded = $flickrperson->photo_count;
    }

=head1 DESCRIPTION

This class represents a person on Flickr. It uses the Flickr::API::People class (and other's it finds necessary) in order to retrieve and send information to/from Flickr regarding a single person.

The class tries to be well behaved and Flickr-server-friendly by using lazy data fetching and caching techniques.

The methods that are available are read/write when the item is alterable via the Flickr API. What that means is that if you call a method with an argument it will set that value while if you call it without any arguments it will give you the current value.

Nevertheless do read on the descriptions of each method for more information on it's usage.

IMPORTANT NOTE: So far the above statement about the methods being read/write is wishfull thinking as I've only implemented the read funcionality. Write is coming soon.

=head1 METHODS

=head2 new

Sets up the structure for usage.

$person = Flickr::Person->new({api_key => $my_flickr_api_key,
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
  
  if (exists $params->{pre_load} and
       (exists $params->{pre_load}{id} or
         exists $params->{pre_load}{nsid}))
  {
    $me->{data}{id} = $params->{pre_load}{nsid} if exists $params->{pre_load}{nsid};
    $me->{data}{id} = $params->{pre_load}{id} if exists $params->{pre_load}{id};
    $me->{data}{location} = $params->{pre_load}{location} if exists $params->{pre_load}{location};
    $me->{data}{username} = $params->{pre_load}{username} if exists $params->{pre_load}{username};
    $me->{data}{realname} = $params->{pre_load}{realname} if exists $params->{pre_load}{realname};
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

=head2 find

Finds a person on Flickr and gets the basic information on her.

$found_person = $person->find({email => 'john.doe@somewhere.net'});

OR

$found_person = $person->find({username => 'JaneDoe'});

There are basically two ways to find a person on Flickr: by email or by username.
Depending on what information you have you can choose to use one of the two calls above to do it.

Assuming the person is found, the object will then hole some basic information on the person.
As you later try to access more information the object will do it's best to fetch the required information in real time and present it to you.

Please note that this method resets the object. If you already have information stored about the same or some other user inthis object, calling this method will throw all that information out and start anew.

=cut

sub find {
  my $s = shift;
  my $params = shift;

  $s->_reset_data;
  $s->_reset_error;
  $s->_setup_people_api;

  my $resp;
  if (exists $params->{email}) {
    $resp = $s->{people_api}->findByEmail($params->{email});
  }
  elsif (exists $params->{username}) {
    $resp = $s->{people_api}->findByUsername($params->{username});
  }
  else {
    carp "I need to know what you want me to search for!";
  }

  if ($resp->{success}) {
    $s->{data}{id} = $resp->{id};
    $s->{data}{nsid} = $resp->{nsid};
    $s->{data}{username} = $resp->{username};
  }
  else {
    carp "Got an error from Flickr: ".$resp->{error_message}." (".$resp->{error_code}.")";
    $s->{error}{code} = $resp->{error_code};
    $s->{error}{message} = $resp->{error_message};
    return undef;
  }
}

=head2 username

Returns the username of the user.

$username = $p->username;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub username {
  my $s = shift;
  
  $s->_reset_error;
  
  if ((!$s->{data}{username}) && ($s->{data}{id})) {
    $s->_setup_people_api;
    $s->_do_getInfo($s->{data}{id});
  }

  return $s->{data}{username};
}

=head2 id

This method has two distinct behaviours depending on whether you call it with or without a parameter.

If you call it without any params it just gives you back the ID of the person it is currently representing (assuming there is one person being represented at this time).

$id = $p->id;

On the other hand, if you call it with a parameter it assumes you wish to represent the person whose ID you just passed in and resets itself accordingly, deleting any data it might have had from a previous person, and gets the basic information on the person you requested.

$ok = $p->id({id => $person_id});

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
  $s->_setup_people_api;

  return $s->_do_getInfo($params->{id});
}

=head2 nsid

Returns the nsid of the person.

$nsid = $p->nsid;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub nsid {
  my $s = shift;

  $s->_reset_error;
  
  if ((!$s->{data}{nsid}) && ($s->{data}{id})) {
    $s->_setup_people_api;
    $s->_do_getInfo($s->{data}{id});
  }

  return $s->{data}{nsid};
}

=head2 real_name

Returns the name of the person.

$real_name = $p->real_name;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub real_name {
  my $s = shift;

  $s->_reset_error;

  if ((!$s->{data}{realname}) && ($s->{data}{id})) {
    $s->_setup_people_api;
    $s->_do_getInfo($s->{data}{id});
  }

  return $s->{data}{realname};
}

=head2 is_admin

Indicates if this person is an admin.

$is_admin = $p->is_admin;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub is_admin {
  my $s = shift;

  $s->_reset_error;

  if ((!$s->{data}{isadmin}) && ($s->{data}{id})) {
    $s->_setup_people_api;
    $s->_do_getInfo($s->{data}{id});
  }

  return $s->{data}{isadmin};
}

=head2 is_pro

Indicates if this person is a pro user (has a paid account) on Flickr.

$is_pro = $p->is_pro;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub is_pro {
  my $s = shift;

  $s->_reset_error;

  if ((!$s->{data}{ispro}) && ($s->{data}{id})) {
    $s->_setup_people_api;
    $s->_do_getInfo($s->{data}{id});
  }

  return $s->{data}{ispro};
}

=head2 location

Indicates the geographycal location of the person.

$location = $p->location;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub location {
  my $s = shift;

  $s->_reset_error;

  if ((!$s->{data}{location}) && ($s->{data}{id})) {
    $s->_setup_people_api;
    $s->_do_getInfo($s->{data}{id});
  }

  return $s->{data}{location};
}

=head2 icon_server

Indicates the server which hols the icon for this person (see Buddyicons documentation on Flickr <http://flickr.com/services/api>).

$icon_server = $p->icon_server;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub icon_server {
  my $s = shift;

  $s->_reset_error;

  if ((!$s->{data}{iconserver}) && ($s->{data}{id})) {
    $s->_setup_people_api;
    $s->_do_getInfo($s->{data}{id});
  }

  return $s->{data}{iconserver};
}

=head2 photo_firstdate_posted

Returns the date that the person uploaded the first photo to Flickr.

$photo_firstdate_posted = $p->photo_firstdate_posted;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub photo_firstdate_posted {
  my $s = shift;

  $s->_reset_error;

  if ((!$s->{data}{photos}{firstdate}) && ($s->{data}{id})) {
    $s->_setup_people_api;
    $s->_do_getInfo($s->{data}{id});
  }

  return $s->{data}{photos}{firstdate};
}

=head2 photo_firstdate_taken

Returns the date on which the earliest photo by the person.

$photo_firstdate_taken = $p->photo_firstdate_taken;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub photo_firstdate_taken {
  my $s = shift;

  $s->_reset_error;

  if ((!$s->{data}{photos}{firstdatetaken}) && ($s->{data}{id})) {
    $s->_setup_people_api;
    $s->_do_getInfo($s->{data}{id});
  }

  return $s->{data}{photos}{firstdatetaken};
}

=head2 photo_count

Returns the number of photos this user has posted to Flickr.

$photo_count = $p->photo_count;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub photo_count {
  my $s = shift;

  $s->_reset_error;

  if ((!$s->{data}{photos}{count}) && ($s->{data}{id})) {
    $s->_setup_people_api;
    $s->_do_getInfo($s->{data}{id});
  }

  return $s->{data}{photos}{count};
}

=head2 photosets

Returns an array of Flickr::Photoset objects representing the photosets this user has on Flickr.

$photosets = $p->photosets;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub photosets {
  my $s = shift;

  $s->_reset_error;

  return $s->{photosets} if $s->{photosets};

  if ((!$s->{data}{photosets}) && ($s->{data}{id})) {
    $s->_setup_photosets_api;
    $s->_do_getList($s->{data}{id});
  }

  my $photosets_params = {api_key => $s->{api_key}};
  if (exists $s->{auth_email}) {
    $photosets_params->{email} = $s->{auth_email};
    $photosets_params->{password} = $s->{auth_password};  }
  foreach my $photoset_data (@{$s->{data}{photosets}}) {
    $photosets_params->{pre_load} = $photoset_data;
    push (@{$s->{photosets}}, Flickr::Photoset->new($photosets_params));
  }

  return $s->{photosets};
}

=head2 photos

NOTICE: This function is not yet implemented! Disregard this documentation for now.

$photos = $p->photos;

Always returns undef on error.
Also on error the $p->{error} structure will be defined.

=cut

sub photos {
  my $s = shift;

  $s->_reset_error;

  $s->{error}{code} = 9999;
  $s->{error}{message} = "Method not yet implemented on Flickr::Person";
  return undef;
  
  return $s->{photos} if $s->{photos};

  if ((!$s->{data}{photos}) && ($s->{data}{id})) {
    $s->_setup_photos_api;
    $s->_do_search($s->{data}{id});
  }

  my $photos_params = {api_key => $s->{api_key}};
  if (exists $s->{auth_email}) {
    $photos_params->{email} = $s->{auth_email};
    $photos_params->{password} = $s->{auth_password};  }
  foreach my $photos_data (@{$s->{data}{photos}}) {
    $photos_params->{pre_load} = $photos_data;
    push (@{$s->{photos}}, Flickr::Photo->new($photos_params));
  }

  return $s->{photos};
}


=head2 _reset_data

Internal method used for reseting the data on the user currently instantiated.

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

=head2 _setup_people_api

Internal method used to setup the Flickr::API::People object.

=cut

sub _setup_people_api {
  my $s = shift;
  
  if (!exists $s->{people_api}) {
    if ($s->{auth_email}) {
      $s->{people_api} = Flickr::API::People->new($s->{api_key},
                                                  $s->{auth_email},
						  $s->{auth_password});
    }
    else {
      $s->{people_api} = Flickr::API::People->new($s->{api_key});
    }
  }
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

=head2 do_getInfo

Internal method used to parse the result from the Flickr::API::People::getInfo method and fill in our data with it's results.

=cut

sub _do_getInfo {
  my $s = shift;
  my $id = shift;
  
  my $resp = $s->{people_api}->getInfo($id);
  if ($resp->{success}) {
    $s->{data}{realname} = $resp->{realname};
    $s->{data}{username} = $resp->{username};
    $s->{data}{isadmin} = $resp->{isadmin};
    $s->{data}{ispro} = $resp->{ispro};
    $s->{data}{location} = $resp->{location};
    $s->{data}{iconserver} = $resp->{iconserver};
    $s->{data}{photos}{firstdate} = $resp->{photos}{firstdate};
    $s->{data}{photos}{count} = $resp->{photos}{count};
    $s->{data}{photos}{firstdatetaken} = $resp->{photos}{firstdatetaken};
  }
  else {
    carp "Got an error from Flickr: ".$resp->{error_message}." (".$resp->{error_code}.")";
    $s->{error}{code} = $resp->{error_code};
    $s->{error}{message} = $resp->{error_message};
  }

  return $resp->{success};
}

=head2 do_getList

Internal method used to parse the result from the Flickr::API::Photosets::getList method and fill in our data with it's results.

=cut

sub _do_getList {
  my $s = shift;
  my $id = shift;
  
  my $resp = $s->{photosets_api}->getList($id);
  if ($resp->{success}) {
    foreach my $photoset_data (@{$resp->{photosets}}) {
      push (@{$s->{data}{photosets}}, $photoset_data);
    }
  }
  else {
    carp "Got an error from Flickr: ".$resp->{error_message}." (".$resp->{error_code}.")";
    $s->{error}{code} = $resp->{error_code};
    $s->{error}{message} = $resp->{error_message};
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

<http://www.flickr.com/>, Flickr::Photo, Flickr::Photoset

=cut

1; # End of Flickr::Person
