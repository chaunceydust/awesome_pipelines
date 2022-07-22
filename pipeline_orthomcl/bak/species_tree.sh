#!/bin/bash

WD=$PWD
[ ! -d $WD/species_tree ] && mkdir -p $WD/species_tree
WD=$WD/species_tree

cd $WD

# 2.1 根据 orthomcl 结果提取单拷贝同源基因
orthomcl_findSingleCopyOrtholog.pl ../orthomcl/groups.txt ../orthomcl/compliantFasta/

fastas2aligned_by_mafft.pl SingleCopyOrthologGroups 120

Gblocks allSingleCopyOrthologsAlign.fasta -t=p
# 51 sequences and 26266 positions in the first alignment file:
# allSingleCopyOrthologsAlign.fasta
# 
# allSingleCopyOrthologsAlign.fasta
# Original alignment: 26266 positions
# Gblocks alignment:  22641 positions (86 %) in 228 selected block(s)

/opt/biosoft/RAxML-8.2.12/usefulScripts/convertFasta2Phylip.sh allSingleCopyOrthologsAlign.fasta-gb > allSingleCopyOrthologsAlign.phy

/opt/sysoft/mpich2-1.5/bin/mpirun -np 30 /opt/biosoft/RAxML-8.2.12/raxmlHPC-HYBRID-SSE3 -f a -x 12345 -p 12345 -# 1000 -m PROTGAMMAILGX -s allSingleCopyOrthologsAlign.phy -n out -T 8
# nucl -m GTRGAMMA
# Overall execution time for full ML analysis: 96959.353104 secs or 26.933154 hours or 1.122215 days
# 
# 
# real    1616m2.486s
# user    193440m41.621s

for m in RAxML_b*.out;
do
	cp $m ${m}.bak
done

# perl -p -e 's#\s+#/#; s#^#perl -p -i -e "s/#; s#\n$#/" RAxML_bipartitionsBranchLabels.out\n#;' reflect.txt | sh
# perl -p -e 's#\s+#/#; s#^#perl -p -i -e "s/#; s#\n$#/" RAxML_bestTree.out\n#;' reflect.txt | sh
# perl -p -e 's#\s+#/#; s#^#perl -p -i -e "s/#; s#\n$#/" RAxML_bipartitions.out\n#;' reflect.txt | sh
# perl -p -e 's#\s+#/#; s#^#perl -p -i -e "s/#; s#\n$#/" RAxML_bootstrap.out\n#;' reflect.txt | sh
