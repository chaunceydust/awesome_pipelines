#!/usr/bin/env perl
use strict;

my $InSeq = $ARGV[0];
my $SampleID = $ARGV[1];

open IN,"<",$InSeq;
my $count = 0;
while(<IN>) {
	chomp;
	if(/^>\S+/){
		$count += 1;
		print ">".$SampleID."|ID".$count."\n";
	} else {
		print $_."\n";
	}
}
