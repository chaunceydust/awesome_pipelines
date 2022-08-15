#!/usr/bin/env bash

MEGAN=/home/zhouxingchen/megan_6_22_2

$MEGAN/tools/rma2info \
    -i Total.uniq.pep.fa.nr.rma \
    -r2c SEED \
    -n true \
    --paths true \
    --ranks true \
    --list true \
    --listMore true \
    -v \
    -o C1SEED.txt
# ~/megan/tools/rma2info -i ./diamond/C1.rma -r2c EGGNOG -n true --paths true --ranks true --list true --listMore true -v >  ./diamond/C1eggnog.txt

# ~/megan/tools/rma2info -i ./diamond/C1.rma -r2c SEED -n true --paths true --ranks true --list true --listMore true -v >  ./diamond/C1SEED.txt

# real	0m3.603s
# user	0m3.583s
# sys	0m1.276s
