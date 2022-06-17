rm(list = ls())
load('step1.Rdata')
library(pheatmap)

#样本相关性分析
cordata <- cor(Expr,method = 'pearson')
cor2 <- cordata*cordata
pheatmap(cordata, display_numbers = TRUE,number_color = "white",
         cluster_row = FALSE, cluster_cols = F, border_color = "grey",
         main = 'Correlation test between samples',
         cellwidth = 80, cellheight = 48, fontsize = 12, filename = "cortest.png")
pheatmap(cor2, display_numbers = TRUE,number_color = "white",
         cluster_row = FALSE, cluster_cols = F, border_color = "grey",
         main = 'Correlation test between samples',
         cellwidth = 80, cellheight = 48, fontsize = 12, filename = "cor2test.png")

#pca
library("FactoMineR")#进行PCA分析
library("factoextra")#PCA可视化
Exprset_PCA.pca <- PCA(as.data.frame(t(Expr)), graph = F)
fviz_pca_ind(Exprset_PCA.pca,
             title = "Principal Component Analysis",
             geom.ind = "point", # show points only (nbut not "text"),这里c("point", "text)2选1
             col.ind = group, # color by groups
             # palette = c("#00AFBB", "#E7B800"),自定义颜色
             addEllipses = F, # Concentration ellipses加圆圈
             legend.title = "Groups")
ggsave('pca.png',width = 5,height = 3)




