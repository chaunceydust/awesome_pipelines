#!/usr/bin/env perl
# adapted from ardbAnno



use strict;
use warnings;
use Blast_Anno;
use Bio::SeqIO;

my $evalueCutoff = 1e-10; #change this variable to try different evalue cutoffs

###added by FuRuiqing#######################################################################################
die("Argument: list_file_of_indiv.blastp (individual file should ended with 'blastp')\n") if (@ARGV != 1);##
my $list_file = shift @ARGV;																              ##
my @individual;																				              ##	
open INDI,"<$list_file";																	              ##
while(my $line = <INDI>){																	              ##
	chomp $line;																			              ##
	push @individual, $line;																              ##
}																							              ##
close INDI;																					              ##
############################################################################################################

my $program = "blastp"; #the blast program will be automatically chosen
#my %genome = getGenome(); #get a list of genomes to be annotated		files: name.pfasta
#print "######################################\n";
#foreach my $genome (keys %genome)										# genome: test
#{
#    my $seqfile = $genome{$genome};										# seqfile: test.pfasta
#    unless ($program)
#    {
#	my $seqi = new Bio::SeqIO (-file => $seqfile, -format => "fasta");
#	my $seqobj = $seqi -> next_seq();
#	my $alph = $seqobj -> alphabet;
#	if ($alph eq "dna")
#	{
#	    $program = "blastx";
#	}
#	elsif ($alph eq "protein")
#	{
#	    $program = "blastp";
#	}
##	else
#	{
#	    print "The input sequences are not correct.\n";
#	    exit;
#	}
#	    
#    }

#    my $outfile = $genome . "\.$program";
#    my $db = "./blastdb/resisGenes.pfasta";
#    print "BLASTing $seqfile against ARDB\n";
#    if (-e $outfile)
#    {
#	next;
#    }
#    system("blastall -p $program -d $db -i $seqfile -e $evalueCutoff -b 3 -v 3 -o $outfile");
#}
#print "######################################\n\n";

#extract annotation from blast results
#print "######################################\n";
foreach my $genome (@individual)
{
    my $blastfile = $genome . "\.$program";
#	my $blastfile = $genome;
	$genome =~ s/\.blast.*$//;
    print "Annotating BLAST file $blastfile\n";
    if (-e "$genome\.anno")
    {
	next;
    }
    annoBlast($blastfile);
}
print "######################################\n\n";

#merge annotation files into excel sheet
print "Create Excel Table output.xls\n\n";
mergeAnno(@individual);

exit;
