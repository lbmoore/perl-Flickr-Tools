use strict;
use warnings;
use Test::More;
use Test::TypeTiny;
use Types::Standard qw( HashRef );
use Flickr::API;
use Flickr::Types::Tools qw( FlickrAPI FlickrAPIargs HexNum );
use Type::Params qw(compile);
use 5.010;

if (defined($ENV{MAKETEST_OAUTH_CFG})) {

#    plan( tests => 9 );
}
else {
#    plan(tests => 7 );
}
my $config_file  = $ENV{MAKETEST_OAUTH_CFG};
my $config_ref;

my $api;

my $fileflag=0;
if (-r $config_file) { $fileflag = 1; }

SKIP: {

    skip "Skipping API types, oauth config isn't there or is not readable", 2
        if $fileflag == 0;

    $api = Flickr::API->import_storable_config($config_file);

    isa_ok($api, 'Flickr::API');

    is($api->is_oauth, 1, 'Does the Flickr::API object identify as OAuth');

    my %config = $api->export_config();

    use Data::Dumper::Simple;
    warn Dumper(%config);
    my $arg2 = argcheck(\%config);
    sub argcheck {
        state $check = compile(FlickrAPIargs);
        my ($args) = $check->(@_);
        return $args
    }

}


my $consumer_key = 'cafefeedbeef13579246801234567890';
my $consumer_oop = 'cafefeedbeef1_oh_no_3579246801234567890';

should_pass($consumer_key,  HexNum, 'check good consumer_key against HexNum');
should_fail($consumer_oop,  HexNum, 'check bad consumer_key against HexNum');



done_testing;

exit;

__END__


# Local Variables:
# mode: Perl
# End:
