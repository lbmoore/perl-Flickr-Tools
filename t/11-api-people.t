use Test::More tests => 11;

BEGIN {
  use Flickr::Testing;
  Flickr::Testing::setup;
  
  use_ok( 'Flickr::API::People' );
}


diag("Testing Flickr::API::People");

my $people_api = Flickr::API::People->new('224c32423d423423d4342a3bbb324234e342f234');

isa_ok($people_api, 'Flickr::API::People');

diag("Testing method: flickr.people.findByUsername");

my $res = $people_api->findByUsername('Jane Doe');
is ($res->{success}, 1, 'Call should be successfull');

$expected_result = {
  'id' => '12345678@N00',
  'success' => 1,
  'nsid' => '12345678@N00',
  'username' => 'Jane Doe'
};
is_deeply($res, $expected_result, 'findByUsername');

diag("Testing method: flickr.people.findByEmail");

$res = $people_api->findByEmail('jane.doe@somewhere.net');
is ($res->{success}, 1, 'Call should be successfull');

$expected_result = {
  'id' => '12345678@N00',
  'success' => 1,
  'nsid' => '12345678@N00',
  'username' => 'Jane Doe'
};
is_deeply($res, $expected_result, 'findByEmail');

diag("Testing method: flickr.people.getInfo");

$res = $people_api->getInfo('12345678@N00');
is ($res->{success}, 1, 'Call should be successfull');

is($res->{isadmin}, 0, 'Parsing person: isadmin');
is($res->{realname}, 'Jane Doe', 'Parsing person: realname');
is($res->{photos}{firstdate}, 1071510391, 'Parsing photos: firstdate');
is($res->{photos}{count}, 573, 'Parsing photos: 573');
