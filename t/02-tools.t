use strict;
use warnings;
use Test::More;
use Flickr::API;
use Flickr::Tools;
use Flickr::Roles::Permissions;
use 5.010;

if (defined($ENV{MAKETEST_OAUTH_CFG}) && defined ($ENV{MAKETEST_VALUES})) {

#    plan( tests => 9 );
}
else {
    plan(skip_all => 'Person tests require that MAKETEST_OAUTH_CFG and MAKETEST_VALUES are defined, see README.');
}


my $config_file  = $ENV{MAKETEST_OAUTH_CFG};
my $config_ref;

my $api;
my $ref;
my $rsp;

eval {

    my $tool = Flickr::Tools->new(['123deadbeef456','MyUserName']);

};

isnt($@, undef, 'Did we fail to create object with bad args: Anon Array');


eval {

    my $tool = Flickr::Tools->new();

};

isnt($@, undef, 'Did we fail to create object with bad args: no args at all');

eval {

    my $tool = Flickr::Tools->new('/home/nobody/home/where/is/that_file.wrong');

};

isnt($@, undef, 'Did we fail to create object with bad args: file not there');

eval {

    my $tool = Flickr::Tools->new(
        { version  => '1.0',
          rest_uri => 'https://api.flickr.com/services/rest/',
      }
    );

};

isnt($@, undef, 'Did we fail to create object with bad args: no consumer_key');

my $tool = Flickr::Tools->new(
    { consumer_key    => '012345beefcafe543210',
      consumer_secret => 'a234b345c456feed',
  }
);

isa_ok($tool, 'Flickr::Tools');

is(
    $tool->api_name,
    "Flickr::API",
    'Are we looking for the correct API'
);

is(
    $tool->consumer_key,
    '012345beefcafe543210',
    'Did we get back our test consumer_key'
);

is(
    $tool->consumer_secret,
    'a234b345c456feed',
    'Did we get back our test consumer_secret'
);

is(
    $tool->auth_uri,
    'https://api.flickr.com/services/oauth/authorize',
    'Did we get back the default oauth authorization uri'
);

is(
    $tool->request_method,
    'GET',
    'Did we get back the default request method'
);

is(
    $tool->rest_uri,
    'https://api.flickr.com/services/rest/',
    'Did we get back the default rest uri'
);

is(
    $tool->request_url,
    'https://api.flickr.com/services/rest/',
    'Did we get back the default request url'
);


is(
    $tool->signature_method,
    'HMAC-SHA1',
    'Did we get back the default oauth signature method'
);

is(
    $tool->unicode,
    0,
    'Did we get back the default unicode setting'
);

is(
    $tool->version,
    '1.0',
    'Did we get back the default api version in our tool'
);

is(
    $tool->has_api,
    '',
    'Are we appropriately missing a Flickr::API object'
);

$api = $tool->api;

isa_ok($api, $tool->api_name);

is($api->is_oauth, 1, 'Does Flickr::API object identify as OAuth');

$rsp =  $api->execute_method('flickr.test.echo', { 'foo' => 'barred' } );
$ref = $rsp->as_hash();


SKIP: {
    skip "skipping method call check, since we couldn't reach the API", 2
        if $rsp->rc() ne '200';
    is($ref->{'stat'}, undef, 'Check for no status from flickr.test.echo');
    is($ref->{'foo'}, undef, 'Check for no result result from flickr.test.echo');
    is($tool->connects, 0, 'Check that we cannot connect with invalid key');
    is($tool->permissions, 'none', "Note that we have no permissions");
}


undef $api;
undef $rsp;
undef $ref;
undef $tool;



my $fileflag=0;
if (-r $config_file) { $fileflag = 1; }
is($fileflag, 1, "Is the config file: $config_file, readable?");

SKIP: {

    skip "Skipping tool api tests, oauth config isn't there or is not readable", 8   ##############
        if $fileflag == 0;

    $tool = Flickr::Tools->new({config_file => $config_file, test_more_bait => "Find Me iF you can."});

    isa_ok($tool, 'Flickr::Tools');

    is(
        $tool->has_api,
        '',
        'We should not have an API object... yet'
    );

    $api = $tool->api;

    isa_ok($api, $tool->api_name);

    is($tool->connects, 1, 'Check if we can connect with a (we trust) valid key');
    isnt($tool->permissions, 'none', 'Check that we have some kind of permission');




#    $tool->_clear_api;

#    $tool->_build_api;

#    $tool->dump();

#    my $test1 = $tool->_get_api();

#    my $test2 = $tool->_get_api({ API => 'Flickr::API::Cameras'});

#    use Data::Dumper::Simple;
#    warn Dumper($test1,$test2);

#    $api = Flickr::API->import_storable_config($config_file);

  #  isa_ok($api, 'Flickr::API');

  #  is($api->is_oauth, 1, 'Does the Flickr::API object for this person identify as OAuth');
  #  is($api->api_success,  1, 'Did api initialize successfully');



}

#my $tool = Flickr::Tools->new({api => $api});

done_testing;

exit;

__END__


# Local Variables:
# mode: Perl
# End:
