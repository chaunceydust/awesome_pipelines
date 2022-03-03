#!/bin/bash
set -exuo pipefail

# Default parameter
threadCutoff=160

while getopts "j:t:f:e:h" OPTION
do
    case $OPTION in
        j)
            threadCutoff=$OPTARG
            ;;
        h)
            usage
            exit 1
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done

WD=$(dirname $PWD)



rm -rf $WD/pipeline_blast/tmp.anno.list*
rm -rf $WD/pipeline_blast/tmp.anno_end.list*

:> $WD/pipeline_blast/tmp.anno.list
:> $WD/pipeline_blast/tmp.anno_end.list

[ -d $WD/04_Annotation ] && rm -rf $WD/04_Annotation
[ ! -d $WD/04_Annotation ] && mkdir -p $WD/04_Annotation

for m in 1 25 30 45 50 62 80 90 95;
do
    [ -d $WD/03_ori_anno$m ] && rm -rf $WD/03_ori_anno$m
    [ ! -d $WD/03_ori_anno$m/tabs ] && mkdir -p $WD/03_ori_anno$m/tabs ;
    
    #### generate tab annotate configuration files
    cd $WD/03_ori_anno$m/tabs
    ln -s $WD/00_BlastDB/*.fasta .
    perl $WD/pipeline_blast/extract-tabs-append.pl
    sed -i "s/Iden/$m/g" ProteinName-originType.tab        # modify(custom) the identity cutoff        

    #### annoating
    cd $WD/03_ori_anno$m
    split -l 10 -d -a 8 $WD/02_blast_result/Samples.txt sample10_
    ln -s $WD/02_blast_result/*.blastp .
    cp $WD/pipeline_blast/Blast_Anno.p* .

    ####
    for n in sample10_*;
    do
        echo -ne "cd $WD/03_ori_anno$m; perl Blast_Anno.pl $n \n" >> $WD/pipeline_blast/tmp.anno.list
    done

    echo -ne "cd $WD/03_ori_anno$m;" >> $WD/pipeline_blast/tmp.anno_end.list
    echo -ne "perl $WD/pipeline_blast/fmt_anno.pl --output $WD/04_Annotation/Annotation_P${m}.tsv;" >> $WD/pipeline_blast/tmp.anno_end.list
    echo -ne "perl $WD/pipeline_blast/extract_Length2.pl --input $WD/04_Annotation/Annotation_P${m}.tsv --outputPrefix $WD/04_Annotation/Annotation_P${m}_L \n" >> $WD/pipeline_blast/tmp.anno_end.list

done

num=$(cat $WD/pipeline_blast/tmp.anno_end.list | wc -l)
[ $num -gt $threadCutoff ] && num=$threadCutoff
ParaFly -c $WD/pipeline_blast/tmp.anno.list -CPU $num
ParaFly -c $WD/pipeline_blast/tmp.anno_end.list -CPU $num
