#!/usr/bin/env Rscript

library(clusterProfiler)
KOannotation <- read.delim("parsed.emapper.annotations/KOannotation.tsv", stringsAsFactors=FALSE)
GOannotation <- read.delim("parsed.emapper.annotations/GOannotation.tsv", stringsAsFactors=FALSE)
GOinfo <- read.delim("go.tb", stringsAsFactors=FALSE)
# 前面获取gene list的过程略

geneCounts <- read.delim("GeneCounts.tab", stringsAsFactors = FALSE)

site="https://mirrors.tuna.tsinghua.edu.cn/CRAN"
package_list = c("VennDiagram")
for(p in package_list){
  if(!suppressWarnings(suppressMessages(require(p, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)))){
    install.packages(p, repos=site)
    suppressWarnings(suppressMessages(library(p, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)))
  }
}

venn.nonCore.plot <- venn.diagram(
  x = list(
    '1170\'s gene' = geneCounts$OCGID[which(geneCounts$X1170 != 0)],
    '1173\'s gene' = geneCounts$OCGID[which(geneCounts$X1173 != 0)],
    '1174\'s gene' = geneCounts$OCGID[which(geneCounts$X1174 != 0)]
  ),
  filename = paste0("117x", "_Venn.tiff"),
  col = "transparent",
  fill = c("red", "blue", "green"),
  alpha = 0.5,
  label.col = c("darkred", "white", "darkblue", "white",
                "white", "white", "darkgreen"),
  cex = 2.5,
  fontfamily = "serif",
  fontface = "bold",
  cat.default.pos = "text",
  cat.col = c("darkred", "darkblue", "darkgreen"),
  cat.cex = 2.5,
  cat.fontfamily = "serif",
  cat.dist = c(0.08, 0.08, 0.03),
  cat.pos = 0
)

UniqGeneFlag <- apply(geneCounts[2:4], 1, 
                  function(x) sum(x != 0))
Uniq1170 <- geneCounts$OCGID[which(UniqGeneFlag == 1 & geneCounts$X1170 != 0)]
Uniq1173 <- geneCounts$OCGID[which(UniqGeneFlag == 1 & geneCounts$X1173 != 0)]
Uniq1174 <- geneCounts$OCGID[which(UniqGeneFlag == 1 & geneCounts$X1174 != 0)]
# gene_list<- # 你的gene list
  # GO富集
  ## 拆分成BP，MF，CC三个数据框
  GOannotation = split(GOannotation, with(GOannotation, level))
## 以MF为例
gene_list <- Uniq1174
enricher(gene_list,
         TERM2GENE=GOannotation[['molecular_function']][c(2,1)],
         TERM2NAME=GOinfo[1:2])

enricher(gene_list,
         TERM2GENE=GOannotation[['biological_process']][c(2,1)],
         TERM2NAME=GOinfo[1:2])

enricher(gene_list,
         TERM2GENE=GOannotation[['cellular_component']][c(2,1)],
         TERM2NAME=GOinfo[1:2])
# KEGG富集
enricher(gene_list,
         TERM2GENE=KOannotation[c(3,1)],
         TERM2NAME=KOannotation[c(3,4)])
