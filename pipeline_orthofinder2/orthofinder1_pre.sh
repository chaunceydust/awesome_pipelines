#!/usr/bin/bash
set -e

WD=$(dirname $PWD)

for m in Malassezia;
do
    Strain=$m
    [ ! -d "$WD/${Strain}_PanGenome" ] && mkdir -p "$WD/${Strain}_PanGenome"
    cat $WD/$m/select.list | while read id
    do
        # cp -- $WD/$m/${id}_predict/predict_results/*.proteins.fa $WD/0_src_protein/${id}_proteins.faa

        awk -F" " '{if ($0 ~ /^>/)print $1;else print $0}' "$WD/$m/${id}_predict/predict_results/"*.proteins.fa > "$WD/${Strain}_PanGenome/${id}_proteins.faa"

        sed -i "s/-T1//g;s/GeneID_/_GI/g" "$WD/${Strain}_PanGenome/${id}_proteins.faa"
    done
done
