use strict;
use warnings;
use Test::More;
use Test::TypeTiny;
use Types::Standard qw( HashRef );
use Flickr::Types::Tools qw( FlickrAPI FlickrAPIargs HexNum );


if (defined($ENV{MAKETEST_OAUTH_CFG})) {

#    plan( tests => 9 );
}
else {
#    plan(tests => 7 );
}

my $fileflag=0;
if (-r $config_file) { $fileflag = 1; }

SKIP: {

    skip "Skipping API types, oauth config isn't there or is not readable", 0
        if $fileflag == 0;


}


my $consumer_key = 'cafefeedbeef13579246801234567890';
my $consumer_oop = 'cafefeedbeef1_oh_no_3579246801234567890';


should_pass($consumer_key,  HexNum, 'check good consumer_key against HexNum');
should_fail($consumer_oop,  HexNum, 'check bad  consumer_key against HexNum');



done_testing;

exit;

__END__


# Local Variables:
# mode: Perl
# End:
