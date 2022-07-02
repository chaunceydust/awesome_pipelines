#!/usr/bin/bash
set -e

Data=$(dirname $PWD)

# 再分析GPI锚定位点。GPI锚定蛋白和膜结合，从而固定到膜上，不会成为分泌蛋白。

[ ! -d $Data/PredGPI ] && mkdir -p $Data/PredGPI
seqkit split -s 500 $Data/candidate_secreted_proteins.fasta -O $Data/PredGPI
