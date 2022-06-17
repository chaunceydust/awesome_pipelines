count <- read.csv('count.csv',header = T,row.names = 1) #221618
count <- count[,c(3:4,1:2)]

#基因筛选
s <- rowSums (count, na.rm = FALSE, dims = 1)
count <- count[s!=0,] # 剔除在全部样本中无表达的基因，剩余63460
Expr<-count[apply(count, 1, function(x){
  sum(x>1)>2}),]  #选择至少在两个样本中有表达的，共计25206个

group <- rep(c('SUZ','ctrl'),each = 2)
group <- factor(group,levels = c('SUZ','ctrl'),labels =c('SUZ','ctrl') )
colnames(Expr) <- paste(group,c(1,2),sep = '_')

save(group,Expr,file = 'step1.Rdata')
