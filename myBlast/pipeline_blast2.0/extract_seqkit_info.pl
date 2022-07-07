#!/usr/bin/env perl
use strict;
use Data::Dumper;

# USAGE: ---------------------------------------------------------------
# perl extract_seqkit_info.pl seqkit.dup.record.log besthit_gene_uni.fa
#
# ----------------------------------------------------------------------

open In, $ARGV[0] or die; # "<seqkit.dup.record.log"
open RefID, $ARGV[1] or die; # "besthit_gene_uni.fa"

open Out,">HMP_bsethit_seqkit_id_mapping.info";
print Out "formatID\treferenceID\toriID\n";

my @refid = ();
while(<RefID>) {
  chomp;
  if(/^>(\S+)/){
    push @refid, $1;
  }
}
my %hash_ref = map{$_=>1} @refid;

my $flag = 1;
while(<In>) {
  chomp;

  my $ID = "00000000000000000".$flag++;
  my $formID = substr($ID, -7, 7);

  my @temp1 = split /\t/;
  my @temp2 = split /\,\ /, $temp1[1];

  # set operation method 1: use Data::Dumper ---------------------
  my %hash_ori = map{$_=>1} @temp2;
  my %merge_all = map {$_ => 1} @refid, @temp2;
  
  my @ref_only = grep {!$hash_ori{$_}} @refid;
  my @ori_only = grep {!$hash_ref{$_}} @temp2;
  my @common = grep {$hash_ref{$_}} @temp2;
  my @merge = keys (%merge_all);

  if (0) {
    print "Ref only:\n";
    print Dumper(\@ref_only);
    print "Ori only:\n";
    print Dumper(\@ori_only);
    print "Common :\n";
    print Dumper(\@common);
    print "Merge :\n";
    print Dumper(\@merge);
  }

  # set operation method 2: use ----------------------------
  my @union = ();
  my @diff = ();
  my @isect = ();
  my (%union, %isect);
  foreach my $e(@refid, @temp2){
    $union{$e}++ && $isect{$e}++;
  }
  @union=keys %union;
  @isect=keys %isect;
  @diff=grep {$union{$_}==1;} @union;

  if (0) {
    print (join ',',@union);
    print "\n";
    print (join ',',@isect);
    print "\n";
    print (join ',', @diff);
    print "\n";
  }

  my $size = @isect;
  my $check = ($size == 1) ? print $isect[0]."\tsize: ".$size."\n" : print "ERROR!!!";
  if ($size != 1) {last};

  foreach my $oriid (@temp2) {
    print Out "hitsID".$formID."\t".$isect[0]."\t".$oriid."\n";
  }

}
