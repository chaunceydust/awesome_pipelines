#!/usr/bin/env Rscript

library(clusterProfiler)
KOannotation <- read.delim("D:/RProject/MedicalPlantDB/KOannotation.tsv", stringsAsFactors=FALSE)
GOannotation <- read.delim("D:/RProject/MedicalPlantDB/GOannotation.tsv", stringsAsFactors=FALSE)
GOinfo <- read.delim("D:/RProject/MedicalPlantDB/go.tb", stringsAsFactors=FALSE)
# 前面获取gene list的过程略
gene_list<- # 你的gene list

# GO富集
## 拆分成BP，MF，CC三个数据框
GOannotation = split(GOannotation, with(GOannotation, level))

## 以MF为例
enricher(
  gene_list,
  TERM2GENE=GOannotation[['molecular_function']][c(2,1)],
  TERM2NAME=GOinfo[1:2]
)

# KEGG富集
enricher(
  gene_list,
  TERM2GENE=KOannotation[c(3,1)],
  TERM2NAME=KOannotation[c(3,4)]
)
