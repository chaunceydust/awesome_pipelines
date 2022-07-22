#!/usr/bin/perl
use strict;
use Getopt::Long;

my $usage = <<USAGE;
Usage:
    perl $0 --output Annotation.tsv

    --output <string>    default: None

USAGE

if (@ARGV==0){die $usage}

my ($AnnotatedResult);
GetOptions(
    "output:s" => \$AnnotatedResult,
);
die "--output should be set! \n" unless $AnnotatedResult;


open Out,'>',$AnnotatedResult or die "Can not write file $AnnotatedResult\n";
print Out "Query\tBestHit\tType\tDescription\tEvalue\tQueryLength\tHitLength\tHSPlength\tPercentIdentity\n";

my @files=glob("*.anno");
foreach my $file(@files) {
	open In,"<",$file;
	
	while(<In>) {
		chomp;
		if(/>(\S+)/) {
                	print Out $1."\t";
        	}
        	if(/^[^P]\S+\s+(\S+)/) {
                	print Out $1."\t";
        	}
        	if(/PercentIdentity\s+(\S+)/) {
                	print Out $1."\n";
        	}

	}
	close In;
}
close Out;
