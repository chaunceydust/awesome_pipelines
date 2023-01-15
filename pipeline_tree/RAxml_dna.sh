#!/bin/bash
set -exuo pipefail

for m in *.fa
do
	mafft --auto $m > $(basename $m .fa).align

	Gblocks $(basename $m .fa).align -t=D	# P (Proteins), C (Codons) or D (DNA)

	/opt/biosoft/RAxML-8.2.12/usefulScripts/convertFasta2Phylip.sh \
		$(basename $m .fa).align-gb \
		>$(basename $m .fa).align.phy


	/opt/sysoft/mpich2-1.5/bin/mpirun -np 15 \
		/opt/biosoft/RAxML-8.2.12/raxmlHPC-HYBRID-SSE3 \
		-f a -x 12345 -p 12345 -# 1000 \
		-m GTRGAMMA \
		-s $(basename $m .fa).align.phy \
		-n out \
		-T 8

done
