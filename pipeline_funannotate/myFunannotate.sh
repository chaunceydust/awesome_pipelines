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

[ ! -d $WD/Candida/temp_bin ] && mkdir -p $WD/Candida/temp_bin
:>"$WD"/Candida_predict.list
for i in "$WD"/Candida/GCA*_genomic.fna.gz;
do

MM=$(basename $i _genomic.fna.gz )
:>$WD/Candida/temp_bin/${MM}.sh
cat > $WD/Candida/temp_bin/${MM}.sh <<EOF
#!/bin/bash

set +e
source ${CONDA_DIR}/etc/profile.d/conda.sh
conda activate ${ENV}
set -eu

gzip -dc $i | awk -F" " -v n=1 '{if (\$0 ~ /^>/) print ">scaffold_"n++; else print \$0 }' > $WD/Candida/${MM}_genomic.fna
$Scripts/funannotate-docker mask -i $WD/Candida/${MM}_genomic.fna -o $WD/Candida/${MM}_genomic.masked.fna --cpus 12
$Scripts/funannotate-docker sort -i $WD/Candida/${MM}_genomic.masked.fna -o $WD/Candida/${MM}_genomic.sorted.fna -s --minlen 1000
$Scripts/funannotate-docker predict -i $WD/Candida/${MM}_genomic.sorted.fna -o $WD/Candida/${MM}_predict \
                                    -s "Candida albicans"  --min_protlen 10 --min_intronlen 5 --cpus 12 \
                                    --name "${MM}_GeneID" 

EOF

echo "bash $WD/Candida/temp_bin/${MM}.sh 2>&1 | tee -a $WD/Candida/temp_bin/${MM}_command.log" >> "$WD"/Candida_predict.list

done

/home/zhouxingchen/miniconda3/bin/ParaFly -c "$WD"/Candida_predict.list -CPU 20
