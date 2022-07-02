#!/usr/bin/bash
set -e

####################################################################
### setp4: predicting protein subcellular localization
###        Extracellular proteins were selected as 
###        secretory protein genes
###
###        [ http://busca.biocomp.unibo.it/ ]
###        (max 500 sequences, 
###        Select the Fungi taxonomic origin
###        Click Start prediction
###        download CSV table)
####################################################################

Data=$(dirname $PWD)

cd $Data/BUSCA
# http://busca.biocomp.unibo.it/
:> BUSCA.out.csv
cat BUSCA_JOB_*.csv >> BUSCA.out.csv
perl -e '<>; while (<>) { @_ = split /,/; $stats{$_[2]}{$_[0]} = 1; } foreach (sort keys %stats) { @gene = sort keys %{$stats{$_}}; my $gene_number = 0; $gene_number = @gene; print STDERR "$_\t$gene_number\n"; if ($_ eq "C:extracellular space") { foreach (@gene) { print "$_\n"; } } }' BUSCA.out.csv > extracellular_gene.list 2> BUSCA.out.csv.stats
sed -i "s/_GENEM/|GENEM/g" extracellular_gene.list    ## note BUSCA can change gene id !!!!!

fasta_extract_subseqs_from_list.pl ../candidate_secreted_proteins.NO_GPI.fasta extracellular_gene.list > ../candidate_secreted_proteins.NO_GPI.extracellular.fasta

cd ..
ln -s candidate_secreted_proteins.NO_GPI.extracellular.fasta secreted_proteins.fasta

## The final result: secreted_proteins.fasta .
