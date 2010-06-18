#! /usr/bin/perl -ws
#
# 2001/11/09  dwl

use strict;
use constant DEFAULT    => 16;
use constant SRC        => '/dev/urandom';
use constant LINE_WIDTH => 72;

use vars qw/$v/;

my $chars_wanted = shift || DEFAULT;
my $re_class     = shift || 'A-Za-z0-9~@#$%&_=,.?/';
my $re           = qr/^[$re_class]$/;

open R, SRC or die "Random source (@{[SRC]} not available: $!.\n";
my $char;
my $spew = '';
while( $chars_wanted ) {
    read( R, $char, 1 ) or die "Failed to read 1 char from @{[SRC]}: $+!\n";
    if( $char =~ $re ) {
        $spew .= $char;
        --$chars_wanted;
    }
}
close R;

print "$spew\n";
print "\n";


=head1 NAME

spew - spew random characters

=head1 SYNOPSIS

B<spew> [B<-v>] [count] [character-class]

=head1 DESCRIPTION

Read characters from a device that emits random data (such as
/dev/urandom), and print them out. This can be used as the
basis for creating passwords, or manual IPSec authentification
keys (using a count of 64 or more is recommended).

If C<count> is omitted, the value of 16 is used.

If C<character-class> is omitted, the character class C<A-Za-z0-9>
is used. To specify hexadecimal characters, use C<0-9a-f>. To use
all the standard printable ASCII characters use the obfuscated C<!-~>
or C< -~> character classes. Note that the latter class probably
needs quoting to avoid being clobbered by the shell.


=over 5

=back

=head1 EXAMPLES

B<% spew>

GByL4t9xOm8oNgZ8

B<% spew -v 6>

qQlaRO

quebec upper-quebec lima alpha upper-romeo upper-oscar

B<% spew 56 0-1>

10100000001101000010111001010011001001100101011110001101

=head1 BUGS

Very little error checking is performed.

Uses the -s Perl switch for command line parsing, should use
L<Getopt::Mixed> or something similar.

Not portable to Win32 platforms, due to the lack of a /dev/random
analogue.

To be really paranoid, on OpenBSD, one should use /dev/srandom, which
is cryptographically strong. Unfortunately, it blocks too much to be
of any practical use (I guess I need to buy a hardware generator).

=head1 COPYRIGHT

Copyright (c) 2001 David Landgren.

This script is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 AUTHOR

     David "grinder" Landgren
     grinder on perlmonks (http://www.perlmonks.org/)
     eval {join chr(64) => qw[landgren bpinet.com]}

=cut
