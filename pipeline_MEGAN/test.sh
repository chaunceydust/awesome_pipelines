#!/usr/bin/env bash


for i in */7_Total_Uniq_Gene_fungi/*.daa;
do
    myDir=$(dirname $(dirname $i))
    [ -e $myDir/8_MEGAN_fungi/$(basename $i) ] && echo "$i has completed!!!" && continue
    echo $i
done
