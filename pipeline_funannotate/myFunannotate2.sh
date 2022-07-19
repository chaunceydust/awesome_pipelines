#!/usr/bin/env bash
set -e

# # default values of variables set from params
# 
# Default environment name.
ENV=funannotate
# 
# # Conda directory name.
CONDA_DIR=/home/zhouxingchen/miniconda3
# 
# # The conda shell cannot be run in strict mode.
# set +ue
# 
# # Apply the environment.
# source ${CONDA_DIR}/etc/profile.d/conda.sh
# 
# # Activate the environment.
# conda activate ${ENV}
# 
# # Reenable strict error checking.
# set -eu

WD="$PWD"
Scripts=/home/zhouxingchen/DATABASE/NCBI-Genome

############################################
myGenera="Aspergillus" # "Trichoderma" # "Cryptococcus"                             # "Malassezia"
# 
mySpeicesPara="aspergillus"


[ ! -d $WD/$myGenera/temp_bin ] && mkdir -p $WD/$myGenera/temp_bin
:>"$WD"/${myGenera}_predict.list
for i in "$WD"/$myGenera/GCA*_genomic.fna.gz;
do

MM=$(basename $i _genomic.fna.gz )
:>$WD/$myGenera/temp_bin/${MM}.sh
cat > $WD/$myGenera/temp_bin/${MM}.sh <<EOF
#!/bin/bash

echo -e "\033[32m# start Initializing environment:${ENV}($(date)) ...... \033[0m"
set +e
source ${CONDA_DIR}/etc/profile.d/conda.sh
conda activate ${ENV}
set -eu

echo -e "\033[32m# 1. start Wrangling genomic data:$myGenera/${MM}_genomic.fna($(date)) ...... \033[0m"
[ ! -s $WD/$myGenera/${MM}_genomic.fna ] && \
    gzip -dc $i | awk -F" " -v n=1 '{if (\$0 ~ /^>/) print ">scaffold_"n++; else print \$0 }' \
    > $WD/$myGenera/${MM}_genomic.fna


echo -e "\033[32m# 2. start Masking repeat sequence:$myGenera/${MM}_genomic.masked.fna($(date)) ...... \033[0m"
[ ! -s $WD/$myGenera/${MM}_genomic.masked.fna ] && \
    $Scripts/funannotate-docker mask \
        -i $WD/$myGenera/${MM}_genomic.fna \
        -o $WD/$myGenera/${MM}_genomic.masked.fna \
        --cpus 12

echo -e "\033[32m# 3. start Sorting contigs:$myGenera/${MM}_genomic.sorted.fna($(date)) ...... \033[0m"
[ ! -s $WD/$myGenera/${MM}_genomic.sorted.fna ] && \
    $Scripts/funannotate-docker sort \
        -i $WD/$myGenera/${MM}_genomic.masked.fna \
        -o $WD/$myGenera/${MM}_genomic.sorted.fna \
        -s --minlen 1000

echo -e "\033[32m# 4. start Predicting Coding sequences:$myGenera/${MM}_predict($(date)) ...... \033[0m"
[ ! -s $WD/$myGenera/${MM}_predict/predict_results/*.proteins.fa ] && \
    $Scripts/funannotate-docker predict \
        -i $WD/$myGenera/${MM}_genomic.sorted.fna \
        -o $WD/$myGenera/${MM}_predict \
        -s "$mySpeicesPara"  \
        --min_protlen 10 \
        --min_intronlen 5 \
        --cpus 12 \
        --name "${MM}_GeneID" && \
        rm -rf $WD/$myGenera/${MM}_predict/predict_misc

echo -e "\033[32m# 5. Finishing funannotate analysis processing & cleanup $myGenera/${MM}_predict/predict_misc($(date)) ...... \033[0m"

EOF

echo "bash $WD/$myGenera/temp_bin/${MM}.sh 2>&1 | tee -a $WD/$myGenera/temp_bin/${MM}_command.log" >> "$WD"/${myGenera}_predict.list

done

/home/zhouxingchen/miniconda3/bin/ParaFly -c "$WD"/${myGenera}_predict.list -CPU 20
