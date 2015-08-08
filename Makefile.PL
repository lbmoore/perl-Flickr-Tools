use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Flickr-Tools',
    AUTHOR              => 'Nuno Nunes <nfmnunes@cpan.org>',
    VERSION             => '0.02',
    ABSTRACT            => 'Higher-level interface to Flickr data.',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Test::MockObject' => 0,
        'Flickr::API' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Flickr-Tools-*' },
);
