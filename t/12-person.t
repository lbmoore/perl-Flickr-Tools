use Test::More tests => 14;

BEGIN {
  use Flickr::Testing;
  Flickr::Testing::setup;
  
  use_ok( 'Flickr::Person' );
}


diag("Testing Flickr::Person");

my $person = Flickr::Person->new({api_key => '224c32423d423423d4342a3bbb324234e342f234'});

isa_ok($person, 'Flickr::Person');

diag("Testing method: find");

my $ok = $person->find({username => 'Jane Doe'});
ok ($ok, 'find by username');

is ($person->username, 'Jane Doe', 'username method');
is ($person->id, '12345678@N00', 'id method');
is ($person->real_name, 'Jane Doe', 'realname method');
is ($person->is_pro, 1, 'ispro method');
is ($person->photo_firstdate_posted, '1071510391', 'photo_firstdate_posted method');
is ($person->photo_count, 573, 'photo_count method');

diag('Testing method: photosets');

my $photosets = $person->photosets;
ok ($photosets, 'Getting the photosets from the user');
isa_ok ($photosets->[0], 'Flickr::Photoset', 'Correctly getting a photoset from the user');
is ($photosets->[0]->id, 12345, 'Getting the right photoset for a user');

TODO: {
local $TODO = "Not yet implemented in the underlying classes";
diag('Testing method: photos');

my $photos = $person->photos;
ok ($photos, 'Getting the photos from the user');
#use Data::Dumper;
#diag(Dumper $photos);
isa_ok ($photos->[0], 'Flickr::Photo', 'Correctly getting a photo from the user');
#is ($photos->[0]->id, 12345, 'Getting the right photo for a user');
}
