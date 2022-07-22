#!/usr/bin/env perl
use strict;

open Ref,"<AMPs_refID_oriID_map.tsv";

my %IDmap;
while(<Ref>) {
  chomp;

  if(!/^refID/) {
    my @temps = split /\t/;
    $IDmap{$temps[1]} = $temps[0];
  }
}
close Ref;


open In,"<AMPs_of_7Database_nr.faa.bak";
open Out,">AMPs_of_7Database_nr.faa";

while(<In>) {
  chomp;

  if(/^>(\S+)/) {
    if (exists $IDmap{$1}) {
      print Out ">".$IDmap{$1}."\n";
    } else {
      print "ERROR!!!";
      last;
    }
  } else {
    print Out $_."\n";
  }
}

