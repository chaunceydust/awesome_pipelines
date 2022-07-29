#!/usr/bin/env bash

# Default environment name.
# Conda directory name.
CONDA_DIR=/home/zhouxingchen/miniconda3

# The conda shell cannot be run in strict mode.
set +ue

# Apply the environment.
source ${CONDA_DIR}/bin/activate

# Reenable strict error checking.
set -eu


WD=$(dirname $PWD)

myStrain="Candida"
myWD=$( dirname "$WD"/${myStrain}_PanGenome/OrthoFinder/Results_*/Orthogroups/Orthogroups.tsv )
myScript="$PWD"/Scripts_of_Orthofinder

echo "Rscript working_directory: "$myWD
echo "2016@cpu" | sudo -S chown -R "$USER":"$USER" "$myWD"
echo "2016@cpu" | sudo -S chmod -R g+rwx "$myWD"

Rscript $myScript/mergeGeneCountsTable.R --working_directory $myWD


perl $myScript/extratc.pl \
  --input $myWD/Orthogroups.txt \
  --Unassign $myWD/Orthogroups_UnassignedGenes.tsv \
  --output $myWD/Total_sequences_refID2oriID.txt


:>$myWD/PepSequencesLength.txt
for i in "$WD"/${myStrain}_PanGenome/GCA*_proteins.faa;
do
  awk '/^>/&&NR>1{print "";}{ printf "%s",/^>/ ? $0" ":$0 }' $i |awk '{print $1"\t"length($2)}' >> $myWD/PepSequencesLength.txt
done
sed -i "s/>//g" $myWD/PepSequencesLength.txt


Rscript $myScript/extractRefID.R --working_directory $myWD


:>$myWD/Total.oriID.fa;for i in "$WD"/${myStrain}_PanGenome/GCA*_proteins.faa;do seqkit grep -f $myWD/GeneID.list $i | awk '/^>/&&NR>1{print "";}{ printf "%s",/^>/ ? $0"\t":$0 }'  | sed "s/>//g" >> $myWD/Total.oriID.fa; echo -ne "\n" >> $myWD/Total.oriID.fa;done
sed -i "/^$/d" $myWD/Total.oriID.fa

Rscript $myScript/generateFinalSeq.R --working_directory $myWD
