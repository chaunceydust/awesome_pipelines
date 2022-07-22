#!/usr/bin/env perl
use strict;
use Getopt::Long;


my $usage = <<USAGE;
Usage:
    perl $0 --input Annotation_P45_L80.tsv --output Annotation_P45_L80_taxanomy.tsv --info Malassezia_metadata_Full2.tab.txt

    --input <string>    default: None

    --output <string>   default: None

    --info <string>     default: None

USAGE

if (@ARGV==0){die $usage}

my ($InputFile, $OutputFile, $NCBIInfoFile);
GetOptions(
    "input:s"   => \$InputFile,
    "output:s"  => \$OutputFile,
    "info:s"    => \$NCBIInfoFile,
);
die "--input should be set! \n"    unless $InputFile;
die "--output should be set! \n"   unless $OutputFile;
die "--info should be set! \n"     unless $NCBIInfoFile;

open Out,">", $OutputFile;
print "# Start reading Taxnomy file -----------------------------------------------------------------\n";
open Ref, $NCBIInfoFile;
my %Info;
while(<Ref>) {
  chomp;
  if(!/^GCAID/){
    my @temp = split /\t/;
    $Info{$temp[0]}{"Species"} = $temp[3];
    $Info{$temp[0]}{"infraspecific_name"} = $temp[5];
  }
}
close Ref;

print "# Start mergeing files -----------------------------------------------------------------------\n";
open In, $InputFile;
while(<In>){
  chomp;
  if(!/^Query/) {
    my @temp = split /\t/;
    my @temp2 = split /\_/, $temp[0];
    if ( exists $Info{$temp2[0]}{"Species"} ) {
      print Out $Info{$temp2[0]}{"Species"}."\t".$Info{$temp2[0]}{"infraspecific_name"}."\t".$_."\n";
    } else {
      print "ERROR!!!\n";
      last;
    }
  } else {
    print Out "Species\tinfraspecific_name\t".$_."\n";
  }
}
close In;
close Out;
