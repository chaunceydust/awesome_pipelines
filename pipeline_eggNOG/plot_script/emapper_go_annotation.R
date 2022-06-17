#!/usr/bin/env Rscript
args = commandArgs(T)
setwd(args[1])

input = read.table(args[2], sep="\t", header=T)
db = read.table(args[4], sep="\t", header=T, quote="")
data = merge(input, db, by="go_id", all.input = T, all = F)
# all=F 舍弃未匹配的

write.table(data, file=args[3], quote=F, row.names=F, sep="\t")
