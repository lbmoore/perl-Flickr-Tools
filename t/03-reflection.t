use strict;
use warnings;
use Test::More tests => 18;
use Flickr::Tools::Reflection;
use 5.010;




my $config_file;

if (defined($ENV{MAKETEST_OAUTH_CFG}) && defined ($ENV{MAKETEST_VALUES})) {

    $config_file  = $ENV{MAKETEST_OAUTH_CFG};

}
else {

    diag( 'No MAKETEST_OAUTH_CFG or MAKETEST_VALUES, shallow tests only' );
    $config_file  =  '/no/file/by/this/name.is.there?';
}


my $config_ref;

my $api;
my $ref;
my $rsp;

eval {

    my $tool = Flickr::Tools::Reflection->new(['123deadbeef456','MyUserName']);

};

isnt(
    $@,
    undef,
    'Did we fail to create object with bad args: Anon Array'
);

my $tool = Flickr::Tools::Reflection->new(
    { consumer_key    => '012345beefcafe543210',
      consumer_secret => 'a234b345c456feed',
  }
);

isa_ok($tool, 'Flickr::Tools::Reflection');

is(
    $tool->_api_name,
    "Flickr::API::Reflection",
    'Are we looking for the correct API'
);

is(
    $tool->has_api,
    '',
    'Are we appropriately missing a Flickr::API object'
);

$api = $tool->api;

isa_ok($api, $tool->_api_name);

is(
    $api->is_oauth,
    1,
    'Does Flickr::API object identify as OAuth'
);


$rsp =  $api->execute_method('flickr.test.echo', { 'foo' => 'barred' } );
$ref = $rsp->as_hash();


SKIP: {
    skip "skipping method call checks, since we couldn't reach the API", 12
        if $rsp->rc() ne '200';
    is(
        $ref->{'stat'},
        undef,
        'Check for no status from flickr.test.echo'
    );
    is(
        $ref->{'foo'},
        undef,
        'Check for no result from flickr.test.echo'
    );
    is(
        $tool->connects,
        0,
        'Check that we cannot connect with invalid key'
    );
    is(
        $tool->permissions,
        'none',
        "Note that we have no permissions"
    );

    my $fileflag=0;

  SKIP: {

        skip 'Skipping config file test, config file not defined', 1
            unless defined($config_file) && (-r $config_file) ;

        if (-r $config_file) { $fileflag = 1; }
        is($fileflag, 1, "Is the config file: $config_file, readable?");

    }

  SKIP: {

        skip "Skipping reflection tests, oauth config isn't there or is not readable", 7
            if $fileflag == 0;

        $tool = Flickr::Tools::Reflection->new({config_file => $config_file});

        is(
            $tool->has_api,
            '',
            'Are we appropriately missing a Flickr::API::Reflection object'
        );

        my $api = $tool->api;

        isnt(
            $tool->has_api,
            '',
            'Do we have a Flickr::API::Reflection object now'
        );

        $tool->_clear_api;

        is(
            $tool->has_api,
            '',
            'Are we appropriately missing a Flickr::API::Reflection object, again'
        );


        $api = $tool->api;


        isa_ok(
            $tool,
            'Flickr::Tools::Reflection'
        );

        my $methods = $tool->getMethods;

        is(ref($methods), 'HASH', 'did we get a hashref by default');

        $methods = $tool->getMethods({list_type => 'List'});

        is(ref($methods), 'ARRAY', 'did we get an arrayref when asked for one');

        my $method = $tool->thisMethod('flickr.reflection.getMethodInfo');

        is(ref($method), 'HASH', 'did we get a hashref by default');

    }
}


exit;

__END__


# Local Variables:
# mode: Perl
# End:
