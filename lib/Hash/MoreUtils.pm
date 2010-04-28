package Hash::MoreUtils;

use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $VERSION);
use Scalar::Util qw(blessed);

require Exporter;

@ISA = qw(Exporter);

%EXPORT_TAGS = (
    all => [
        qw(slice slice_def slice_exists slice_grep
           hashsort safe_reverse
          )
    ],
);

@EXPORT_OK = ( @{ $EXPORT_TAGS{all} } );

$VERSION = '0.02';

=head1 NAME

Hash::MoreUtils - Provide the stuff missing in Hash::Util

=head1 SYNOPSIS

  use Hash::MoreUtils qw(slice slice_def slice_exists slice_grep
                         hashsort
                        );

=head1 DESCRIPTION

Similar to C<< List::MoreUtils >>, C<< Hash::MoreUtils >>
contains trivial but commonly-used functionality for hashes.

=head1 FUNCTIONS

=head2 C<slice> HASHREF[, LIST]

Returns a hash containing the (key, value) pair for every
key in LIST.

=head2 C<slice_def> HASHREF[, LIST]

As C<slice>, but only includes keys whose values are
defined.

=head2 C<slice_exists> HASHREF[, LIST]

As C<slice> but only includes keys which exist in the
hashref.

=head2 C<slice_grep> BLOCK, HASHREF[, LIST]

As C<slice>, with an arbitrary condition.

Unlike C<grep>, the condition is not given aliases to
elements of anything.  Instead, C<< %_ >> is set to the
contents of the hashref, to avoid accidentally
auto-vivifying when checking keys or values.  Also,
'uninitialized' warnings are turned off in the enclosing
scope.

=cut

sub slice_grep (&@);

sub slice
{
    my ( $href, @list ) = @_;
    if( @list )
    {
	return map { $_ => $href->{$_} } @list;
    }
    %{$href};
}

sub slice_exists
{
    my ( $href, @list ) = @_;
    if( @list )
    {
	return map { $_ => $href->{$_} } grep {exists( $href->{$_} ) } @list;
    }
    %{$href};
}

sub slice_def
{
    my ( $href, @list ) = @_;
    @list = keys %{$href} unless @list;
    return map { $_ => $href->{$_} } grep { defined( $href->{$_} ) } @list;
}

sub slice_grep (&@)
{
    my ( $code, $hash, @keys ) = @_;
    local %_ = %{$hash};
    @keys = keys %_ unless @keys;
    no warnings 'uninitialized';
    return map { ( $_ => $_{$_} ) } grep { $code->($_) } @keys;
}

=head2 C<hashsort> [BLOCK,] HASHREF

  my @array_of_pairs  = hashsort \%hash;
  my @pairs_by_length = hashsort sub { length($a) <=> length($b) }, \%hash;

Returns the (key, value) pairs of the hash, sorted by some
property of the keys.  By default (if no sort block given), sorts the
keys with C<cmp>.

I'm not convinced this is useful yet.  If you can think of
some way it could be more so, please let me know.

=cut

sub hashsort
{
    my ( $code, $hash ) = @_;
    unless ($hash)
    {
        $hash = $code;
        $code = sub { $a cmp $b };
    }
    return map { ( $_ => $hash->{$_} ) } sort { $code->() } keys %$hash;
}

=head2 C<safe_reverse> [BLOCK,] HASHREF

  my %dup_rev = safe_reverse \%hash

  sub croak_dup {
      my ($k, $v, $r) = @_;
      exists( $r->{$v} ) and
        croak "Cannot safe reverse: $v would be mapped to both $k and $r->{$v}";
      $v;
  };
  my %easy_rev = save_reverse \&croak_dup, \%hash

Returns safely reversed hash (value, key pairs of original hash). If no
C<< BLOCK >> is given, following routine will be used:

  sub merge_dup {
      my ($k, $v, $r) = @_;
      return exists( $r->{$v} )
             ? ( ref($r->{$v}) ? [ @{$r->{$v}}, $k ] : [ $r->{$v}, $k ] )
	     : $k;
  };

The C<BLOCK> will be called with 3 arguments:

=over 8

=item C<key>

The key from the C<< ( key, value ) >> pair in the original hash

=item C<value>

The value from the C<< ( key, value ) >> pair in the original hash

=item C<ref-hash>

Reference to the reversed hash (read-only)

=back

The C<BLOCK> is expected to return the value which will used
for the resulting hash.

=cut

sub safe_reverse
{
    my ( $code, $hash ) = @_;
    unless ($hash)
    {
        $hash = $code;
        $code = sub {
	      my ($k, $v, $r) = @_;
	      return exists( $r->{$v} )
		     ? ( ref($r->{$v}) ? [ @{$r->{$v}}, $k ] : [ $r->{$v}, $k ] )
		     : $k;
	};
    }

    my %reverse;
    while( my ( $key, $val ) = each %{$hash} )
    {
	$reverse{$val} = &{$code}( $key, $val, \%reverse );
    }
    return %reverse;
}

1;

=head1 AUTHOR

Hans Dieter Pearcey, C<< <hdp@cpan.org> >>
Jens Rehsack, C<< <rehsack@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-hash-moreutils@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Hash-MoreUtils>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Hash::MoreUtils

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Hash-MoreUtils>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Hash-MoreUtils>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Hash-MoreUtils>

=item * Search CPAN

L<http://search.cpan.org/dist/Hash-MoreUtils/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2005 Hans Dieter Pearcey, all rights reserved.
Copyright 2010 Jens Rehsack

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;    # End of Hash::MoreUtils
