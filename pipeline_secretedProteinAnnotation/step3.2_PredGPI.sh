#!/usr/bin/bash
set -e

####################################################################
### setp3: PredGPI is a prediction system for GPI-anchored proteins. 
###  It is based on a support vector machine (SVM) for the discrimination of
###  the anchoring signal, and on a Hidden Markov Model (HMM) 
###  for the prediction of the most probable omega-site
###        
###        GPI anchors proteins that bind to the membrane and 
###        thus bind to the membrane, 
###        they do not become secretory proteins.
###        
###        [ http://gpcr.biocomp.unibo.it/predgpi/pred.htm ]
###        max 500 sequecnes
###        submit and click download
###        
###        cutoff: FDR 0.5%
###        FDR <= 0.1%    GPI-anchored: highly probable
###        FDR <= 0.5%    GPI-anchored: probable
###        FDR <= 1.0%    GPI-anchored: lowly probable
###        
####################################################################

Data=$(dirname $PWD)

cd $Data/PredGPI
:> PredGPI.fasta
cat GPIPE_query_results*.txt >> PredGPI.fasta
perl -e 'while (<>) { if (m/^>(\S+).*FPrate:(\S+)/ && $2 <= 0.01) { print "$1\n"; } }' PredGPI.fasta > GPI_gene.list

fasta_extract_subseqs_from_list.pl --reverse ../candidate_secreted_proteins.fasta GPI_gene.list > ../candidate_secreted_proteins.NO_GPI.fasta
cd ..
