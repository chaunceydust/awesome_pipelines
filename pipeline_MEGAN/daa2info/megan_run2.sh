#!/usr/bin/env bash

/home/zhouxingchen/megan_6_22_2/tools/rma2info \
    -i Total.uniq.pep.fa.nr.rma \
    -c2c Taxonomy -r2c Taxonomy -n true \
    --paths true \
    --ranks true \
    -v \
    --majorRanksOnly true \
    -o Total.uniq.pep.fa.taxonomy_majotR.txt

# --list true --listMore true \


# RMA2Info - Analyses an RMA file
# Options:
# Input and Output
# 	--in: Total.uniq.pep.fa.nr.rma
# 	--out: Total.uniq.pep.fa.taxonomy_majotR.txt
# Commands
# 	--list: false
# 	--listMore: false
# 	--class2count: Taxonomy
# 	--read2class: Taxonomy
# 	--names: true
# 	--paths: true
# 	--ranks: true
# 	--majorRanksOnly: true
# 	--bacteriaOnly: false
# 	--virusOnly: false
# 	--ignoreUnassigned: true
# 	--sum: false
# Other:
# 	--verbose: true
# Version   MEGAN Community Edition (version 6.22.2, built 10 Mar 2022)
# Author(s) Daniel H. Huson
# Copyright (C) 2022 Daniel H. Huson. This program comes with ABSOLUTELY NO WARRANTY.
# Loading ncbi.map: 2,396,736
# Loading ncbi.tre: 2,396,740
# Total time:  24s
# Peak memory: 1.8 of 7.8G
# 
# real	0m27.916s
# user	1m52.674s
# sys	0m39.764s
