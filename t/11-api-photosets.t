use Test::More tests => 16;

BEGIN {
  use Flickr::Testing;
  Flickr::Testing::setup;

  use_ok( 'Flickr::API::Photosets' );
}

diag("Testing Flickr::API::Photosets");

my $photosets_api = Flickr::API::Photosets->new('224c32423d423423d4342a3bbb324234e342f234');

isa_ok($photosets_api, 'Flickr::API::Photosets');

diag("Testing method: flickr.photosets.getList");

my $res = $photosets_api->getList('12345678@N00');
is ($res->{success}, 1, 'Call should be successfull');

my $set_id;
foreach my $set (@{$res->{photosets}}) {
  if ($set->{title} eq 'Test1') {
    $set_id = $set->{id};
  }
}

is ($set_id, '12345', 'getList');

diag("Testing method: flickr.photosets.getPhotos");

$res = $photosets_api->getPhotos(12345);
is ($res->{success}, 1, 'Call should be successfull');


my $primary_photo;
foreach my $photo (@{$res->{photos}}) {
  if ($photo->{isprimary}) {
    $primary_photo = $photo->{id};
    last;
  }
}

ok ($primary_photo, 'getPhotos');
is ($primary_photo, $res->{primary}, 'getPhotos');

diag("Testing method: flickr.photosets.getInfo");

$res = $photosets_api->getInfo(12345);
is ($res->{success}, 1, 'Call should be successfull');

is($res->{id}, 12345, 'Parsing info: id');
is($res->{primary}, 866554, 'Parsing info: primary');
is($res->{title}, "A great test photoset", 'Parsing info: title');

diag("Testing method: flickr.photosets.getContext");

$res = $photosets_api->getContext(866543, 12345);
is ($res->{success}, 1, 'Call should be successfull');

is($res->{prevphoto}{id}, 866542, 'Parsing previous photo: id');
is($res->{nextphoto}{id}, 866544, 'Parsing next photo: id');
is($res->{prevphoto}{title}, "The previous photo in the set.", 'Parsing previous photo: title');
is($res->{nextphoto}{secret}, "d34db33f", 'Parsing next photo: secret');

