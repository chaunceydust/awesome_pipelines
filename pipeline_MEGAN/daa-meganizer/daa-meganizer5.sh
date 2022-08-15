#!/usr/bin/env bash

MEGAN=/home/zhouxingchen/megan_6_22_2

$MEGAN/tools/daa2info -i Total.uniq.pep.daa \
    -r2c INTERPRO2GO \
    --paths true  \
    -o MEGAN-INTERPRO2GO3.txt


# Version   MEGAN Community Edition (version 6.22.2, built 10 Mar 2022)
# Author(s) Daniel H. Huson
# Copyright (C) 2022 Daniel H. Huson. This program comes with ABSOLUTELY NO WARRANTY.
# Loading interpro2go.map:    14,242
# Loading interpro2go.tre:    28,907
# Total time:  98s
# Peak memory: 1.3 of 7.8G
# 
# real    1m41.172s
# user    0m59.668s
# sys     0m49.601s

