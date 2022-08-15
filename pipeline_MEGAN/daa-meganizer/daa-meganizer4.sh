#!/usr/bin/env bash

MEGAN=/home/zhouxingchen/megan_6_22_2

$MEGAN/tools/daa2info -i Total.uniq.pep.daa \
    -r2c SEED \
    --paths true  \
    -o MEGAN-SEED3.txt

