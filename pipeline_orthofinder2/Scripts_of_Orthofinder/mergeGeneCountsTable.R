#!/usr/bin/env Rscript


library(tidyverse)

# Argument parsing --------------------------------------------------------

parser <- argparse::ArgumentParser()
parser$add_argument(
  "--GeneCount", 
  type="character",
  default="Orthogroups.GeneCount.tsv",
  help = ""
)
parser$add_argument(
  "--UnassignedGenes",
  type="character",
  default="Orthogroups_UnassignedGenes.tsv",
  help = ""
)
parser$add_argument(
  "--Out",
  type="character",
  default="Total.GeneCount.tsv",
  help = ""
)
parser$add_argument(
  "--working_directory", 
  type="character",
  default="",
  help = ""
)
args <- parser$parse_args()
setwd(args$working_directory)

# ---------------------------------------------------------------------------------
system(paste0("sed -i 's/_proteins//g' ", args$GeneCount)) && cat("GeneCount complete!") 
system(paste0("sed -i 's/_proteins//g' ", args$UnassignedGenes)) && cat("UnassignedGenes complete!")

data2 <- read_tsv(args$UnassignedGenes) %>% 
  column_to_rownames("Orthogroup")

data2[!is.na(data2)] <- 1
data2[is.na(data2)] <- 0
data2 <- data2 %>% 
  rownames_to_column("Orthogroup")
write_tsv(data2, "test.txt")


data2 <- read_tsv("test.txt")
file.remove("test.txt")
data3 <- read_tsv(args$GeneCount) %>% 
  select(-Total)

data <- bind_rows(data3, data2)

write_tsv(data, args$Out)

