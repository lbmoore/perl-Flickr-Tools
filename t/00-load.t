use Test::More tests => 8;

BEGIN {
use_ok( 'Flickr::Tools' );
use_ok( 'Flickr::Testing' );
use_ok( 'Flickr::Person' );
use_ok( 'Flickr::Photo' );
use_ok( 'Flickr::Photoset' );
use_ok( 'Flickr::Person' );
use_ok( 'Flickr::Role::Person' );
use_ok( 'Flickr::Types::Person' );
}

diag( "Testing Flickr::Tools $Flickr::Tools::VERSION" );
