#!/usr/bin/perl
use strict;

my @files=(glob("*.fa"), glob("*.fasta"));

open Out,'>',"ProteinName-abrg.tab";
open Class,'>',"ProteinName-Class.info";
open Info,'>',"ProteinName-classInfo.tab";
open Cutoff,'>',"ProteinName-originType.tab";

for my $file(@files)
{
	open In,"<",$file;
	$file=~/^(.*)\.fa/;
	my $id=$1;
	while(<In>)
	{
		if(/^>gi/)
		{
			my @temp=split/\|/;
			$temp[3]=~/(.*)\./;
			printf Out "%s\t%s\n",$1,$id;
		}
		elsif(/^>(\S+)/)
		{
			printf Out "%s\t%s\n",$1,$id;
		}

	}

		print Class  "Full_name\t";
		print Class  "$id\t";
		print Class  "Full_name\n";

		print Info "$id\t";
                print Info "Full_name\n";

		print Cutoff "$id\t";
		print Cutoff 'NULL'."\t";
		print Cutoff "$id\t";
		print Cutoff "Iden\n";


}
close Out;
close Class;
close Info;
close Cutoff;
