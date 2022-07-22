#!/bin/bash
set -exuo pipefail

WD=$(dirname $PWD)

[ ! -d $WD/02_blast_result ] && mkdir -p $WD/02_blast_result;
for i in `ls $WD/01_sequences/*.fasta`;
do
	# Sequences producing significant alignments
	blastp -query $i -db $WD/00_BlastDB/db -out $WD/02_blast_result/$(basename $i).txt -evalue 1e-5 -outfmt 0 -num_threads 60;
done

cd $WD/02_blast_result
for n in *.txt; do mv $n `echo $n|sed "s/\.fasta.txt/\.blastp/"`; done;
ls *.blastp > Samples.txt
perl -pi -e "s/.blastp//" Samples.txt

