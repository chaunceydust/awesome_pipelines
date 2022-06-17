rm(list = ls())
load('step3_diff.Rdata')

#volumn plot
library(ggplot2)
volcano_plot <- ggplot(data = resOrdered, 
                       aes(x = log2FoldChange, 
                           y = -log10(pvalue))) +
  geom_point(alpha=0.4, size=3.5, 
             aes(color=change)) +
  scale_color_manual(values=c("blue", "grey","red"))+
  geom_vline(xintercept=c(-1,1),lty=4,col="grey",lwd=0.8) +
  geom_hline(yintercept = -log10(0.05),lty=4,col="grey",lwd=0.8) +
  theme_bw()+ labs(title="Volcano Plot",x=expression(log[2](FC)), y=expression(-log[10](pvalue)))
#这里根据筛选差异miRNA的筛选阈值，绘制了渐近线
#labs(x=expression(log[2](FC)), y=expression(-log[10](FDR)))使用这个命令，可以让log的书写更加美丽
volcano_plot
ggsave("volcano plot.png", width = 4 ,height = 5) #保存图片

#heatmap
library(pheatmap)
expr_diff <- Expr[rownames(diff_gene),]
annotation_col = data.frame(group)
rownames(annotation_col) = colnames(expr_diff)

pheatmap(expr_diff,scale = "row",show_rownames=F,cutree_col = 2,annotation_col = annotation_col,
         main = 'heatmap for different expression',
         cellwidth = 84, cellheight = 2, filename = "heatmap.png")

