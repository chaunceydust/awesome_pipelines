#!/bin/bash

# https://github.com/jhcepas/eggnog-mapper/wiki
## mamba install eggnog-mapper -y

# http://beta-eggnogdb.embl.de/download/eggnog_4.5/hmmdb_levels/
# download_eggnog_data.py --data_dir eggNOG -y -f -P -M -H -d 2 -d 4751 -d 2157 

eggNOG_DB="/home/zhouxingchen/DATABASE/eggNOG_db"
myFasta="Total.pep.representid.fa"


emapper.py -i $myFasta \
           --output_dir ./ --output result \
           --data_dir $eggNOG_DB \
           --usemem \
           --override \
           --cpu 0

# emapper.py -i antibacteria_DRAMP.fasta --output_dir ./ --output test --excel --cpu 0 --data_dir eggNOG --usemem --override
# emapper.py -i antibacteria_DRAMP.fasta --output_dir ./ --output test --excel --cpu 0 --data_dir eggNOG --pfam_realign denovo
# 
# emapper.py -i antibacteria_DRAMP.fasta --output_dir ./ --output test --excel --cpu 0 --data_dir eggNOG -m hmmer
