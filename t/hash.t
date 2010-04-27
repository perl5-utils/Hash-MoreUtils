#!perl

use strict;
use warnings;

use Test::More 'no_plan';
use Hash::MoreUtils qw(:all);

my %h = (a => 1,
         b => 2,
         c => undef);

is_deeply(
  { slice(\%h, qw(a)) },
  { a => 1 },
  "simple slice",
);

is_deeply(
  { slice(\%h, qw(a d)) },
  { a => 1, d => undef },
  "slice to nonexistent",
);

is_deeply(
  { slice_def(\%h, qw(a c d)) },
  { a => 1 },
  "slice_def undef + nonexistent",
);
ok(!exists $h{d}, "slice_def didn't autovivify d");

is_deeply(
  { slice_exists(\%h, qw(a c d)) },
  { a => 1, c => undef },
  "slice_exists nonexistent",
);
ok(!exists $h{d}, "slice_exists didn't autovivify d");

is_deeply(
  { slice_def \%h },
  { a => 1, b => 2 },
  "slice_def with default keys",
);

is_deeply(
  { slice_grep { $_ gt 'a' } \%h },
  { b => 2, c => undef },
  "slice_grep on keys",
);

is_deeply(
  { slice_grep { $_{$_} && $_{$_} > 1 } \%h },
  { b => 2 },
  "slice_grep on values",
);
