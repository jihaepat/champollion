#!/usr/bin/perl -w
#
# Purpose: A light English stemmer
# Author: Xiaoyi Ma, LDC
# Date:   September 17, 2003
# Input: English text
# Output: English text with words stemmed
#

use DB_File;
use Fcntl qw(O_RDONLY O_RDWR O_CREAT);

$eng_morph_txt = "$ENV{CTK}/lib/eng_morph.txt";
$eng_morph = "$ENV{CTK}/lib/eng_morph";
&make_eng_morph_db($eng_morph_txt, $eng_morph);
tie %eng_morph, "DB_File", $eng_morph,O_RDONLY,0444 || die "$0: Cannot open dbmfile $eng_morph!\n";

while (<>) {
    chomp;
    @_ = split;
    foreach (@_) {
	if (defined $eng_morph{$_}) {
	    print "$eng_morph{$_} ";
	} else {
	    print "$_ ";
	}
    }
    print "\n";
}
untie %eng_morph;

sub make_eng_morph_db {
    my ($eng_morph_txt, $eng_morph) = @_;

    return if -f $eng_morph;

    print STDERR "Making English Morph DBM file ...\n";
    tie %eng_morph, "DB_File", $eng_morph, O_CREAT|O_RDWR, 0664|| die "Cannot open dbmfile $eng_morph";
    open F,"<$eng_morph_txt" || die "English Morph file $eng_morph not found";
    while (<F>) {
        chomp;
        @_ = split;
        $eng_morph{$_[0]}  = $_[1];
    }
    close(F);
    untie %eng_morph;
}
