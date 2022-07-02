#!/usr/bin/env bash
set -ex

if [ 1 = 2] ; then
    echo -e "Indi.id\tgene.id\trelat.abundance" > HADZA_allIndi.clean.aln.relativeGeneAbundance.txt;for i in *.clean.aln.relativeGeneAbundance.txt;do indi=$(basename $i .clean.aln.relativeGeneAbundance.txt); tail -n +2 $i | awk -F'\t' -v myindi=$indi -v OFS='\t' '{print myindi,$0}'>> HADZA_allIndi.clean.aln.relativeGeneAbundance.txt ;done
fi

WD=$(dirname $PWD)
QueryPath=/project/Pep-Seq

dbSeqsList="database.list"
#### copy Subject Sequences(database)
[ -d $WD/00_BlastDB ] && rm -rf $WD/00_BlastDB
[ ! -d $WD/00_BlastDB ] && mkdir -p $WD/00_BlastDB
cat $dbSeqsList | xargs -I {} cp {} $WD/00_BlastDB
seqSuffix=` for i in $WD/00_BlastDB/*;do echo $i;done | awk -F'.' '{print $NF}' | sort | uniq `
echo $seqSuffix
[ $seqSuffix != "fasta" ] && rename $seqSuffix  fasta $WD/00_BlastDB/*.${seqSuffix}

bash 0_makeblastdb.sh

#### query: Population
for Pop in AMR Aus Aut DNK EBH EBH2 Fra HADZA JPN KOR Peru Sweden;
do
    readlink -e ${QueryPath}/${Pop}/*.fa > ./query_${Pop}.list

    [ ! -d $WD/${Pop} ] && mkdir -p $WD/${Pop}
    bash 00_run_all.sh -d ../database.list -q ./query_${Pop}.list -p $Pop -j 40 -s 5
done

