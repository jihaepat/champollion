#!/usr/bin/perl
#
# Author: Xiaoyi Ma at the LDC, 06/06/2003
# Purpose: given sentences of both sides and an alignment file
#          merge_alignment.pl merge two sides together and 
#          print an easy-to-read output
# Usage: merge_alignment.pl [hod] X_sentence_file Y_sentence_file aligment_result
#        X_sentence_file: files contains all X sentences, one sentence per line
#        X_sentence_file: files contains all Y sentences, one sentence per line
#        alignment_result: alignment file, one alignment align

use Getopt::Std;

getopts('hod', \%opts) || usage();
usage() if $opts{h};

$printomission = $opts{o};
$debug = $opts{d};
usage() if @ARGV != 3;


open E, "cat -n $ARGV[0]|" || die "$0: can not open $ARGV[0]\n";
open C, "cat -n $ARGV[1]|" || die "$0: can not open $ARGV[1]\n";
open A, "<$ARGV[2]" || die "$0: can not open $ARGV[2]\n";

$docid = `basename $ARGV[2]`;
$docid =~ s/\..+//;
chomp $docid;

while(<E>) {
    chomp;
    if (/^\s*(\d+)\s+(.+)$/) {
	$ln = $1;
	$es = $2;
	$eline{$ln} = $es;
    }
}

while(<C>) {
    chomp;
    if (/^\s*(\d+)\s+(.+)$/) {
	$ln = $1;
        $cs = $2;
	$cline{$ln} = $cs;
    }
}


print "<DOC docid=$docid>\n";

while(<A>){
    chomp;
    next unless / <=> /;
    unless ($printomission) {
	next if /omitted/;
    }
    
    /(.+) <=> (.+)/;
    $esent = $1; $csent = $2;

    if ($debug) {
	print "\n$_\n";
    }

    if ($esent =~ /omitted/) {
	$etype = "0";
	undef @esent;
    } else {
	@esent = split /,/, $esent;
	$etype = @esent;
    }

    if ($csent =~ /omitted/) {
	$ctype = "0";
	undef @csent;
    } else {
	@csent = split /,/, $csent;
	$ctype = @csent;
    }

    print "<SENT type=$etype-$ctype>\n";

    foreach (@esent) {
	print $eline{$_}," ";
    }
    print "\n";

    foreach (@csent) {
	print $cline{$_};
    }
    print "\n</SENT>\n";

}

print "</DOC>\n";
exit;

sub usage() {
    print STDERR << "EOF";
usage: $0 [-hod] <X file> <Y file> <alignment file>
      
      -h  : this (help) message
      -o  : print deletion and insertion (default is no).
      -d  : debug mode, prints alignment as well. (default is no)

EOF

       exit;
}
