#!/bin/bash

WD=$(dirname $PWD)
[ ! -d $WD/orthomcl ] && mkdir -p $WD/orthomcl
WD=$WD/orthomcl

cd $WD

# 1.10 使用 mcl 对 pairs 进行聚类（Ortholog Cluster Groups）并对类进行编号
/opt/biosoft/mcl-14-137/bin/mcl mclInput --abc -I 1.5 -o mclOutput

# Please cite:
#     Stijn van Dongen, Graph Clustering by Flow Simulation.  PhD thesis,
#     University of Utrecht, May 2000.
#        (  http://www.library.uu.nl/digiarchief/dip/diss/1895620/full.pdf
#        or  http://micans.org/mcl/lit/svdthesis.pdf.gz)
# OR
#     Stijn van Dongen, A cluster algorithm for graphs. Technical
#     Report INS-R0010, National Research Institute for Mathematics
#     and Computer Science in the Netherlands, Amsterdam, May 2000.
#        (  http://www.cwi.nl/ftp/CWIreports/INS/INS-R0010.ps.Z
#        or  http://micans.org/mcl/lit/INS-R0010.ps.Z)
# 
# 
# real	2m3.429s
# user	1m59.793s
# sys	0m3.619s

/opt/biosoft/orthomclSoftware-v2.0.9/bin/orthomclMclToGroups OCG 1 < mclOutput > groups.txt
perl -e 'open IN, $ARGV[0]; @num = <IN>; $num = @num; $len = length($num); foreach (@num) { m/OCG(\d+)/; $id = 0 x ($len - length($1)); s/OCG/OCG$id/; print;} ' groups.txt > aa; mv aa groups.txt

# 1.11 对 groups.txt 进行同源基因数量的统计
orthomcl_genes_number_stats.pl groups.txt compliantFasta > genes_number_stats.txt

orthomcl_get_outParalog.pl groups.txt similarSequences.txt


# 1.12 
extract_representative_sequences.pl goodProteins.fasta groups.txt Total.pep.seqid.txt Total.pep.representid.txt Total.pep.representid.fa

# 1.13
CountGenes.pl
