package Hash::MoreUtils;

use strict;
use warnings;
use Scalar::Util qw(blessed);

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  all => [ qw(slice slice_def slice_exists slice_grep
              hashsort
            ) ],
);

our @EXPORT_OK = (@{ $EXPORT_TAGS{all} });

our $VERSION = '0.01';

=head1 NAME

Hash::MoreUtils - Provide the stuff missing in Hash::Util

=head1 SYNOPSIS

  use Hash::MoreUtils qw(slice slice_def slice_exists slice_grep
                         hashsort
                        );

=head1 DESCRIPTION

Similar to C<< List::MoreUtils >>, C<< Hash::MoreUtils >>
contains trivial but commonly-used functionality for hashes.

=head3 C<slice> HASHREF, LIST

Returns a hash containing the (key, value) pair for every
key in LIST.

=head3 C<slice_def> HASHREF, LIST

As C<slice>, but only includes keys whose values are
defined.

=head3 C<slice_exists> HASHREF, LIST

As C<slice> but only includes keys which exist in the
hashref.

=head3 C<slice_grep> BLOCK HASHREF, LIST

As C<slice>, with an arbitrary condition.

Unlike C<grep>, the condition is not given aliases to
elements of anything.  Instead, C<< %_ >> is set to the
contents of the hashref, to avoid accidentally
auto-vivifying when checking keys or values.  Also,
'uninitialized' warnings are turned off in the enclosing
scope.

=cut

sub slice_grep (&@);

sub slice {
  return slice_grep { 1 } @_;
}

sub slice_def {
  return slice_grep {
    defined $_{$_}
  } @_;
}

sub slice_exists {
  return slice_grep {
    exists $_{$_}
  } @_;
}

sub slice_grep (&@) {
  my ($code, $hash, @keys) = @_;
  local %_ = %{$hash};
  @keys = keys %_ unless @keys;
  no warnings 'uninitialized';
  return map {
    ($_ => $_{$_})
  } grep { $code->($_) } @keys;
}

=head3 C<< hashsort >>

  my @array_of_pairs  = hashsort \%hash;
  my @pairs_by_length = hashsort sub { length($a) <=> length($b) }, \%hash;

Returns the (key, value) pairs of the hash, sorted by some
property of the keys.  By default, sorts the keys with C<<
cmp >>.

I'm not convinced this is useful yet.  If you can think of
some way it could be more so, please let me know.

=cut

sub hashsort {
  my ($code, $hash) = @_;
  unless ($hash) {
    $hash = $code;
    $code = sub { $a cmp $b };
  }
  return map {
    ($_ => $hash->{$_})
  } sort {
    $code->()
  } keys %$hash;
}

1;

=head1 AUTHOR

Hans Dieter Pearcey, C<< <hdp@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-hash-moreutils@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Hash-MoreUtils>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2005 Hans Dieter Pearcey, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Hash::MoreUtils
