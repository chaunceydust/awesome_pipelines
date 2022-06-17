load('step3_diff.Rdata')
#id转化
id <- rownames(resOrdered)
head(id)
if(F){
  
  library('GeoTcgaData')
  gene <- id_conversion_vector('ensembl_gene_id','entrez_id',id)
}

id <- sub('.','_',id,fixed=T)
enst <- stringr::str_split(id,'_',simplify = T)[,1]
library("biomaRt")
#listMarts()
mart <- useMart("ensembl","hsapiens_gene_ensembl")##小鼠选择mmusculus_gene_ensembl
gene_id<-getBM(attributes=c("ensembl_transcript_id","entrezgene_id"),filters = "ensembl_transcript_id",values = enst, mart = mart)#将输入的filters设置未external_gene_name(也就是gene_symbol),将输出的attributes设置为external_gene_name和emsembl_gene_id
resOrdered$enst <- enst
resOrdered <- merge(resOrdered,gene_id,by.x='enst',by.y='ensembl_transcript_id')
resOrdered$entrezgene_id <- as.character(resOrdered$entrezgene_id)
id <- resOrdered$entrezgene_id
library('clusterProfiler') 
library(org.Hs.eg.db) 
gene_name<- bitr(id, fromType = "ENTREZID", toType=c("SYMBOL"),OrgDb = org.Hs.eg.db)
resOrdered <- merge(resOrdered,gene_name,by.x='entrezgene_id',by.y='ENTREZID')

write.table(resOrdered[resOrdered$change!='No',]$SYMBOL,file="PPI_gene_symbol.txt",
            row.names = F,quote = F,col.names = F) #将该文件上传STRING数据库，得到PPI分析结果
save(resOrdered, file = 'resOrdered_id.Rdata')
