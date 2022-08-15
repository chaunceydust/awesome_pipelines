#!/usr/bin/env bash
set -e
 
# default
WD="$(dirname $PWD)"
MEGAN="/home/zhouxingchen/megan6_22_2"
MEGAN_db="/home/Metagenome/Ref_database/MEGAN-DB"
 
# CPU
declare -i ComputerThreads=`cat /proc/cpuinfo | grep "processor" | wc -l`
 
#
for pop in "$WD"/7_Total_Uniq_Gene_fungi/*.rma;
do
    myDir=$(dirname $(dirname $pop))
    myBase=$(basename $pop .rma)
 
    [ ! -d $myDir/8_MEGAN_fungi ] && mkdir -p $myDir/8_MEGAN_fungi
 
    [ -e $myDir/8_MEGAN_fungi/${myBase}.rma ] && echo -e "\033[32m# $myDir 'has completed' \033[0m" && continue
 
    :>$myDir/8_MEGAN_fungi/megan_run`date +%Y%m%d`.log
 
    declare -i CPU=$(top -bn1 | grep load | awk '{printf "%.0f", $(NF - 2)}')
    declare -i myThreads=$(($ComputerThreads - $CPU))
 
    # cp -- "$pop" "$myDir/8_MEGAN_fungi/${myBase}.rma"
    mv "$pop" "$myDir/8_MEGAN_fungi/${myBase}.rma"
 
    echo -e "\033[32m# CPUs: $myThreads ($(date))\033[0m" \
        2>&1 | tee -a $myDir/8_MEGAN_fungi/megan_run`date +%Y%m%d`.log
 
 
    #### Reads to Taxonomy
    echo -e "\033[32m# Reads to Taxonomy analysis start($(date))\033[0m" \
        2>&1 | tee -a $myDir/8_MEGAN_fungi/megan_run`date +%Y%m%d`.log
    "$MEGAN"/tools/rma2info \
        --in "$myDir/8_MEGAN_fungi/${myBase}.rma" \
        --out "$myDir/8_MEGAN_fungi/${myBase}.Reads2Taxonomy.txt" \
        -c2c Taxonomy \
        -r2c Taxonomy \
        --names true \
        --paths true  \
        --prefixRank true  \
        --majorRanksOnly true \
        --list true \
        --listMore true \
        2>&1 | tee -a $myDir/8_MEGAN_fungi/megan_run`date +%Y%m%d`.log
 
 
    #### Reads to Functional Class
    for info in EC EGGNOG GTDB INTERPRO2GO SEED ## KEGG
    do
        echo -e "\033[32m# Reads to $info analysis start($(date))\033[0m" \
            2>&1 | tee -a $myDir/8_MEGAN_fungi/megan_run`date +%Y%m%d`.log
 
        "$MEGAN"/tools/rma2info \
            --in "$myDir/8_MEGAN_fungi/${myBase}.rma" \
            --out "$myDir/8_MEGAN_fungi/${myBase}.Reads2${info}.txt" \
            -r2c "$info" \
            -c2c "$info" \
            --names true \
            --paths true \
            --list true \
            --listMore true \
            2>&1 | tee -a $myDir/8_MEGAN_fungi/megan_run`date +%Y%m%d`.log
    done
 
done
