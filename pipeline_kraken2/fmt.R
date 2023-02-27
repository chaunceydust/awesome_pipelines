#!/usr/bin/env Rscript

library(data.table)
library(stringr)
library(optparse)
library(tidyr)
rr <- fread("spdb.txt", header = F, data.table = F, sep = "\t")
rr <- separate(data = rr, col = "V2", into = c("K", "P", "C", "O", "FF", "G", "S", "T"), sep = "[|]")

rr$P <- ifelse(str_detect(rr$P, pattern = "unclassified"), paste("p__unclassified__", rr$K, sep = ""), rr$P)
rr$C <- ifelse(str_detect(rr$C, pattern = "unclassified"), paste("c__unclassified__", rr$P, sep = ""), rr$C)
rr$O <- ifelse(str_detect(rr$O, pattern = "unclassified"), paste("o__unclassified__", rr$C, sep = ""), rr$O)
rr$FF <- ifelse(str_detect(rr$FF, pattern = "unclassified"), paste("f__unclassified__", rr$O, sep = ""), rr$FF)
rr$G <- ifelse(str_detect(rr$G, pattern = "unclassified"), paste("g__unclassified__", rr$FF, sep = ""), rr$G)
rr$S <- ifelse(str_detect(rr$S, pattern = "unclassified"), paste("s__unclassified__", rr$G, sep = ""), rr$S)
rr$T <- ifelse(str_detect(rr$T, pattern = "unclassified"), paste("T__unclassified__", rr$S, sep = ""), rr$T)

mydbpy <- unite(data = rr, "taxonomy", "K", "P", "C", "O", "FF", "G", "S", "T", sep = "|")
names(mydbpy)[1] <- "spid"
write.table(mydbpy, "dbpy.txt", sep = "\t", col.names = T, row.names = F, quote = F)

