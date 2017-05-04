#!perl

use strict;
use warnings;

use Hash::MoreUtils qw(:all);

my %h = (a => 1,
         b => 2,
         c => undef);
my %r;

for (1..10000)
{
%r = slice(\%h, qw(a));

%r = slice(\%h, qw(a d));

%r = slice(\%h);

%r = slice_def(\%h, qw(a c d));

%r = slice_exists(\%h, qw(a c d));

%r = slice_exists(\%h);

%r = slice_def \%h;

%r = slice_grep { $_ gt 'a' } \%h;

%r = slice_grep { $_{$_} && $_{$_} > 1 } \%h;

# slice_map and friends

%r = slice_map(\%h, (a => "A"));

%r = slice_map(\%h, (a => "A", d => "D"));

%r = slice_map(\%h);

%r = slice_def_map(\%h, (a => "A", c => "C", d => "D"));
%r = slice_exists_map(\%h, (a => "A", c => "C", d => "D"));
%r = slice_exists_map(\%h);

%r = slice_def_map \%h;

%r = slice_grep_map { $_ gt 'a' } \%h, (a => "A", b => "B", c => "C");

%r = slice_grep_map { $_{$_} && $_{$_} > 1 } \%h, (a => "A", b => "B", c => "C");

# hashsort and safe_reverse

%r = hashsort \%h;

my %he = slice_def(\%h);
%r = safe_reverse(\%he);

%he = ( a => 1, b => 1 );
my %hec = safe_reverse(\%he);
}
