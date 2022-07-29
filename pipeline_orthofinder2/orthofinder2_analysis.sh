#!/usr/bin/env bash
set -e

myStrain="Malassezia"
myWD="$(dirname $PWD)/${myStrain}_PanGenome"

docker run --ulimit nofile=1000000:1000000 -it --rm \
    -v "$myWD":/input:Z \
    davidemms/orthofinder:2.5.4 \
    orthofinder \
    -f /input \
    -S diamond \
    -M dendroblast \
    -t 208 \
    -a 208 \
    2>&1 | tee -a $myWD/orthofinder_p1_`date +%Y%m%d`.log && \
    echo -ne "\n\n`date`\nCompleted" '!!!' >> $myWD/orthofinder_p1_`date +%Y%m%d`.log


ResultName=$(basename $myWD/OrthoFinder/Results_*)
echo $ResultName
docker run --ulimit nofile=1000000:1000000 -it --rm \
    -v "$myWD":/input:Z \
    davidemms/orthofinder:2.5.4 \
    orthofinder \
    -b /input/OrthoFinder/$ResultName/WorkingDirectory \
    -M msa \
    -T fasttree \
    -t 208 \
    -a 208 \
    2>&1 | tee -a $myWD/orthofinder_p2_`date +%Y%m%d`.log && \
    echo -ne "\n\n`date`\nCompleted" '!!!' >> $myWD/orthofinder_p2_`date +%Y%m%d`.log
