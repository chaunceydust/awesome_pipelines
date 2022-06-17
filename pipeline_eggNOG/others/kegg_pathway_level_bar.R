#!/usr/bin/env Rscript

args = commandArgs(T)
route_file = unlist(strsplit(args[1], "/"))
route = paste(route_file[1:(length(route_file)-1)], collapse="/")
setwd(route)
file_name = route_file[length(route_file)]

library(ggplot2)
data = read.table(file_name, header=T, sep="\t")

data = data[, c(3, 4)]

df <- data[!duplicated(data[, 2]),]  # 去重，不排序
df$count <- as.numeric(table(data[, 2])[df[, 2]])  # 去重计数，排序，索引，取值
df = na.omit(df)

high = 7
if(length(df[,1]) >= 26)
{
    high = round(length(df[,1])/40)*7
}
data = df
data_sort = df[order(data[,1], data[,3], decreasing=F),]
result = ggplot(data_sort, aes(x = level_2, y = count, fill=level_1)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    #theme(axis.text.x=element_text(angle=45, hjust=1)) +
    #angle：调整横轴标签倾斜角度
    labs(x = "KEGG level2", y = "KEGG level2 count", fill = "KEGG level1") +
    scale_x_discrete(limits=factor(data_sort[, 2])) +
    #scale_y_continuous(expand=c(0, 0)) +
    theme(panel.grid=element_blank(), panel.background=element_rect(color='black', fill='transparent'))
ggsave(result, filename = paste(args[2], "pdf", sep="."), height = high, width = 7)
ggsave(result, filename = paste(args[2], "png", sep="."), height = high, width = 7)
