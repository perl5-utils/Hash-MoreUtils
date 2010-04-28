use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Hash::MoreUtils',
    license             => 'perl',
    dist_author         => q{Hans Dieter Pearcey <hdp@cpan.org>},
    dist_version_from   => 'lib/Hash/MoreUtils.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Hash-MoreUtils-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
