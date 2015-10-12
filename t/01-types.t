use strict;
use warnings;
use Test::More;
use Test::TypeTiny;
use Types::Standard qw( HashRef );
use Flickr::Types qw( PersonSearchDict );

my $emailkey = {'email'    => 'buzz@aldrin.com'};
my $userkey  = {'username' => 'blissfullylost'};

should_pass($emailkey, PersonSearchDict, 'Discern an email person search key');
should_pass($userkey,  PersonSearchDict, 'Discern a username person search key');
should_fail("Some Random String", PersonSearchDict, 'Discern an error in person search key');

my $user = {
    'username' => 'blissfullylost',
    'nsid'     => '123456789@123',
    };

should_pass($user, HashRef, 'Discern user as a hashref');
should_fail($user->{username}, HashRef, 'Discern an error with string user');




done_testing;

exit;

__END__


# Local Variables:
# mode: Perl
# End:
