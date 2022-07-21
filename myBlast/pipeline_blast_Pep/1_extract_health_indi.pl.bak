#!/usr/bin/perl
use strict;

open Ref,'<','/project/zhouxingchen/AMP_deeplearning/Pop/pipeline_blast_Pep/Pop_health_indi.tab';
my %Hits;
my $id;
while(<Ref>)
{
	chomp;
	my @temp=split /\t/;
	$id=$temp[0];
	$Hits{$id}=$temp[1];	
}

$Hits{"Indi"}=1;

my %healthy;
$healthy{"AU"}=1;
$healthy{"KR"}=1;

my @files=glob("*.tsv");
for my $file(@files)
{
	$file =~ /(\S+)_Annotation/;
	my $Pop = $1;
	open In,"<",$file;
	open Out,">","0_".$file;
	#printf Out "Indi\tIndi_id\tType\tgene_id\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\tStrain\tAbundance\n";
	if(exists $healthy{$Pop}){
		while(<In>){
			chomp;
			my @temp = split /\t/;
			if(/^Pop_ID/){
                        	printf Out "%s\t%s\n","Pop",$_;
                	}else{
                        	printf Out "%s\t%s\n",$Pop,$_;
                	}
		}
		close In;
		close Out;
		next;
	}
	while(<In>)
	{
		chomp;
		my @temp=split /\t/;
		if(/^Pop_ID/){
			printf Out "%s\t%s\n","Pop",$_;
		}elsif(exists $Hits{$temp[1]}){
			printf Out "%s\t%s\n",$Pop,$_;
		}
	}
	close In;
	close Out;
}
