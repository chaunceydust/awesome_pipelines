load('step1.Rdata')
library(DESeq2)
library(limma)

colData <- data.frame(row.names=colnames(Expr), group=group)
dds <- DESeqDataSetFromMatrix(countData = Expr,
                              colData = colData,#Rows of colData correspond to columns of countData
                              design = ~ group)
dds2 <- DESeq(dds)
resultsNames(dds2)#results extracts a result table from a DESeq analysis giving base means across samples,log2 fold changes, standard errors, test statistics, p-values and adjusted p-values;                                                  resultsNames returns the names of the estimated effects (coefficents) of the model;                                                removeResults returns a DESeqDataSet object with results columns removed.

res <- results(dds2, contrast=c("group","SUZ","ctrl"))#this argument specifies what comparison to extract from the object to build a results table
resOrdered <- res[order(res$padj),]#padj排序
resOrdered=as.data.frame(resOrdered)

resOrdered$change<-as.factor(ifelse(resOrdered$pvalue>0.05,'No', #如果FDR>0.05，则定义为'No'，否则进行下一步的ifelese
                                    ifelse(resOrdered$log2FoldChange>1,'Up', #在FDR<=0.05前提下，logFC>0.05则定义'Up',否则进行下一步的ifelse
                                           ifelse(resOrdered$log2FoldChange< -1,'Down','No'))))
table(resOrdered$change) #u:45,d:136,n:25025
diff_gene <- resOrdered[which(resOrdered$pvalue<0.05 & abs(resOrdered$log2FoldChange)>1),]
write.csv(diff_gene,'diff_gene.csv')
save(Expr,group,resOrdered,diff_gene,file = 'step3_diff.Rdata')


#rld <- rlogTransformation(dds2) DESeq标准化
#exprSet_new=assay(rld)

