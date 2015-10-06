use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Flickr::Tools',
    AUTHOR              => 'Louis B. Moore <lbmoore@cpan.org>',
    VERSION_FROM        => 'lib/Flickr/Tools.pm',
    ABSTRACT_FROM       => 'lib/Flickr/Tools.pm',
    PL_FILES            => {},
    'META_MERGE'        => {
        resources => {
            repository  =>  'https://github.com/lbmoore/perl-Flickr-Tools',
        },
    },
    PREREQ_PM => {
        'Test::More' => 0,
        'Flickr::API' => 0,
        'Carp' => 0,
        'Moo' => 0,
        'namespace::clean' => 0,
        'Type::Library' => 0,
        'Type::Utils' => 0,
        'Types::Standard' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Flickr-Tools-*' },
);
