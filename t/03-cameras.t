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

my $tool;
my $brands;
my $models;

#$tool =  Flickr::Tools->new({ ignore => "this one"});
#
#isa_ok(
#    $tool,
#    'Flickr::Tools'
#);

#$tool =  Flickr::Tools::Cameras->new({ ignore => "this one"});
#
#isa_ok(
#    $tool,
#    'Flickr::Tools::Cameras'
#);









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
