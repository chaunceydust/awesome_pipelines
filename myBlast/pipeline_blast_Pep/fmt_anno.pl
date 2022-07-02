#!/usr/bin/perl
use strict;
use Cwd;
use Getopt::Long;

my $usage = <<USAGE;
Usage:
    perl $0 --output Annotation.tsv --pop HADZA

    --output <string>    default: None

USAGE

if (@ARGV==0){die $usage}

my ($AnnotatedResult, $Pop);
GetOptions(
    "output:s" => \$AnnotatedResult,
    "pop:s" => \$Pop,
);
die "--output should be set! \n" unless $AnnotatedResult;
die "--pop should be set! \n" unless $Pop;

# my $dir = getcwd;
# $dir=~/(\w+)\/3_Anno\d+/;
# my $Pop=$1;

open Out,'>',$AnnotatedResult or die "Can not write file $AnnotatedResult\n";
print Out "gene_id\tBestHit\tType\tDescription\tEvalue\tQueryLength\tHitLength\tHSPlength\tPercentIdentity\tPop_ID\tIndi_id\n";

my @files=glob("*.anno");
foreach my $file(@files) {
	open In,"<",$file;
	
        $file =~ /(\S+).uniq.pep.anno/ ;
        my $IndiID = $1;
	while(<In>) {
		chomp;
		if(/>(\S+)/) {
                	print Out $1."\t" ;
        	}
        	if(/^[^P]\S+\s+(\S+)/) {
                	print Out $1."\t";
        	}
        	if(/PercentIdentity\s+(\S+)/) {
                	print Out $1."\t".$Pop."\t".$IndiID."\n";
        	}

	}
	close In;
}
close Out;
