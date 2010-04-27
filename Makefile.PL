use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Hash::MoreUtils',
    AUTHOR              => 'Hans Dieter Pearcey <hdp@cpan.org>',
    VERSION_FROM        => 'lib/Hash/MoreUtils.pm',
    ABSTRACT_FROM       => 'lib/Hash/MoreUtils.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Hash-MoreUtils-*' },
);
