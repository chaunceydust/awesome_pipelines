#!/usr/bin/env perl
use strict;


open In,"<AMPs_rmdup.log";

my $flag = 1;
while(<In>) {
  chomp;

  my $ID = "00000000000000000".$flag++;
  my $formID = substr($ID, -7, 7);

  my @temp1 = split /\t/;
  my @temp2 = split /\,\ /, $temp1[1];

  foreach my $oriid (@temp2) {
    print "fAMP".$formID."\t".$oriid."\n";
  }
  # print "fAMP".$formID."\n";

}
