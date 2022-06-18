#!/usr/bin/env bash
set -e

# default
myScripts="/home/zhouxingchen/miniconda3/bin"

WD="$PWD"
myGenera="Clavispora" # "candida"
myFolder="$WD/$myGenera"
myMeta="$myFolder/${myGenera}_metadata.tab"

# cat ensembl_fungi_genera.list | while read id
tail -n +306 ensembl_fungi_genera.list | while read id
do
    myGenera="$id"
    myFolder="$WD/$myGenera"
    myMeta="$myFolder/${myGenera}_metadata.tab"
    myLog="$myFolder/${myGenera}_file.list"
    
    [ ! -d "$myFolder" ] && mkdir -p "$myFolder"
    :>"$myLog"
    $myScripts/ncbi-genome-download \
        --genera $myGenera \
        --output-folder $myFolder \
        --metadata-table $myMeta \
        --fuzzy-genus \
        -s genbank \
        --formats fasta \
        --parallel 10 \
        --retries 1000 \
        --progress-bar \
        --flat-output \
        --human-readable \
        --dry-run \
        fungi \
        2>&1 | tee -a $myLog
    
    $myScripts/ncbi-genome-download \
        --genera $myGenera \
        --output-folder $myFolder \
        --metadata-table $myMeta \
        --fuzzy-genus \
        -s genbank \
        --formats fasta \
        --parallel 10 \
        --retries 1000 \
        --progress-bar \
        --flat-output \
        --human-readable \
        fungi

    sleep 60

done
