#!/usr/bin/perl
use strict;
use Getopt::Long;

my $usage = <<USAGE;
Usage:
    perl $0 --health_indi_list \$WD/pipeline_blast_Pep/Pop_health_indi.tab

    --health_indi_list <string>    default: \$WD/pipeline_blast_Pep/Pop_health_indi.tab

USAGE

if (@ARGV==0){die $usage}

my ($HealthyIndiList);
GetOptions(
    "health_indi_list:s" => \$HealthyIndiList,
);
die "--health_indi_list should be set! \n" unless $HealthyIndiList;

open Ref,'<',$HealthyIndiList or die "Can not open file $HealthyIndiList \n";
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
