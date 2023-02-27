#!/usr/bin/bash

mydir=$PWD
mkdir -p ${mydir}/results/abundance
kraken2 --db /home/zhouxingchen/Downloads/db/kraken2/bacteria \
        --threads 16 \
        -output ${mydir}/results/SAMPLE.kraken2 \
        --report ${mydir}/results/SAMPLE.kreport2 \
        ${mydir}/results/otus.fa

awk '$1=="C"&&$3!=0' ${mydir}/results/SAMPLE.kraken2 | \
        awk '{$0=$2 "\t"$3}1' | \
        sed '1i\asvid\tspid' \
        > ${mydir}/results/asvclass.txt

# abundance.py -asv ${mydir}/result/otutab.txt \
# -class ${mydir}/results/asvclass.txt \
# -db /mnt/d/krakensilva/db/dbpy.txt -out ${mydir}/results/abundance
