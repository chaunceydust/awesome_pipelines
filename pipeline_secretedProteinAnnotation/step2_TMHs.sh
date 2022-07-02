#!/usr/bin/bash
set -e

####################################################################
### setp2: Transmembrane region analysis was performed
###        If there is a transmembrane region, 
###        the protein will bind to the membrane, 
###        thus fixing to the membrane, and 
###        will not become a secreted protein.
###        
####################################################################

Data=$(dirname $PWD)
ProteinSequences=$(ls $Data/src/*.fasta)

[ ! -d $Data/TMHMM ] && mkdir -p $Data/TMHMM
cd $Data/TMHMM
tmhmm $Data/singalp/$(basename $ProteinSequences .fasta)_mature.fasta > tmhmm.out
grep "Number of predicted TMHs:  0" tmhmm.out | perl -p -e 's/#\s+(\S+).*/$1/' > genes_without_TMHs.list
fasta_extract_subseqs_from_list.pl $ProteinSequences genes_without_TMHs.list > ../candidate_secreted_proteins.fasta
cd ..
