use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Flickr::Tools',
    AUTHOR              => 'Louis B. Moore <lbmoore@cpan.org>',
    VERSION_FROM        => 'lib/Flickr/Tools.pm',
    ABSTRACT_FROM       => 'lib/Flickr/Tools.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Flickr::API' => 0,
        'Moo' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Flickr-Tools-*' },
);
