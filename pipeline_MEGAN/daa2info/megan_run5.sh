#!/usr/bin/env bash

MEGAN=/home/zhouxingchen/megan_6_22_2

$MEGAN/tools/rma2info \
    -i Total.uniq.pep.fa.nr.rma \
    -r2c INTERPRO2GO \
    -n true \
    --paths true \
    --ranks true \
    --list true \
    --listMore true \
    -v \
    -o C1INTERPRO2GO.txt
# ~/megan/tools/rma2info -i ./diamond/C1.rma -r2c EGGNOG -n true --paths true --ranks true --list true --listMore true -v >  ./diamond/C1eggnog.txt

# ~/megan/tools/rma2info -i ./diamond/C1.rma -r2c SEED -n true --paths true --ranks true --list true --listMore true -v >  ./diamond/C1SEED.txt

# ~/megan/tools/rma2info -i ./diamond/C1.rma -r2c INTERPRO2GO -n true --paths true --ranks true --list true --listMore true -v >  ./diamond/C1INTERPRO2GO.txt

# RMA2Info - Analyses an RMA file
# Options:
# Input and Output
# 	--in: Total.uniq.pep.fa.nr.rma
# 	--out: C1INTERPRO2GO.txt
# Commands
# 	--list: true
# 	--listMore: true
# 	--read2class: INTERPRO2GO
# 	--names: true
# 	--paths: true
# 	--ranks: true
# 	--majorRanksOnly: false
# 	--bacteriaOnly: false
# 	--virusOnly: false
# 	--ignoreUnassigned: true
# 	--sum: false
# Other:
# 	--verbose: true
# Version   MEGAN Community Edition (version 6.22.2, built 10 Mar 2022)
# Author(s) Daniel H. Huson
# Copyright (C) 2022 Daniel H. Huson. This program comes with ABSOLUTELY NO WARRANTY.
# Loading interpro2go.map:    14,242
# Loading interpro2go.tre:    28,907
# Total time:  518s
# Peak memory: 1.2 of 7.8G
# 
# real	8m41.003s
# user	4m9.053s
# sys	4m37.060s
