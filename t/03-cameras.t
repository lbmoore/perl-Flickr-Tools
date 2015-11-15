use strict;
use warnings;
use Test::More;
use Flickr::Tools::Cameras;
use 5.010;

if (defined($ENV{MAKETEST_OAUTH_CFG}) && defined ($ENV{MAKETEST_VALUES})) {

#    plan( tests => 9 );
}
else {
    plan(skip_all => 'Cameras  require that MAKETEST_OAUTH_CFG and MAKETEST_VALUES are defined, see README.');
}


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
    'Does Flickr::API::Cameras object identify as OAuth'
);




my $rsp =  $api->execute_method('flickr.test.echo', { 'foo' => 'barred' } );
my $ref = $rsp->as_hash();


SKIP: {
    skip "skipping method call check, since we couldn't reach the API", 2
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
}

my $fileflag=0;
if (-r $config_file) { $fileflag = 1; }
is($fileflag, 1, "Is the config file: $config_file, readable?");

SKIP: {

    skip "Skipping camera tests, oauth config isn't there or is not readable", 8   ##############
        if $fileflag == 0;

    $tool = Flickr::Tools::Cameras->new({config_file => $config_file});

       if ($tool->has_api) {

        say "1c) has_api is true";

    }
    else {

        say "1c) has_api is false";

        my $api = $tool->api;

    }

    if ($tool->has_api) {

        say "2c) has_api is true";

        $tool->_clear_api;

    }
    else {

        say "2c) has_api is false";

    }


    if ($tool->has_api) {

        say "3c) has_api is true";

    }
    else {

        say "3c) has_api is false";

    }

    my $api = $tool->api;


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

done_testing;

exit;

__END__


# Local Variables:
# mode: Perl
# End:
