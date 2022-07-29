#!/usr/bin/env Rscript

library(tidyverse)

# Argument parsing --------------------------------------------------------

if (FALSE) {
  "USAGE: Rscript $0 --metafile Clavispora_metadata.tab --genomeInfo Total_Genomic_statistic.tsv --out Clavispora_metadata_Full.tab "
  "        --working_directory $PWD "
}
parser <- argparse::ArgumentParser()
parser$add_argument(
    "--metafile", "-m", type="character", 
    default="Clavispora_metadata.tab",
    help = "meta file"
) 

parser$add_argument(
    "--genomeInfo", "-g", type="character",
    default = "Total_Genomic_statistic.tsv",
    help = ""
)

parser$add_argument(
    "--out", "-o", type="character",
    default = "Clavispora_metadata_Full.tab",
    help = ""
)

parser$add_argument(
    "--working_directory", "-w", type="character", 
    default="",
    help = ""
)
args <- parser$parse_args()

setwd(args$working_directory)

# -------------------------------------------------------------------------
data1 <- read_tsv(args$metafile)

data1$GCAID <- str_remove(
  data1$assembly_accession,
  pattern = "_"
) %>% 
  str_split(
    .,
    pattern = "\\.",
    simplify = TRUE
  ) %>% 
  .[,1]

data1 <- data1 %>% 
  select(
    GCAID,
    refseq_category, organism_name, 
    infraspecific_name, assembly_level,
    genome_rep, 
  )

data2 <- read_tsv(args$genomeInfo)


myData <- left_join(
  data1, data2
)

write_tsv(myData, args$out)
