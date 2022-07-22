#!/bin/bash
set -e

# pepdata=/project/zxc/MalaAnalyis/maker/maker/02_Pep
pepdata=/project/zhouxingchen/GenomeData/D211217/4_maker/02_Pep
Data=$(dirname $PWD)
[ ! -d $Data/src ] && mkdir -p $Data/src

for m in `ls $pepdata/GC[FA]*_proteins.fa`
do
    awk -F"-" '{if ($0 ~ /^>/)print ">"$2;else print $0}' $m > $Data/src/$(basename $m .fa).fasta
done
