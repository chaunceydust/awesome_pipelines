#!/usr/bin/env Rscript
args = commandArgs(T)
setwd(args[1])

input = read.table(args[2], sep="\t", header=T)
input$pathway_id <- sub("ko", "map",
                        input$pathway_id)
db = read.table(args[4], sep="\t", header=T, quote="")
data = merge(input, db, by.x="pathway_id", by.y="map_id", all.x = T)

write.table(data, file=args[3], quote=F, row.names=F, sep="\t")
