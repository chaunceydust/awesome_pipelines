#!/bin/bash
set -exuo pipefail

# Default parameter
threadCutoff=160

while getopts "p:j:t:f:e:h" OPTION
do
    case $OPTION in
        p)
            PopName=$OPTARG
            ;;
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

oriWD=$(dirname $PWD)
WD=$(dirname $PWD)/${PopName}



rm -rf $WD/tmp.anno.list*
rm -rf $WD/tmp.anno_end.list*

:> $WD/tmp.anno.list
:> $WD/tmp.anno_end.list

[ -d $WD/04_Annotation ] && rm -rf $WD/04_Annotation
[ ! -d $WD/04_Annotation ] && mkdir -p $WD/04_Annotation

for m in 30 45 62 80;
do
      [ -d $WD/03_ori_anno$m ] && rm -rf $WD/03_ori_anno$m
      [ ! -d $WD/03_ori_anno$m/tabs ] && mkdir -p $WD/03_ori_anno$m/tabs ;
      
      #### generate tab annotate configuration files
      cd $WD/03_ori_anno$m/tabs
      ln -s $oriWD/00_BlastDB/*.fasta .
      perl $oriWD/pipeline_blast_Pep/extract-tabs-append.pl
      sed -i "s/Iden/$m/g" ProteinName-originType.tab        # modify(custom) the identity cutoff        
  
      #### annoating
      cd $WD/03_ori_anno$m
      split -l 1 -d -a 8 $WD/02_blast_result/Samples.txt sampleN_
      ln -s $WD/02_blast_result/*.blastp .
      cp $oriWD/pipeline_blast_Pep/Blast_Anno.p* .
  
      ####
      for n in sampleN_*;
      do
          echo -ne "cd $WD/03_ori_anno$m; perl Blast_Anno.pl $n \n" >> $WD/tmp.anno.list
      done
 
    echo -ne "cd $WD/03_ori_anno$m;" >> $WD/tmp.anno_end.list
    echo -ne "perl $oriWD/pipeline_blast_Pep/fmt_anno.pl --output $WD/04_Annotation/Annotation_P${m}.tsv --pop ${PopName};" >> $WD/tmp.anno_end.list
    echo -ne "Rscript $oriWD/pipeline_blast_Pep/Add_abun.R /project/relateiveAbundance/${PopName}/${PopName}_allIndi.clean.aln.relativeGeneAbundance.tsv $WD/04_Annotation 50 80 90 95 \n" >> $WD/tmp.anno_end.list

done

num=$(cat $WD/tmp.anno.list | wc -l)
[ $num -gt $threadCutoff ] && num=$threadCutoff
ParaFly -c $WD/tmp.anno.list -CPU $num
ParaFly -c $WD/tmp.anno_end.list -CPU $num
