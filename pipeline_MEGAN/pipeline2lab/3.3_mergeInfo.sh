#!/usr/bin/env bash
set -e
 
Data="$(dirname $PWD)"
myPop="$(basename $Data)"
Scripts1="/home/zhouxingchen/miniconda3/bin"
Scripts2="/home/Metagenome/SZX/metagenome"
 
 
#### merge abundance
cd $Data/9_Relative_Abun_fungi
 
echo -ne "gene.id\trelat.abundance\n" > ${myPop}.clean.allsample.relativeGeneAbundance.txt
 
for samp in *.clean.aln.relativeGeneAbundance.txt;
do
    BASE=$(basename $samp .clean.aln.relativeGeneAbundance.txt);
    tail -n +2 $samp | sed "s/GENE/${BASE}_GENE/g" >> ${myPop}.clean.allsample.relativeGeneAbundance.txt;
    echo -e "\033[32m$myPop $BASE has completed!\033[0m"
done
 
 
####
$Scripts1/Rscript $Scripts2/megan_info_formatting.R \
    --working_directory "$Data/8_MEGAN_fungi"
 
####
$Scripts1/Rscript $Scripts2/meganAbundance.R \
    --working_directory "$Data/8_MEGAN_fungi" \
    --pop "$myPop" \
    --sep "_" \
    --mapping "$Data/7_Total_Uniq_Gene_fungi/Total.cds.seqid2representid.txt" \
    --abundance "$Data/9_Relative_Abun_fungi/${myPop}.clean.allsample.relativeGeneAbundance.txt" \
    --rank "Phylum;Class;Order;Family;Genus;Species;TaxonomyLineage"
