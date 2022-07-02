#!/usr/bin/bash
set -e

Data=$(dirname $PWD)

[ ! -d $Data/BUSCA ] && mkdir -p $Data/BUSCA
seqkit split -s 500 $Data/candidate_secreted_proteins.NO_GPI.fasta -O $Data/BUSCA
