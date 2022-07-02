#!/bin/bash
set -exuo pipefail

WD=$(dirname $PWD)

:> $WD/00_BlastDB/DB.faa
for seq in $(ls $WD/00_BlastDB/*.fasta);
do
	awk -F"[||.]" '{printf "%s\n",/^>gi/ ?">"$4 :$0}' $WD/00_BlastDB/$(basename $seq) >> $WD/00_BlastDB/DB.faa
done

cd $WD/00_BlastDB
seqkit rmdup -n -D seqkit.dup.record -d dup.fa -o uniqe.fa DB.faa
makeblastdb -in uniqe.fa -dbtype prot -title db -parse_seqids -out db -logfile db_`date +%Y%m%d`.log
# rm -rf DB.faa
