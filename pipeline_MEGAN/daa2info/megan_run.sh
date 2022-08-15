#!/usr/bin/env bash

MEGAN=/home/zhouxingchen/megan_6_22_2

$MEGAN/tools/daa2rma \
    -i Total.uniq.pep.daa \
    -mdb /home/zhouxingchen/DATABASE/megan-map-Jan2021.db \
    -ms 50 \
    -me 0.01 \
    -top 10 \
    -o Total.uniq.pep.fa.nr.rma


# real    24m59.688s
# user    40m47.084s
# sys     11m25.312s
