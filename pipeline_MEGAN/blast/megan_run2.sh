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

