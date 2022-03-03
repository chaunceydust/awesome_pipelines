#!/bin/bash
set -exuo pipefail

usage()
{
cat <<EOF >&2
Usage:
    bash $0 -d database.list -q query.list -j 160 -s 2

OPTIONS:
    -d database file(the list of individual target protein sequences file with full path, each per line.), default database.list
    -q query file, recommend must give
    -h/? show help of script
Example:
    bash $0 -d database.list -q query.list
EOF
}

# Default parameter
threadCutoff=160
evalueCutoff=1e-5
resultfmt=0
singleThreads=2

while getopts "d:q:j:s:f:e:h" OPTION
do
    case $OPTION in
        d)
            dbSeqsList=$OPTARG
            ;;
        q)
            querySeqsList=$OPTARG
            ;;
        j)
            threadCutoff=$OPTARG
            ;;
        s)
            singleThreads=$OPTARG
            ;;
        f)
            resultfmt=$OPTARG
            ;;
        e)
            evalueCutoff=$OPTARG
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


#### copy Subject Sequences(database)
[ -d $WD/00_BlastDB ] && rm -rf $WD/00_BlastDB
[ ! -d $WD/00_BlastDB ] && mkdir -p $WD/00_BlastDB
cat $dbSeqsList | xargs -I {} cp {} $WD/00_BlastDB
seqSuffix=` for i in $WD/00_BlastDB/*;do echo $i;done | awk -F'.' '{print $NF}' | sort | uniq `
echo $seqSuffix
[ $seqSuffix != "fasta" ] && rename $seqSuffix  fasta $WD/00_BlastDB/*.${seqSuffix}

#### copy Query Sequences
[ -d $WD/01_sequences ] && rm -rf $WD/01_sequences
[ ! -d $WD/01_sequences ] && mkdir -p $WD/01_sequences
cat $querySeqsList | xargs -I {} ln -s {} $WD/01_sequences
seqSuffix=` for i in $WD/01_sequences/*;do echo $i;done | awk -F'.' '{print $NF}' | sort | uniq `
echo $seqSuffix
[ $seqSuffix != "fasta" ] && rename $seqSuffix  fasta $WD/01_sequences/*.${seqSuffix}


####
bash 0_makeblastdb.sh

####
if [ "serial" = "serial" ];
then
    bash 1_blast_parallel.sh -j $threadCutoff -s $singleThreads -f $resultfmt -e $evalueCutoff
else
    bash 1_blast_serial.sh
fi

####
bash 2_anno_parallel.sh -j $threadCutoff
