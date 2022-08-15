#!/usr/bin/env bash
set -e

Data=$(dirname $PWD)
NRDB=/home/Metagenome/Ref_Database/NR-20211111-BLAST/nr_fungi_20220121
Scripts=~/miniconda3/bin

for i in $(ls Total.uniq.pep.fa)
do
        echo $(basename $i)
        $Scripts/blastp -db $NRDB \
                        -query $i \
                        -out $i.nr.txt \
                        -evalue 1e-5 \
                        -outfmt 7 \
                        -max_target_seqs 100 \
                        -num_threads 200
done
