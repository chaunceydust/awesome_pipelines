#!/usr/bin/env bash

#################################################################################################
#
# bacteria taxanomy file: /project/zhouxingchen/bins/ref_genomes_gene_taxanomy.txt
# bacteria total protein sequences: /project/Ref_database/HMP/pep_cds_genome/ref_genomes.pep.fa
# EUKY taxanomy file: /project/Pep-Seq/ref_genome_EUKY/ref_genomes_euky_gene_taxanomy.txt
#
#################################################################################################

WD=$(dirname $PWD)

TAXANOMY_db=/project/Pep-Seq/ref_genome_EUKY/ref_genomes_euky_gene_taxanomy.txt
TOTAL_Pep_seq=/project/Ref_database/HMP/pep_cds_genome/ref_genomes.pep.fa

bash 00_run_all.sh

[ ! -d $WD/05_taxonomy ] && mkdir -p $WD/05_taxonomy
Rscript anno_taxonomy.R \
    --taxonomy $TAXANOMY_db \
    --working_directory $WD

if [ 1 == 2 ]; then
    tail -n +2 ../04_Annotation/Annotation_P80_L80.tsv | awk -F'\t' '{print $1}' > besthit_gene.list

    seqkit grep -f besthit_gene.list $TOTAL_Pep_seq > besthit_gene_total.fa

    seqkit rmdup -s -D seqkit.dup.record.log -d besthit_gene_dup.fa -o besthit_gene_uni.fa besthit_gene_total.fa
fi
