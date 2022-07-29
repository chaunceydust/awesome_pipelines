#!/usr/bin/env Rscript

library(tidyverse)

# Argument parsing --------------------------------------------------------

parser <- argparse::ArgumentParser()

parser$add_argument(
  "--working_directory",
  type="character",
  default="",
  help = ""
)
args <- parser$parse_args()
setwd(args$working_directory)


data_seq <- read_tsv(
  "Total.oriID.fa",
  col_names = c("GeneID", "sequence")
)
dataID <- read_tsv(
  "Total_sequences_refID.txt"
) |> 
  select(-length)

data <- full_join(dataID, data_seq)
data$SEQ <- paste0(
  ">",
  data$OGID,
  "\n",
  data$sequence
)
data <- select(data, SEQ)
write_tsv(data, "Total.OGID.fa", col_names = FALSE)
