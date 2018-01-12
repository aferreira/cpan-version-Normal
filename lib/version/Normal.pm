
package version::Normal;

# ABSTRACT: More normal forms for version objects
use 5.012;
use warnings;

use version 0.77 ();

sub version::normal2 {
    &_check_version;

    my @v = @{ $_[0]{version} };
    pop @v while @v > 2 && !$v[-1];    # drop trailing 0's

    push @v, 0 while @v < 2;           # at least 2 parts

    return sprintf 'v%vd', pack 'U*', @v;
}

sub version::normal3 {
    &_check_version;

    my @v = @{ $_[0]{version} };
    pop @v while @v > 3 && !$v[-1];    # drop trailing 0's

    push @v, 0 while @v < 3;           # at least 3 parts

    return sprintf '%vd', pack 'U*', @v;
}

sub _check_version {
    ref( $_[0] )
      && eval { exists $_[0]{version} }
      && ref( $_[0]{version} ) eq 'ARRAY'
      and return;

    require Carp;
    Carp::croak("Invalid version object");
}

1;

=encoding utf8

=head1 SYNOPSIS

    use version::Normal;

    # 'v0.400'
    version->parse('0.4')->normal2;

    # '0.400.0'
    version->parse('0.4')->normal3;

=head1 DESCRIPTION

B<This is alpha software. The API may change.>

This module loads the L<version> module and adds two methods to its objects.
Those methods implement normal forms akin to the standard C<normal()> method.

Furthermore, these normal forms have the following property:

    NORMAL(v1) = NORMAL(v2)   if   v1 == v2

Notice that this property does not hold for C<normal()>.
For example, for two version numbers like C<'v1.0.0'>
and C<'v1.0.0.0'> which satisfy

    version->parse('v1.0.0') == version->parse('v1.0.0.0')

the following table of results can be computed

    V                               'v1.0.0'         'v1.0.0.0'

    version->parse(V)->normal()     'v1.0.0'    ≠    'v1.0.0.0'
    version->parse(V)->normal2()    'v1.0'      =    'v1.0'
    version->parse(V)->normal3()    '1.0.0'     =    '1.0.0'

=head1 METHODS

L<version::Normal> implements the following methods
and installs them into L<version> namespace.

=head2 normal2

    $string = $version->normal2(); 

Returns a string with a normalized dotted-decimal form with a leading-v,
at least 2 components, and no superfluous trailing 0.

Some examples are:

    V          version->parse(V)->normal2()

    0.1        v0.100
    v0.1       v0.1
    v1         v1.0
    0.010      v1.10
    0.3.10     v0.3.10
    v0.0.0.0   v0.0
    v0.1.0.0   v0.1

This form looks good when describing the version of a software
component for humans to read
(eg. C<Changes> file, C<--version> output, etc.)

=head2 normal3

    $string = $version->normal3(); 

Returns a string with a normalized dotted-decimal form with no leading-v,
at least 3 components, and no superfluous trailing 0.

Some examples are:

    V          version->parse(V)->normal2()

    0.1        0.100.0
    v0.1       0.1.0
    v1         1.0.0
    0.010      1.10.0
    0.3.10     0.3.10
    v0.0.0.0   0.0.0
    v0.1.0.0   0.1.0

This form is appropriate for distribution tarball names
(like "version-Normal-0.1.0.tar.gz") – only digits and dots
and no need for special interpretation of a leading-v.

=head1 SEE ALSO

L<version>

=head1 ACKNOWLEDGEMENTS

The development of this library has been partially sponsored
by Connectivity, Inc.

=cut
