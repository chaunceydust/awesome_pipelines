#!/usr/bin/bash
set -e

####################################################################
### setp1: Signal peptide analysis
###        The secreted proteins all have signal peptides.
###        
####################################################################

Data=$(dirname $PWD)
ProteinSequences=$(ls $Data/src/*.fasta)

[ ! -d $Data/singalp ] && mkdir -p $Data/singalp
cd $Data/singalp

signalp -batch 1000000 \
        -org euk \
        -fasta $ProteinSequences \
        -gff3 \
        -mature
#### -org string:
####    Organism. Archaea: 'arch', 
####              Gram-positive: 'gram+', 
####              Gram-negative: 'gram-',
####              Eukarya: 'euk' (default "euk")
#### -batch int
####         Number of sequences that the tool will run simultaneously. 
####         Decrease or increase size depending on your system memory. 
####         (default 10000). 
####         Note: this option will have an effect also on the computation speed.
####         A larger batch size will mean faster computation at the expense of 
####         using more memory. 
####         The default batch size of 10000 will use approximately 
####         1.5 GB of memory.
cd ..

