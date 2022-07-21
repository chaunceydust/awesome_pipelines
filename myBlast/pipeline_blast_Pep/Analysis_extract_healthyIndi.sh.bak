#!/bin/bash

WD=$(dirname $PWD)

[ ! -d $WD/Analysis/Pop_healthy ] && mkdir -p $WD/Analysis/Pop_healthy
cd $WD/Analysis/Pop_healthy
for i in AMR Aus Aut DNK EBH EBH2 Fra HADZA JPN KOR Peru Sweden # CHN GER USA
do
	# cp $WD/$i/2_Anno_62/*abundance.taxonomy.txt .
    cp $WD/$i/04_Annotation/Annotation_P45_L50_relAbun.tsv ./${i}_Annotation_P45_L50_relAbun.tsv
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
cp /project/zhouxingchen/AMP_deeplearning/Pop/pipeline_blast_Pep/1_extract_health_indi.pl .
perl 1_extract_health_indi.pl

for i in `ls 0_*.tsv`;
do
	mv $i ../${i#*_}
done

cd ../
: > 12Population_abun_taxa.txt

head -1 AT*.tsv > 12Population_abun_taxa.txt
for x in `ls *_relAbun.tsv`;
do
	tail -n +2 $x >> 12Population_abun_taxa.txt
done
