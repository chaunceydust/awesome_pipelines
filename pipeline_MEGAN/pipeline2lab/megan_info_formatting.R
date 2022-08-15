#!/usr/bin/env Rscript
 
library(tidyverse)
# library(phyloseq)
 
parser <- argparse::ArgumentParser()
parser$add_argument(
  "--working_directory",
  type = "character",
  default = "A",
  help = "taxonomy annotation file with full path"
)
args <- parser$parse_args()
 
setwd(args$working_directory)
 
myPath <- getwd()
fl.0 =dir(
  myPath,
  pattern = c("Reads2Taxonomy.txt$"),
  full.names = TRUE,
  ignore.case = TRUE
)
 
 
for (i in 1:length(fl.0)) {
 
  file = fl.0[i]
  samp.name <- str_split(
    basename(file),
    ".Reads2Taxonomy.txt",
    simplify = TRUE
  ) %>% .[1, 1]
 
 
  CleanReads <- read_tsv(
    file,
    col_names = c("X1", "X2", "X3"),
    comment = "#"
  ) %>%
    # .[str_length(otut$X1) > 1,] %>%
    filter(
      X2 %in% c("D", "K", "P", "C", "O", "F", "G", "S")
    ) %>%
    distinct(
      X1, X3, .keep_all = TRUE
    ) %>%
    select(X1, X3) %>%
    rename(Gene_ID = X1) %>%
    rename(Lineage = X3) %>%
    write_tsv(
      .,
      paste0(samp.name, ".Reads2TaxonomyLineage.txt"),
      col_names = TRUE
    )
 
  CleanTaxonomyRank <- CleanReads %>%
    mutate(
      Lineage = str_remove(Lineage, pattern = ";$")
    ) %>%
    separate(
      .,
      col = Lineage,
      into = c(
        "Domain","Kingdom","Phylum","Class",
        "Order","Family","Genus","Species"
      ),
      sep = ";",
      remove = FALSE
    )
 
 
 
    for (rank in c("Domain","Kingdom","Phylum","Class",
                   "Order","Family","Genus","Species")) {
      CleanTaxonomyRank %>%
        select(Gene_ID, all_of(rank)) %>%
        filter(!is.na(.[[2]])) %>%
        write_tsv(
          paste0(samp.name, ".Reads2", rank, ".txt")
        )
    }
 
 
}
