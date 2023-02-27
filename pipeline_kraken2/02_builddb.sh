#!/bin/bash


DBNAME=~/Downloads/db/kraken2/nt
[ ! -d $DBNAME ] && mkdir -p $DBNAME
cd $DBNAME

# kraken2-build --download-library nt --threads 64 --db $DBNAME

kraken2-build --build --threads 24 --db $DBNAME
