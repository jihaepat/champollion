#!/home/xma/pkg/bin/perl

$Usage = "Usage: $0 [Arabic .txt file (UTF8)]";

use Encode;

$Usage = "Usage: $0 [filename]\n";
die $Usage if ( @ARGV > 1 or ( @ARGV == 1 and ! -f $ARGV[0] ));

if ( @ARGV ) {
    open( STDIN, shift );
}
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

while(<>){
    
    # convert Arabic-Indic digits to Roman digits
    s/\x{0660}|\x{06F0}/0/g;
    s/\x{0661}|\x{06F1}/1/g;
    s/\x{0662}|\x{06F2}/2/g;
    s/\x{0663}|\x{06F3}/3/g;
    s/\x{0664}|\x{06F4}/4/g;
    s/\x{0665}|\x{06F5}/5/g;
    s/\x{0666}|\x{06F6}/6/g;
    s/\x{0667}|\x{06F7}/7/g;
    s/\x{0668}|\x{06F8}/8/g;
    s/\x{0669}|\x{06F9}/9/g;

    # convert Arabic punctuations to English puctuations
    s/\x{061F}/\?/g;
    s/\x{066A}/\%/g;
    s/\x{066B}/\./g; # Arabic decimal separator
    s/\x{066C}/\,/g; # Arabic thousand separator
    s/\x{061B}/\;/g;
    s/\x{060C}/\,/g;
    print;
}
