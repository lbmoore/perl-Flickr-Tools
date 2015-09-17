use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Flickr-Tools',
    AUTHOR              => 'Louis Moore <lbmoore@cpan.org>',
    VERSION             => '0.04',
    ABSTRACT            => 'Being migrated into Flickr::API.',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Test::MockObject' => 0,
        'Flickr::API' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Flickr-Tools-*' },
);
