library(ggplot2)
library(clusterProfiler)
library(org.Hs.eg.db)

### 对 MigDB中的全部基因集 做GSEA分析。
# http://www.bio-info-trainee.com/2105.html
# http://www.bio-info-trainee.com/2102.html 
{
  load(file = 'resOrdered_id.Rdata')
  DEG <- resOrdered
  geneList=DEG$log2FoldChange
  names(geneList)=DEG$SYMBOL
  geneList=sort(geneList,decreasing = T)
  #选择gmt文件（MigDB中的全部基因集）
  d='MsigDB/symbols'
  gmts <- list.files(d,pattern = 'all')
  gmts
  #GSEA分析
  library(GSEABase) # BiocManager::install('GSEABase')
  ## 下面使用lapply循环读取每个gmt文件，并且进行GSEA分析
  ## 如果存在之前分析后保存的结果文件，就不需要重复进行GSEA分析。
  f='gsea_results.Rdata'
  if(!file.exists(f)){
    gsea_results <- lapply(gmts, function(gmtfile){
      # gmtfile=gmts[2]
      geneset <- read.gmt(file.path(d,gmtfile)) 
      print(paste0('Now process the ',gmtfile))
      egmt <- GSEA(geneList, TERM2GENE=geneset, verbose=FALSE)
      head(egmt)
      # gseaplot(egmt, geneSetID = rownames(egmt[1,]))
      
      return(egmt)
    })
    # 上面的代码耗时，所以保存结果到本地文件
    save(gsea_results,file = f)
  }
  load(file = f)
  #提取gsea结果，熟悉这个对象
  gsea_results_list<- lapply(gsea_results, function(x){
    cat(paste(dim(x@result)),'\n')
    x@result
  })
  gsea_results_df <- do.call(rbind, gsea_results_list)
  gseaplot(gsea_results[[2]],'KEGG_CELL_CYCLE') 
  gseaplot(gsea_results[[2]],'FARMER_BREAST_CANCER_CLUSTER_6') 
  gseaplot(gsea_results[[5]],'GO_CARBOHYDRATE_METABOLIC_PROCESS') 
  
}
write.csv(gsea_results_df,'gsea_result.csv')

gseao <- gsea_results_df[order(gsea_results_df$enrichmentScore,decreasing = T),]
gseap <- gseao[c(1:10,nrow(gseao)),]
gseap$group <- c(rep(1,10),-1)
#gsea_plot<- 
ggplot(gseap, aes(x=enrichmentScore, y=ID, fill=group)) + 
  geom_bar(stat="identity")+ 
  scale_fill_gradient(low="blue",high="red",guide = FALSE)
  theme_bw()+theme(plot.title = element_text(hjust = 0.5))+
  ggtitle("GSEA_top10") 
ggplot(gseap, aes(x=reorder(ID,order(enrichmentScore, decreasing = F)), y=enrichmentScore, fill=group)) + 
    geom_bar(stat="identity") + 
    scale_fill_gradient(low="blue",high="red",guide = FALSE) + 
    scale_x_discrete(name ="Pathway names") +
    scale_y_continuous(name ="log10P-value") +
    coord_flip() + theme_bw()+theme(plot.title = element_text(hjust = 0.5))+
    ggtitle("Pathway Enrichment")
