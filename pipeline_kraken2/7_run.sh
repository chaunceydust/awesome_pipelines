#!/usr/bin/bash

mydir=$PWD
DB_kraken2=/home/zhouxingchen/Downloads/db/kraken2/bacteria
# DB_kraken2=/home/zhouxingchen/Downloads/database_16S/minikraken_8GB_20200312
mkdir -p ${mydir}/results2/abundance
kraken2 --db $DB_kraken2 \
        --threads 16 \
        -output ${mydir}/results2/SAMPLE.kraken2 \
        --report ${mydir}/results2/SAMPLE.kreport2 \
        /home/zhouxingchen/Downloads/db/kraken2/Total.uniq.cds.fa

awk '$1=="C"&&$3!=0' ${mydir}/results2/SAMPLE.kraken2 | \
        awk '{$0=$2 "\t"$3}1' | \
        sed '1i\asvid\tspid' \
        > ${mydir}/results/asvclass.txt

# abundance.py -asv ${mydir}/result/otutab.txt \
# -class ${mydir}/results/asvclass.txt \
# -db /mnt/d/krakensilva/db/dbpy.txt -out ${mydir}/results/abundance
