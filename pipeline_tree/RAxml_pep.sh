#!/bin/bash
set -exuo pipefail

for m in *.fa
do
	mafft --auto $m > $(basename $m .fa).align

	Gblocks $(basename $m .fa).align -t=p

	/opt/biosoft/RAxML-8.2.12/usefulScripts/convertFasta2Phylip.sh \
		$(basename $m .fa).align-gb \
		>$(basename $m .fa).align.phy
	java -jar /opt/biosoft/prottest-3.4.2/prottest-3.4.2.jar \
		-i $(basename $m .fa).align.phy \
		-all-distributions \
		-F -AIC -BIC -tc 0.5 \
		-threads 120 \
		-o prottest.out

	/opt/sysoft/mpich2-1.5/bin/mpirun -np 15 \
		/opt/biosoft/RAxML-8.2.12/raxmlHPC-HYBRID-SSE3 \
		-f a -x 12345 -p 12345 -# 1000 \
		-m PROTGAMMAILGX \
		-s $(basename $m .fa).align.phy \
		-n out \
		-T 8

done
