#!/usr/bin/env Rscript
args = commandArgs(T)
setwd(args[1])

library(clusterProfiler)

input = read.table(args[2], sep="\t", header=T)
db = bitr_kegg(input$k_id,
               "kegg", "Path", "ko")
name <- ko2name(db$Path)

# db = read.table(args[4], sep="\t", header=T, quote="")
data = merge(input, db, 
             by.x = "k_id", by.y = "kegg",
             all = F)

write.table(data, file=args[3], quote=F, row.names=F, sep="\t")

