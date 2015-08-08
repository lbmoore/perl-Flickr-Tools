use Test::More tests => 40;

BEGIN {
  use Flickr::Testing;
  Flickr::Testing::setup;

  use_ok( 'Flickr::API::Photos' );
}

diag("Testing Flickr::API::Photos");

my $photos_api = Flickr::API::Photos->new('224c32423d423423d4342a3bbb324234e342f234');
my $auth_photos_api = Flickr::API::Photos->new('224c32423d423423d4342a3bbb324234e342f234',
                                               'test@user.net',
                                               'password');

isa_ok($photos_api, 'Flickr::API::Photos');
isa_ok($auth_photos_api, 'Flickr::API::Photos');

diag("Testing method: flickr.photos.getInfo");

my $res = $photos_api->getInfo(123456);
is ($res->{success}, 1, 'Call should be successfull');

is ($res->{id}, 123456, 'Parsing attributes: id');
is ($res->{secret}, 'ae146eb33f', 'Parsing attributes: secret');
is ($res->{owner}{username}, 'John Doe', 'Parsing ownwe: username');
is ($res->{title}, 'Testing photo title', 'Parsing elements: title');
is ($res->{description}, 'A test photo. Please disregard.', 'Parsing elements: description');
is ($res->{comments}, 2, 'Parsing elements: comments');
is ($res->{visibility}{ispublic}, 1, 'Parsing visibility: ispublic');
is ($res->{dates}{taken}, '2004-10-05 16:08:12', 'Parsing dates: taken');
is ($res->{editability}{canaddmeta}, 0, 'Parsing editability: canaddmeta');

ok (defined $res->{notes}, 'Has notes');
my $note_author;
my $note_value;
foreach my $note (@{$res->{notes}}) {
  next unless $note->{id} == 612899;
  $note_author = $note->{author};
  $note_value = $note->{value};
  last;
}
ok (defined $note_author, 'There note that we were looking for was there');
is ($note_author, '12345678@N00', 'Parsing notes: author');
is ($note_value, 'An interesting tidbit.', 'Parsing notes: content');

ok (defined $res->{tags}, 'Has tags');
my $tag_author;
my $tag_value;
foreach my $tag (@{$res->{tags}}) {
  next unless $tag->{id} == 2360158;
  $tag_author = $tag->{author};
  $tag_value = $tag->{value};
  last;
}
ok (defined $tag_author, 'There tag that we were looking for was there');
is ($tag_author, '12345678@N00', 'Parsing tags: author');
is ($tag_value, 'test3', 'Parsing tags: content');

diag("Testing method: flickr.photos.getExif");

$res = $photos_api->getExif(851195);
is ($res->{success}, 1, 'Call should be successfull');

is($res->{photo_data}{server}, 1, "getExif values");

my $camera_model;
foreach my $tag (@{$res->{tags}}) {
  $camera_model = $tag->{raw} if $tag->{label} eq 'Model';
}

is($camera_model, 'Canon EOS 10D', 'getExif tag');

diag("Testing method: flickr.photos.getContext");

$res = $photos_api->getContext(851195);
is ($res->{success}, 1, 'Call should be successfull');

is($res->{prevphoto}{id}, 851194, 'Parsing previous photo: ID');
is($res->{nextphoto}{id}, 851196, 'Parsing next photo: ID');
is($res->{prevphoto}{title}, 'A Previous photo.', 'Parsing previous photo: title');
is($res->{nextphoto}{title}, 'A Next photo.', 'Parsing next photo: title');

diag("Testing method: getSizes");

$res = $photos_api->getSizes(851195);
is ($res->{success}, 1, 'Call should be successfull');

my $square_width;
my $thumbnail_height;
my $small_source;
my $medium_url;
my $original_label;
foreach my $size (@{$res->{sizes}}) {
  if ($size->{label} eq 'Square') {
    $square_width = $size->{width};
  }
  elsif ($size->{label} eq 'Thumbnail') {
    $thumbnail_height = $size->{height};
  }
  elsif ($size->{label} eq 'Small') {
    $small_source = $size->{source};
  }
  elsif ($size->{label} eq 'Medium') {
    $medium_url = $size->{url};
  }
  elsif ($size->{label} eq 'Original') {
    $original_label = $size->{label};
  }
}

is($square_width, 75, 'Parsing size: width');
is($thumbnail_height, 100, 'Parsing size: height');
is($small_source, 'http://photos1.flickr.com/851195_ae146eb33f_m.jpg', 'Parsing size: source');
is($medium_url, 'http://www.flickr.com/photo_zoom.gne?id=851195&amp;size=m', 'Parsing size: url');
is($original_label, 'Original', 'Parsing size: label');

diag("Testing method: getPerms");

$res = $photos_api->getPerms(851195);
is($res->{success}, 0, 'Should fail when not authenticated');

$res = $auth_photos_api->getPerms(851195);
is($res->{success}, 1, 'When authenticated it should work!');

is($res->{perms}{id}, 851195, 'Parsing permissions: id');
is($res->{perms}{ispublic}, 1, 'Parsing permissions: isfriend');
is($res->{perms}{permcomment}, 0, 'Parsing permissions: permaddcomment');
