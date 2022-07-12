#!/usr/bin/env perl
use strict;


# USAGE: ---------------------------------------------------------------
# perl extract_seqkit_info.pl seqkit.dup.record.log besthit_gene_uni.fa
#
# ----------------------------------------------------------------------

open MAPfile, $ARGV[0] or die; # "HMP_blast/pipeline_blast/HMP_bsethit_seqkit_id_mapping.info"
open AbunFile, $ARGV[1] or die; # "contry_blast/AMR/04_Annotation/Annotation_P30_L50_relAbun.tsv"
open Out, ">", $ARGV[2] or die; # "contry_blast/AMR/04_Annotation/Annotation_P30_L50_relAbun_unfold.tsv"

my %IDmap;
while(<MAPfile>){
  chomp;
  if(!/^formatID/){
    my @temp = split /\t/;
    $IDmap{$temp[1]}{$temp[2]}=1;
  }
}
close MAPfile;

while(<AbunFile>){
  chomp;
  if(!/^Pop_ID/){
    my @temp = split /\t/;
    if( exists $IDmap{$temp[3]} ){
      foreach my $id(sort keys %{ $IDmap{$temp[3]} }){
        print "Unfolding: ".$temp[3]."\tto\t".$id."\t...\n";
        foreach my $head (0..2) {
          print Out $temp[$head]."\t";
        }
        print Out $id;
        foreach my $tail (4..10){
          print Out "\t".$temp[$tail];
        }
        print Out "\n";
      }
    } else {
      print "ERROR!!!\t$temp[3]\n";
      last;
    }
  } else {
    print Out $_."\n";
  }
}
close AbunFile;
close Out;
