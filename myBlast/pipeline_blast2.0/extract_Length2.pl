#!/usr/bin/env perl
use strict;
use Getopt::Long;

my $usage = <<USAGE;
Usage:
    perl $0 --input Annotation.tsv --outputPrefix Annotation_Iden80_L

    --input <string>    default: None

    --outputPrefix <string>    default: None

USAGE

if (@ARGV==0){die $usage}

my ($AnnotatedResult, $LengthCutoffPrefix);
GetOptions(
    "input:s" => \$AnnotatedResult,
    "outputPrefix:s" => \$LengthCutoffPrefix,
);
die "--input should be set! \n" unless $AnnotatedResult;
die "--outputPrefix should be set! \n" unless $LengthCutoffPrefix;

my @Lengths=(50, 30, 80, 90, 95, 100);
for my $length(@Lengths){
	
	open In,'<',$AnnotatedResult or die "Can not open file $AnnotatedResult\n";;	
	open Out,">",$LengthCutoffPrefix.$length.".tsv";
		
	while(<In>) {
		chomp;
		if(!/^Query/){
			my @temp = split /\t/;
			if($temp[7]/$temp[6] >= ($length/100) & $temp[7]/$temp[5] >= ($length/100)){
				print Out $_."\n";
			}
		} else {
			print Out $_."\n";
		}	
	}
	close In;
	close Out;
}
