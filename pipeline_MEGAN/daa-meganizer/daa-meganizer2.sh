#!/usr/bin/env bash

MEGAN=/home/zhouxingchen/megan_6_22_2

$MEGAN/tools/daa2info -i Total.uniq.pep.daa \
    -c2c Taxonomy \
    -r2c Taxonomy \
    --paths true  \
    --list ture \
    -r true  \
    -mro true \
    -o MEGAN-taxonomy3.txt

# Version   MEGAN Community Edition (version 6.22.2, built 10 Mar 2022)
# Author(s) Daniel H. Huson
# Copyright (C) 2022 Daniel H. Huson. This program comes with ABSOLUTELY NO WARRANTY.
# Loading ncbi.map: 2,396,736
# Loading ncbi.tre: 2,396,740
# Total time:  21s
# Peak memory: 1.8 of 7.8G
# 
# real    0m24.432s
# user    1m49.489s
# sys     0m40.716s
