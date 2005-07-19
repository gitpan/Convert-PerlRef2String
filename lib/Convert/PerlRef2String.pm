package Convert::PerlRef2String;

use 5.008003;
use strict;
use warnings;

require Exporter;
use AutoLoader qw(AUTOLOAD);

use vars qw(@ISA @EXPORT @EXPORT_OK);

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Convert::PerlRef2String ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.

@EXPORT = qw(perlref2string string2perlref);
@EXPORT_OK = qw(perlref2string string2perlref);

our $VERSION = '0.02';


# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.
use MIME::Base64;
use Compress::Zlib;
use Data::Dumper;

sub perlref2string {
        my $perlref = shift;
        return unless(defined $perlref);
        my ($string,$zipped,$encoded);
        eval{$string  = Dumper($perlref);};
        return if($@);
        eval{$zipped  = Compress::Zlib::memGzip($string);};
        return if($@);
        eval{$encoded = encode_base64($zipped);};
        return $encoded unless($@);
}

sub string2perlref {
        my $string = shift;
        return unless(defined $string);
        my($decoded,$perlref,$VAR1);
        eval{$decoded = decode_base64($string);};
        return if($@);
        $perlref = eval($VAR1 = Compress::Zlib::memGunzip($decoded));
        return $perlref unless($@);
}

1;
__END__


=head1 NAME

Convert::PerlRef2String - Perl extension for converting PERL reference object to compressed string and vice versa

=head1 SYNOPSIS

The following script

  use Convert::PerlRef2String;
  use Convert::PerlRef2String;
  use Data::Dumper;
  my $perl = {
          'Order' => {
                       'BookName' => 'Programming Web Serivices with Perl',
                       'Id' => '0-596-00206-8',
                       'Quantity' => '500'
                     },
          'Payment' => {
                         'CardType' => 'VISA',
                         'ValidDate' => '12-10-2006',
                         'CardNo' => '1234-5678-9012-3456',
                         'Name' => 'Kai Li'
                       }
        };
  my $string = perlref2string($perl);
  print $string,"\n";
  my $perlref = string2perlref($string);
  print Dumper($perlref);

will produce

  H4sIAAAAAAAAA32QTQuCQBCG7/6KOQR7aWHUtCIKrC5SmH1g5y2XWkqNbSsk/O9Z2Rekc5x9nndn
  phY4Mx26cNXgXWQiQy4JdHs/7Z8i/STZeSziD4z4MtlIFkUi3sCSr2DOpTiLNT/CRagt+FzuSb00
  yw2fKUittk0RDbRpq4KfnlishEqfloVI/qPZdwTxWRrxWFXvlXMDJsNFeig2C9y5Uz5KjgdsL8Ih
  UwWvG1RHaiDaldb9Ey95KWaDWnazRduY62bDqnY/Zx8xAWNBytjs/ZB1tBsqjca86gEAAA==

  $VAR1 = {
          'Order' => {
                       'BookName' => 'Programming Web Serivices with Perl',
                       'Id' => '0-596-00206-8',
                       'Quantity' => '500'
                     },
          'Payment' => {
                         'CardType' => 'VISA',
                         'ValidDate' => '12-10-2006',
                         'CardNo' => '1234-5678-9012-3456',
                         'Name' => 'Kai Li'
                       }
        };


=head1 DESCRIPTION

This is a handy tool for who wants to send PERL reference objects over the Internet as compressed strings. When both the sender and receiver are PERL programs you can use this tool as an alternative to exchanging XML files.

=head2 EXPORT

perlref2string and string2perlref.



=head1 AUTHOR

Kai Li, E<lt>kaili@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Kai Li

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
