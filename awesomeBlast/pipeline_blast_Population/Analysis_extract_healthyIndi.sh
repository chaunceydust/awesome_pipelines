#!/bin/bash

WD=$(dirname $PWD)

[ ! -d $WD/Analysis/Pop_healthy ] && mkdir -p $WD/Analysis/Pop_healthy


for Res in $WD/AMR/05_unfold_result/Annotation_*_relAbun_unfold.tsv
do
  myCutoff=$(basename $Res .tsv)

  [ ! -d $WD/Analysis/Pop_healthy/$myCutoff ] && mkdir -p $WD/Analysis/Pop_healthy/$myCutoff
  cd $WD/Analysis/Pop_healthy/$myCutoff

  for i in AMR Aus Aut DNK EBH EBH2 Fra HADZA JPN KOR Peru Sweden # CHN GER USA
  do
    cp $WD/$i/05_unfold_result/${myCutoff}.tsv ./${i}_${myCutoff}.tsv
  done

  DS=(`ls EBH*`)
  wc -l ${DS[*]}
  declare -i F1=`wc -l ${DS[*]} | awk '$2 ~ /total/{print $1-1}'`
  tail -n +2 ${DS[0]} >> ${DS[1]}
  declare -i F2=`wc -l ${DS[1]} | cut -f1 -d" "`
  if [ $F1 == $F2 ]
  then 
    rm ${DS[0]}
  fi

  N3=(AMR Aus Aut DNK EBH Fra HADZA JPN KOR Peru Sweden )
  N2=(US AU AT DK CN1 FR HZ JP KR PE SE )
  for i in `seq 0 ${#N3[*]}`
  do
    rename ${N3[i]} ${N2[i]} ${N3[i]}*
  done

  mkdir -p  Extrac-pop

  mv *.tsv ./Extrac-pop
  cd ./Extrac-pop
  cp $WD/pipeline_blast_Pep/1_extract_health_indi.pl .
  perl 1_extract_health_indi.pl --health_indi_list $WD/pipeline_blast_Pep/Pop_health_indi.tab
  rm -rf 1_extract_health_indi.pl

  for i in `ls 0_*.tsv`;
  do
    mv $i ../${i#*_}
  done

  cd ../
  : > ${myCutoff}_12Population_abun_taxa.txt
  
  head -1 AT*.tsv > ${myCutoff}_12Population_abun_taxa.txt
  for x in `ls *_relAbun_unfold.tsv`;
  do
    tail -n +2 $x >> ${myCutoff}_12Population_abun_taxa.txt
  done

done
