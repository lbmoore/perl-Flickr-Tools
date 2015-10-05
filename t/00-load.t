use Test::More tests => 4;

BEGIN {
use_ok( 'Flickr::Tools' );
use_ok( 'Flickr::Person' );
use_ok( 'Flickr::Type' );
use_ok( 'Flickr::Photo' );
use_ok( 'Flickr::Photoset' );
use_ok( 'Flickr::Person' );
}

diag( "Testing Flickr::Tools $Flickr::Tools::VERSION" );
