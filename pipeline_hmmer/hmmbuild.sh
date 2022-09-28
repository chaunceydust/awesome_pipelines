#!/usr/bin/env bash

for i in *.fasta;
do
  mafft --auto --clustalout $i > $(basename $i .fasta).align.clustal

  python -c "from Bio import SeqIO;records = SeqIO.parse(\"$(basename $i .fasta).align.clustal\", \"clustal\");count = SeqIO.write(records, \"$(basename $i .fasta).align.stockholm\", \"stockholm\"); print(\"Converted %i records\" % count)"

  hmmbuild \
    --cpu 20 \
    $(basename $i .fasta).hmm \
    $(basename $i .fasta).align.stockholm \
    2>&1 | tee $(basename $i .fasta)_hmmdb_`date +%Y%m%d`.log
done
