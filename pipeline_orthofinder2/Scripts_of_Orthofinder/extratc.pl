#!/usr/bin/env perl
use strict;
use Getopt::Long;


my $usage = <<USAGE;
Usage:
    perl $0 

    --input <string>    default: "Orthogroups.txt"

    --Unassign <string> default: "Orthogroups_UnassignedGenes.tsv"

    --output <string>   default: "Total_sequences_refID2oriID.txt"

USAGE

if (@ARGV==0){die $usage}

my ($InputFile, $OutputFile, $UnassignFile);
GetOptions(
    "input:s"     => \$InputFile,
    "output:s"    => \$OutputFile,
    "Unassign:s"  => \$UnassignFile,
);
die "--input should be set! \n"    unless $InputFile;
die "--output should be set! \n"   unless $OutputFile;
die "--Unassign should be set! \n"     unless $UnassignFile;

open Out,">".$OutputFile;
open In,"<",$InputFile;

while(<In>) {
  chomp;
  my @temp = split /: /;
  my @temp2 = split / /, $temp[1];

  foreach my $id(@temp2) {
    print Out $temp[0]."\t".$id."\n"
  }
}
close In;

open Un,"<",$UnassignFile;

while(<Un>) {
  chomp;
  if(!/^Orthogroup/){
    my @temp = split /\t/;
    foreach my $id(@temp) {
        if( $id =~ /OG/ ){
          print Out $id."\t";
        }
        if( $id =~ /GCA/){
          print Out $id."\n";
        }
  
    }
  }
}
close Un;
close Out;
