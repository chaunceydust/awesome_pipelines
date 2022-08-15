#!/usr/bin/env  bash
set -e
 
workdir="$(dirname $PWD)"
DIAMOND="/home/zhouxingchen/miniconda3/bin"
DIAMOND_db="/home/Metagenome/Ref_Database/NR-20211111-BLAST/nr_fungi_20220420"
 
for i in Total.uniq.pep.fa;
do
    $DIAMOND/diamond blastp \
        --db $DIAMOND_db \
        --query $workdir/7_Total_Uniq_Gene_fungi/Total.uniq.pep.fa \
        --daa $workdir/7_Total_Uniq_Gene_fungi/Total.uniq.pep.daa \
        --sensitive \
        --max-target-seqs 500 \
        --evalue 1e-5 \
        --id 20 \
        --block-size 100.0 \
        --index-chunks 1 \
        --tmpdir /dev/shm
done
