use strict;
use warnings;
use Test::More;
use Flickr::API::People;
use Flickr::Tools::Person;

if (defined($ENV{MAKETEST_OAUTH_CFG}) && defined ($ENV{MAKETEST_VALUES})) {

#    plan( tests => 9 );
}
else {
    plan(skip_all => 'Person tests require that MAKETEST_OAUTH_CFG and MAKETEST_VALUES are defined, see README.');
}


my $config_file  = $ENV{MAKETEST_OAUTH_CFG};
my $config_ref;

my $api;
my $person;

my %peoplevalues = (
    'search_email' => '',
    'search_user'  => '',
);

my $fileflag=0;
if (-r $config_file) { $fileflag = 1; }
is($fileflag, 1, "Is the config file: $config_file, readable?");


SKIP: {

    skip "Skipping person tests, oauth config isn't there or is not readable", 8   ##############
        if $fileflag == 0;

    $api = Flickr::API::People->import_storable_config($config_file);

    isa_ok($api, 'Flickr::API::People');

    is($api->is_oauth, 1, 'Does the Flickr::API::People object for this person identify as OAuth');
    is($api->api_success,  1, 'Did people api initialize successful for this person');


    my $values_file  = $ENV{MAKETEST_VALUES};

    $person = Flickr::Tools::Person->new({api => $api, searchkey => {email => 'spud@nowhere.nohow.noway.no'}});
    isa_ok($person, 'Flickr::Person');

    is($person->exists, 0, 'Was the Flickr::Tools::Person a properly unsuccessful Flickr::Person');

    my $valsflag=0;
    if (-r $values_file) { $valsflag = 1; }
    is($valsflag, 1, "Is the values file: $values_file, readable?");

  SKIP: {
        skip "Skipping some person tests, values file isn't there or is not readable", 2   ##########
            if $valsflag == 0;

        open my $VALUES, "<", $values_file or die;

        while (<$VALUES>) {

            chomp;
            s/\s+//g;
            my ($key,$val) = split(/=/);
            if (defined($peoplevalues{$key})) { $peoplevalues{$key} = $val; }

        }
      SKIP: {
            skip "Skipping email search tests, no email in values file", 1
                if $peoplevalues{'search_email'} eq '';

            $person = Flickr::Person->new({api => $api, searchkey => {email => $peoplevalues{'search_email'}}});

            is($person->exists, 1, 'Does the email searched Flickr::Person exist');


            my $info = $person->getInfo();

        }
      SKIP: {
            skip "Skipping username search tests, no username in values file", 1
                if $peoplevalues{'search_user'} eq '';

            $person = Flickr::Tools::Person->new({api => $api, searchkey => {username => $peoplevalues{'search_user'}}});

            is($person->exists, 1, 'Does the username searched Flickr::Tools::Person exist');

            my $groups = $person->getGroups({extras => [qw(privacy throttle)]});

        }
    } # vals File
}

done_testing;

exit;

__END__


# Local Variables:
# mode: Perl
# End:
