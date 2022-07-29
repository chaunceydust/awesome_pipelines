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


dataID <- read_tsv(
  "Total_sequences_refID2oriID.txt",
  col_names = c("OGID", "GeneID")
) |> 
  distinct()
dataLength <- read_tsv(
  "PepSequencesLength.txt",
  col_names = c("GeneID", "length")
)

data_full <- full_join(dataID, dataLength) |> 
  arrange(OGID, desc(length))

write_tsv(data_full, "Total_sequences_refID2oriID2.txt")
data_ref <- data_full |> 
  group_by(OGID) |> 
  slice_head(n = 1) |> 
  ungroup()
write_tsv(data_ref, "Total_sequences_refID.txt")

ID.list <- data_ref |> 
  select(GeneID) |> 
  write_tsv("GeneID.list", col_names = FALSE)

