use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Flickr-Tools',
    license             => 'perl',
    dist_author         => 'Nuno Nunes <nfmnunes@cpan.org>',
    dist_version        => '0.02',
    requires => {
        'Test::More' => 0,
        'Test::MockObject' => 0,
        'Flickr::API' => 0,
    },
    add_to_cleanup      => [ 'Flickr-Tools-*' ],
);

$builder->create_build_script();
