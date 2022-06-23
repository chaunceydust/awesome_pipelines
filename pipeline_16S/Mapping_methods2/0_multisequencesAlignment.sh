#!/usr/bin/env bash
set -e

[ ! -d tmp ] && mkdir -p tmp

for m in $(ls *.1.fasta)
do
cat > tmp/$(basename $m .fasta)_align.sh <<-EOF
seqkit sample -n 10000 $PWD/$m > $PWD/$(basename $m .fasta)_n100.fasta
cat $PWD/LAC_16S.rep.fa >> $PWD/$(basename $m .fasta)_n100.fasta

mafft --auto $PWD/$(basename $m .fasta)_n100.fasta > $PWD/$(basename $m .fasta)_n100.align.fasta

EOF
done

for m in $(ls *.2.fasta)
do
cat > tmp/$(basename $m .fasta)_align.sh <<-EOF
seqkit sample -n 10000 $PWD/$m > $PWD/$(basename $m .fasta)_n100.fasta
mv $PWD/$(basename $m .fasta)_n100.fasta $PWD/$(basename $m .fasta)_n100.fasta.tmp
seqkit seq -p -r $PWD/$(basename $m .fasta)_n100.fasta.tmp > $PWD/$(basename $m .fasta)_n100.fasta
rm -rf $PWD/$(basename $m .fasta)_n100.fasta.tmp
cat $PWD/LAC_16S.rep.fa >> $PWD/$(basename $m .fasta)_n100.fasta

mafft --auto $PWD/$(basename $m .fasta)_n100.fasta > $PWD/$(basename $m .fasta)_n100.align.fasta

EOF
done

:> align_new.list
ls tmp/*.sh | awk '{print "bash "$0}' >> align_new.list

ParaFly -c align_new.list -CPU 20
