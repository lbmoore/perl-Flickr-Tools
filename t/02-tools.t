use strict;
use warnings;
use Test::More;
use Flickr::API;
use Flickr::Tools;
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

my $fileflag=0;
if (-r $config_file) { $fileflag = 1; }
is($fileflag, 1, "Is the config file: $config_file, readable?");


SKIP: {

    skip "Skipping tool tests, oauth config isn't there or is not readable", 8   ##############
        if $fileflag == 0;

    my $toolkit = Flickr::Tools->new({config_file => $config_file, buzzard_bait => "dog food"});

    $toolkit->dump();

    $toolkit->_get_api();

 #   use Data::Dumper::Simple;
 #   warn Dumper($toolkit);

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
