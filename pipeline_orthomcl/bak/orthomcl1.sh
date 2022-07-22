#!/bin/bash

WD=$PWD
[ ! -d $WD/orthomcl ] && mkdir -p $WD/orthomcl
WD=$WD/orthomcl

# 1.1 准备 OrthoMCL 的输入文件
# 输入文件是包含多个 Fasta 文件的文件夹，每个 Fasta 文件是一个物种的蛋白质组序列。每个 Fasta 文件的序列名必须满足格式, 示例: >ncra|NCU02040 。用 '|' 分开，前者>代表物种名，推荐和 Fasta 文件名前缀一致，后者代表独一无二蛋白质ID。 可以使用 orthomclAdjustFasta 对一般的 Fasta 文件进行处理，使之和 OrthoMCL 软件兼容。
mkdir -p $WD/compliantFasta
cd $WD/compliantFasta

# ln /project/zxc/Genome_annotation/C.auris200776/01_Structural/02_gene_prediction/maker/02_Pep/GCA*_proteins.fa ./
# 
# for m in GCA*proteins.fa;
# do
# 	strain=$(basename $m _proteins.fa)
# 	sed -i "s/>GCA.*-GENEM/>GENEM/g;s/-RA//g" $m
# 	sed -i "s/^$/M/g" $m
# 	orthomclAdjustFasta $strain $m 1
# 	rm $m
# done

cd ..

# 1.2 过滤低质量序列。允许的最短的 protien 长度是 30，终止密码子最大比例为 20% 。

orthomclFilterFasta compliantFasta/ 30 20
# 该命令只能过滤低质量序列。而输入文件中最好还需要过滤掉可变剪切。

# 1.3 对过滤后的结果 goodProteins.fasta 进行 all-vs-all BLAST
diamond makedb --in goodProteins.fasta -d goodProteins
diamond blastp --db goodProteins --query goodProteins.fasta --out diamond.xml --outfmt 5 --sensitive --max-target-seqs 500 --evalue 1e-5 --id 20 --tmpdir /dev/shm
# real	2m3.987s
# user	190m36.889s
# sys	0m35.544s

parsing_blast_result.pl --no-header --max-hit-num 500 --evalue 1e-9 --identity 0.1 --CIP 0.3 --subject-coverage 0.5 --query-coverage 0.5 diamond.xml > diamond.tab


# 1.4 对 Blast 的结果进行处理，得到序列两两之间的相似性信息，以利于导入到 mysql 
orthomclBlastParser diamond.tab compliantFasta/ > similarSequences.txt
# similarSequences.txt 文件内容有 8 列：query_id, subject_id, query_taxon, subject_taxon, evalue_mant, evalue_exp, percent_ident 和 percent_match 。

perl -p -i -e 's/0\t0/1\t-181/' similarSequences.txt
