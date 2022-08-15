#!/usr/bin/env bash
set -e

Scripts=/home/zhouxingchen/megan_6_22_2
MEGANDB=/home/Metagenome/Ref_database/MEGAN-DB

for i in Total.uniq.pep.fa.nr.txt;
do
    $Scripts/tools/blast2rma \
        -i $i \
        -o "$(dirname $i)"/"$(basename $i .txt).rma"
        -mdb "$MEGANDB"/megan-map-Jan2021.db \
        -f BlastTab 
done
