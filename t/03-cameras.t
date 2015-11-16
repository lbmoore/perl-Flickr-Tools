use strict;
use warnings;
use Test::More tests => 19;
use Flickr::Tools::Cameras;
use 5.010;


my $config_file  = $ENV{MAKETEST_OAUTH_CFG};
my $config_ref;

my $brands;
my $models;


eval {

    my $tool = Flickr::Tools::Cameras->new(['123deadbeef456','MyUserName']);

};

isnt($@, undef, 'Did we fail to create object with bad args: Anon Array');



my $tool = Flickr::Tools::Cameras->new(
    { consumer_key    => '012345beefcafe543210',
      consumer_secret => 'a234b345c456feed',
  }
);

isa_ok($tool, 'Flickr::Tools::Cameras');

is(
    $tool->_api_name,
    "Flickr::API::Cameras",
    'Are we looking for the correct API'
);



is(
    $tool->consumer_key,
    '012345beefcafe543210',
    'Did we get back our test consumer_key'
);


is(
    $tool->has_api,
    '',
    'Are we appropriately missing a Flickr::API::Cameras object'
);

my $api = $tool->api;


isa_ok($api, $tool->_api_name);

is(
    $api->is_oauth,
    1,
    'Now that we have one, does Flickr::API::Cameras object identify as OAuth'
);


my $rsp =  $api->execute_method('flickr.test.echo', { 'foo' => 'barred' } );
my $ref = $rsp->as_hash();


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
            unless defined($config_file);

        if (-r $config_file) { $fileflag = 1; }
        is($fileflag, 1, "Is the config file: $config_file, readable?");

}

  SKIP: {

        skip "Skipping camera tests, oauth config isn't there or is not readable", 7
            if $fileflag == 0;

        $tool = Flickr::Tools::Cameras->new({config_file => $config_file});

        is(
            $tool->has_api,
            '',
            'Are we appropriately missing a Flickr::API::Cameras object'
        );

        my $api = $tool->api;

        isnt(
            $tool->has_api,
            '',
            'Do we have a Flickr::API::Cameras object now'
        );

        $tool->_clear_api;

        is(
            $tool->has_api,
            '',
            'Are we appropriately missing a Flickr::API::Cameras object, again'
        );


        $api = $tool->api;


        isa_ok(
            $tool,
            'Flickr::Tools::Cameras'
        );

        $brands = $tool->getBrands;

        is(ref($brands), 'HASH', 'did we get a hashref by default');

        $brands = $tool->getBrands({list_type => 'List'});

        is(ref($brands), 'ARRAY', 'did we get an arrayref when asked for one');

        $models = $tool->getBrandModels({Brand => 'Nikon'});

        is(ref($models), 'HASH', 'did we get a hashref by default');

    }
}

done_testing;

exit;

__END__


# Local Variables:
# mode: Perl
# End:
