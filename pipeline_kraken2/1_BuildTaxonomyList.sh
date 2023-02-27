#!/bin/bash

taxonomyDB=/home/zhouxingchen/Downloads/db/taxonomy
taxonkit list --data-dir $taxonomyDB \
         --ids 1 \
         --indent "" > taxids.txt

cat taxids.txt | \
         taxonkit lineage \
         --data-dir $taxonomyDB | \
         taxonkit reformat \
         --data-dir $taxonomyDB \
         -a -P \
         -f "{k}|{p}|{c}|{o}|{f}|{g}|{s}|{T}" \
         -F | \
         cut -f 1,3- > spdb.txt

sed -i 's/Unnamed/unclassified/g' spdb.txt

Rscript fmt.R
