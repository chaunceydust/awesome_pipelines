load('resOrdered_id.Rdata')
library(clusterProfiler)
library(org.Hs.eg.db)
library('ggplot2')
library('ggpubr')

gene_up= resOrdered[resOrdered$change == 'Up','entrezgene_id'] 
gene_down=resOrdered[resOrdered$change == 'Down','entrezgene_id'] 
gene_diff=c(gene_up,gene_down)
gene_all=as.character(resOrdered[ ,'entrezgene_id'] )

geneList=resOrdered$log2FoldChange
names(geneList)=resOrdered$entrezgene_id
geneList=sort(geneList,decreasing = T)

## KEGG pathway analysis
### 做KEGG数据集超几何分布检验分析，重点在结果的可视化及生物学意义的理解。
if(T){
  ###   over-representation test
  kk.up <- enrichKEGG(gene         = gene_up,
                      organism     = 'hsa',
                      universe     = gene_all,
                      pvalueCutoff = 0.9,
                      qvalueCutoff =0.9)
  head(kk.up)[,1:6]
  d1 <- dotplot(kk.up,title = 'gene_up' ) #;ggsave('kk.up.dotplot.png')
  kk.down <- enrichKEGG(gene         =  gene_down,
                        organism     = 'hsa',
                        universe     = gene_all,
                        pvalueCutoff = 0.9,
                        qvalueCutoff =0.9)
  head(kk.down)[,1:6]
  d2 <- dotplot(kk.down,title = 'gene_down' ) #;ggsave('kk.down.dotplot.png')
  d <- ggarrange(d1,d2,nrow = 2)
  ggsave('kegg_dotplot.png',width = 180,height = 180,units = 'mm')
  kk.diff <- enrichKEGG(gene         = gene_diff,
                        organism     = 'hsa',
                        #universe     = gene_all,
                        pvalueCutoff = 0.53,
                        qvalueCutoff =0.5)
  View(kk.diff@result)
  head(kk.diff)[,1:6]
  write.csv(kk.diff@result,'kegg_result.csv')
  dotplot(kk.diff );ggsave('kk.diff.dotplot.png')
  
  kegg_diff_dt <- as.data.frame(kk.diff)
  kegg_down_dt <- as.data.frame(kk.down)
  kegg_up_dt <- as.data.frame(kk.up)
  down_kegg<-kegg_down_dt[kegg_down_dt$pvalue<0.05,];down_kegg$group=-1
  up_kegg<-kegg_up_dt[kegg_up_dt$pvalue<0.05,];up_kegg$group=1
  source('functions.R')
  g_kegg=kegg_plot(up_kegg,down_kegg)
  print(g_kegg)
  
  ggsave(g_kegg,filename = 'kegg_up_down.png')
}

### GO database analysis 
### 做GO数据集超几何分布检验分析，重点在结果的可视化及生物学意义的理解。
GO <- enrichGO(gene_diff,
               OrgDb = org.Hs.eg.db,
               keyType = 'ENTREZID',
               ont = 'ALL',
               pvalueCutoff = 0.05,
               qvalueCutoff = 0.05,
               readable = T)
GO2 <- enrichGO(gene_diff,
               OrgDb = org.Hs.eg.db,
               keyType = 'ENTREZID',
               ont = 'ALL',
               pvalueCutoff = 0.9,
               qvalueCutoff = 0.9,
               readable = T)
View(GO2@result)
write.csv(GO2,'go_result2.csv')
barplot(GO2,split='ONTOLOGY')+facet_grid(ONTOLOGY~.,scales = 'free')
dotplot(GO2,split='ONTOLOGY')+facet_grid(ONTOLOGY~.,scales = 'free')

#GO_up_down
{
  
  g_list=list(gene_up=gene_up,
              gene_down=gene_down,
              gene_diff=gene_diff)
  
  if(F){
    go_enrich_results <- lapply( g_list , function(gene) {
      lapply( c('BP','MF','CC') , function(ont) {
        cat(paste('Now process ',ont ))
        ego <- enrichGO(gene          = gene,
                        universe      = gene_all,
                        OrgDb         = org.Hs.eg.db,
                        ont           = ont ,
                        pAdjustMethod = "BH",
                        pvalueCutoff  = 0.99,
                        qvalueCutoff  = 0.99,
                        readable      = TRUE)
        
        print( head(ego) )
        return(ego)
      })
    })
    save(go_enrich_results,file = 'go_enrich_results.Rdata')
    
  }
  
  
  load(file = 'go_enrich_results.Rdata')
  
  n1= c('gene_up','gene_down','gene_diff')
  n2= c('BP','MF','CC') 
  for (i in 1:3){
    for (j in 1:3){
      fn=paste0('dotplot_',n1[i],'_',n2[j],'.png')
      cat(paste0(fn,'\n'))
      png(fn,res=150,width = 1080)
      print( dotplot(go_enrich_results[[i]][[j]] ))
      dev.off()
    }
  }
  
  
}