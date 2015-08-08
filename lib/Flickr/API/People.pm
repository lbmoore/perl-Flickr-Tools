package Flickr::API::People;

use warnings;
use strict;
use Carp;

use Flickr::API;
use Flickr::API::Utils;

=head1 NAME

Flickr::API::People - The Perl interface to the Flickr API's flickr.people.* methods.

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';
my $DEBUG;

=head1 SYNOPSIS

    use Flickr::API::People;

    my $flickrpeople = Flickr::API::People->new($my_flickr_api_key);
    
    my $personhash = $flickrpeople->findByUsername($username);
    or
    my $personhash = $flickrpeople->findByEmail($email);

    print $personhash->{'nsid'};
    print $personhash->{'username'};

    my $person_info = $flickrpeople->getInfo($personhash->{id});

=head1 DESCRIPTION

This module maps the Flickr API's flickr.people.* methods.

Each method from the Flickr API has a counterpart method in this class (the one's I've mapped already, that is).

The mapping is done by placing each unique piece of information (name, id, location, etc) on the main-level hash and everything that may have multiple instances (the list of public photos from the user, for instance) on a array inside that main hash.

Mainly I've just tried to use common sense when deciding how to map something. Please feel free to send suggestions or insights on this subject.

Under the hood this class uses the Flickr::API class to handle the actual communication with Flickr's servers.

See the flickr API documentation <http://www.flickr.com/services/api> for the full description of each method and it's return values.


=cut

=head1 METHODS

=head2 new

Takes the Flickr API key as the 'key' parameter and sets up the object for further requests.

$flickrpeople = Flickr::API::People->new($my_flickr_api_ke,
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

=head2 findByUsername

Mapping for the method flickr.people.findByUsername which searches for the person with the username given.

$person = $flickrpeople->findByUsername($username);

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'success' => 1,
  'id' => '12345678@N00',
  'username' => 'Jane Doe',
  'nsid' => '12345678@N00'
};


=cut

sub findByUsername {
  my $s = shift;
  my $username = shift;
  

  croak "I need a username to fetch information on." unless $username;

  my $params = {username => $username};
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }

  my $person = $s->{api}->execute_method('flickr.people.findByUsername',
                                         $params);

  my $result = {};
  if ($s->{utils}->test_return($person, $result)) {

    # Get the basic attributes
    $s->{utils}->get_attributes($person->{tree}{children}[1], $result);

    # Setup the kind of data we are interested in
    my $interesting = {
      username => 'simple_content'
    };

    # Get the actual data
    my $parse_result = $s->{utils}->auto_parse($person->{tree}{children}[1]{children}, $interesting);
    %$result = (%$result, %$parse_result) if $parse_result;
  }
  return $result;
  
}

=head2 findByEmail

Mapping for the method flickr.people.findByEmail which searches for the person with the email given.

$person = $flickrpeople->findByEmail($email);

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'success' => 1,
  'id' => '12345678@N00',
  'username' => 'Jane Doe',
  'nsid' => '12345678@N00'
};

=cut

sub findByEmail {
  my $s = shift;
  my $email = shift;
  

  croak "I need an email to fetch information on." unless $email;

  my $params = {find_email => $email};
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }

  my $person = $s->{api}->execute_method('flickr.people.findByEmail',
                                         $params);

  my $result = {};
  if ($s->{utils}->test_return($person, $result)) {

    # Get the basic attributes
    $s->{utils}->get_attributes($person->{tree}{children}[1], $result);

    # Setup the kind of data we are interested in
    my $interesting = {
      username => 'simple_content'
    };

    # Get the actual data
    my $parse_result = $s->{utils}->auto_parse($person->{tree}{children}[1]{children}, $interesting);
    %$result = (%$result, %$parse_result) if $parse_result;
  }
  return $result;
  
}

=head2 getInfo

Mapping for the method flickr.people.getInfo which fetches the information on the given person.

$personinfo = $flickrpeople->getInfo($user_id);

The result is a hash similar to the following one (for a full list of the return values to expecti and an explanation of the returned values see the documentation on the Flickr API itself):

{
  'isadmin' => '0',
  'realname' => 'Jane Doe',
  'success' => 1,
  'username' => 'JDoe',
  'ispro' => '1',
  'photos' => {
                'firstdate' => '1097663479',
                'count' => '432',
                'firstdatetaken' => '2002-10-26 17:48:14'
              },
  'location' => undef,
  'iconserver' => '1',
  'id' => '12345678@N00',
  'nsid' => '12345678@N00'
}

=cut

sub getInfo {
  my $s = shift;
  my $user_id = shift;
  

  croak "I need a user ID to fetch information on." unless $user_id;

  my $params = {user_id => $user_id};
  if ($s->{auth_email}) {
    $params->{email} = $s->{auth_email};
    $params->{password} = $s->{auth_password};
  }

  my $user_info = $s->{api}->execute_method('flickr.people.getInfo',
                                            $params);

  my $result = {};
  if ($s->{utils}->test_return($user_info, $result)) {

    # Get the basic attributes
    $s->{utils}->get_attributes($user_info->{tree}{children}[1], $result);

    # Setup the kind of data we are interested in
    my $interesting = {
      username => 'simple_content',
      realname => 'simple_content',
      location => 'simple_content',
      photos => {
                  complex => 'array',
                  firstdate => 'simple_content',
                  firstdatetaken => 'simple_content',
                  count => 'simple_content',
                }
    };

    # Get the actual data
    my $parse_result = $s->{utils}->auto_parse($user_info->{tree}{children}[1]{children}, $interesting);
    %$result = (%$result, %$parse_result) if $parse_result;

    # Beautify it a bit
    foreach my $photo (@{$result->{photos}}) {
      foreach my $photo_datum (keys %$photo) {
        $result->{tmp}{$photo_datum} = $photo->{$photo_datum};
      }
    }
    $result->{photos} = $result->{tmp};
    delete $result->{tmp};
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

1; # End of Flickr::API::People
